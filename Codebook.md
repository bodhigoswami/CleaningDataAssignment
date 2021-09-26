---
title: "Code Book - UCI HAR_Data set"
author: "Bodhi Goswami"
date: "9/25/2021"
output:
  html_document: 
    theme: cerulean
---

Comprehensive List of Variables in cleaned UCI HAR_Data set. Please refer to original experiment results for matching variable names with this table.

### List of Variables and their Description

```{r}
  load("click.RData")
  library(dplyr)
  data.frame(Variable = names(HAR_perSubject), Description = original_columns) 
```

All units to match original Data. Please refer to experimental results for further info.

Thanks.
