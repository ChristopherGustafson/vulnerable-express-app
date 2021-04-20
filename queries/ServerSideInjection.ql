/**
 * @name Cross site-scripting
 * @kind path-problem
 * @problem.serverity error
 * @precision high
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class XSSConfiguration extends TaintTracking::Configuration {
  XSSConfiguration() { this = "XSSConfiguration" }

  // Consider remote flow data (e.q. URL parameters)
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  // First argument to res.send(...) is our sink
  override predicate isSink(DataFlow::Node sink) {
    sink =
      moduleImport("express")
          .getACall()
          .getAMemberCall("get")
          .getABoundCallbackParameter(1, 1)
          .getAMemberCall("send")
          .getArgument(0)
  }
}

from XSSConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "XSS vulnerability due to user-provided value"
