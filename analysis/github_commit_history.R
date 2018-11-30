
##devtools::install_github("ropensci/ghql")


library("ghql")
library("jsonlite")
library("tidyverse")
library("glue")
library("httr")

# initialize client

#need a personal access token for Github stored as environment variable

token <- Sys.getenv("GITHUB_PAT")
cli <- GraphqlClient$new(
  url = "https://api.github.com/graphql",
  headers = add_headers(Authorization = paste0("Bearer ", token))
)

cli$load_schema()



owner <- "ropenscilabs"
repo <- "learngganimate"
branch <- "master"

history_template <- "first: 100"
has_more <- TRUE
github_log <- tibble(.rows = 0 )


query_template <- '
{
  repository(owner: "<<owner>>", name: "<<repo>>") {
    ref(qualifiedName: "refs/heads/<<branch>>") {
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

while(has_more) {


      qry <- Query$new()
      qry$query('getlog',
                glue(.open = "<<" ,
                     .close = ">>",
                     query_template)
                )
      
      
      log_data <- cli$exec(qry$queries$getlog) 
      
      log_data_from_json <- 
        jsonlite::fromJSON(log_data, flatten = TRUE) 
      
      
      github_log <- dplyr::bind_rows(github_log,
                                     log_data_from_json$data$repository$ref$target$history$edges %>% 
                                           unnest()
                                     )
      
      has_more <- log_data_from_json$data$repository$ref$target$history$pageInfo$hasNextPage
      cursor  <- log_data_from_json$data$repository$ref$target$history$pageInfo$endCursor
      history_template <- glue('first: 100, after:"{cursor}"')
}
  
names(github_log) <- c("commit_id" ,
                       "additions" ,
                       "changed_files" ,
                       "deletions" ,
                       "commit_message",
                       "author_avatar_url",
                       "commit_date",
                       "author_name",
                       "parent_commit")  

saveRDS(github_log,"analysis/github_log.RDS")


github_log <- readRDS("analysis/github_log.RDS")


