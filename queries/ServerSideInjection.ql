/**
 * @name Server side template injection
 * @kind path-problem
 * @problem.serverity error
 * @precision high
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class ServerSideTemplateInjectionConfiguration extends TaintTracking::Configuration {
  ServerSideTemplateInjectionConfiguration() { this = "ServerSideTeplateInjctionConfiguration" }

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

from
  ServerSideTemplateInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Server side template injection vulnerability due to user-provided value"
