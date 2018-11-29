
##devtools::install_github("ropensci/ghql")


library("ghql")
library("jsonlite")
library("glue")
# initialize client
library("httr")
token <- Sys.getenv("GITHUB_PAT")
cli <- GraphqlClient$new(
  url = "https://api.github.com/graphql",
  headers = add_headers(Authorization = paste0("Bearer ", token))
)

cli$load_schema()




history_template <- "first: 100"

query_template <- '
{
  repository(owner: "ropenscilabs", name: "learngganimate") {
    ref(qualifiedName: "refs/heads/master") {
      target {
        ... on Commit {
          history(<<history_template>>) {
            pageInfo {
              startCursor
              hasNextPage
              endCursor
            }
            totalCount
            edges {
              
              node {
                abbreviatedOid
                additions
                changedFiles
                deletions
                message
                author {
                  avatarUrl
                  date
                  name
                }
                parents(first: 1) {
                  edges {
                    node {
                      abbreviatedOid
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  rateLimit {
    limit
    cost
    remaining
    resetAt
  }
}'

qry <- Query$new()
qry$query('getlog',
          glue(.open = "<<" ,
               .close = ">>",
               query_template)
)
log_data <- cli$exec(qry$queries$getlog) 

 log_data_from_json <- 
jsonlite::fromJSON(log_data, flatten = TRUE) 


github_log <- log_data_from_json$data$repository$ref$target$history$edges %>% 
  unnest() 

has_more <- log_data_from_json$data$repository$ref$target$history$pageInfo$hasNextPage
cursor  <- log_data_from_json$data$repository$ref$target$history$pageInfo$endCursor

while(has_more) {
  history_template <- glue('first: 100, after:"{cursor}"')

  qry <- Query$new()
  qry$query('getlog',
            glue(.open = "<<" ,
                 .close = ">>",
                 query_template)
            )


log_data <- cli$exec(qry$queries$getlog) 

log_data_from_json <- 
  jsonlite::fromJSON(log_data, flatten = TRUE) 


github_log <- dplyr::bind_rows(github_log, log_data_from_json$data$repository$ref$target$history$edges %>% 
  unnest() )

has_more <- log_data_from_json$data$repository$ref$target$history$pageInfo$hasNextPage
cursor  <- log_data_from_json$data$repository$ref$target$history$pageInfo$endCursor
}

saveRDS(github_log,"analysis/github_log.RDS")


