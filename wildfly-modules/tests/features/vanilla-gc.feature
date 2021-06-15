Feature: Openshift OpenJDK GC tests

  Scenario: Check default GC configuration
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:\+UseParallelOldGC\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:\+ExitOnOutOfMemoryError\s

  Scenario: Check GC_MIN_HEAP_FREE_RATIO GC configuration
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
       | variable                         | value  |
       | GC_MIN_HEAP_FREE_RATIO           | 5      |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:\+UseParallelOldGC\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=5\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_MAX_HEAP_FREE_RATIO GC configuration
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
       | variable                         | value  |
       | GC_MAX_HEAP_FREE_RATIO           | 50     |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:\+UseParallelOldGC\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=50\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_TIME_RATIO GC configuration
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
       | variable                         | value  |
       | GC_TIME_RATIO                    | 5      |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:\+UseParallelOldGC\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=5\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_ADAPTIVE_SIZE_POLICY_WEIGHT GC configuration
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
       | variable                         | value  |
       | GC_ADAPTIVE_SIZE_POLICY_WEIGHT   | 80     |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:\+UseParallelOldGC\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=80\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_METASPACE_SIZE and GC_MAX_METASPACE_SIZE GC configuration
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
       | variable                 | value  |
       | GC_METASPACE_SIZE        | 60     |
       | GC_MAX_METASPACE_SIZE    | 120    |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:\+UseParallelOldGC\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=60m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxMetaspaceSize=120m\s

  Scenario: Check for adjusted heap sizes
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2 without running
    When container integ- is started with args
      | arg       | value                                                    |
      | mem_limit | 1073741824                                               |
      | env_json  | {"JAVA_MAX_MEM_RATIO": 25, "JAVA_INITIAL_MEM_RATIO": 50} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -Xms128m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -Xmx256m\s

  # CLOUD-193 (mem-limit); CLOUD-459 (default heap size == max)
  Scenario: CLOUD-193 Check for dynamic resource allocation
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2 without running
    When container integ- is started with args
      | arg                    | value             |
      | mem_limit              | 1073741824        |
    Then container log should match regex ^ *JAVA_OPTS: *.* -Xms128m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -Xmx512m\s

  # CLOUD-459 (override default heap size)
  Scenario: CLOUD-459 Check for adjusted default heap size
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2 without running
    When container integ- is started with args
      | arg       | value                         |
      | mem_limit | 1073741824                    |
      | env_json  | {"INITIAL_HEAP_PERCENT": 0.5} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -Xms256m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -Xmx512m\s

  Scenario: CLOUD-1524, test JAVA_CORE_LIMIT
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2
      | variable              | value    |
      | JAVA_CORE_LIMIT       | 3        |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:ParallelGCThreads=3\s
     And container log should match regex ^ *JAVA_OPTS: *.* -Djava.util.concurrent.ForkJoinPool.common.parallelism=3\s
     And container log should match regex ^ *JAVA_OPTS: *.* -XX:CICompilerCount=2\s

  Scenario: CLOUD-1524, test JAVA_CORE_LIMIT < CONTAINER_CORE_LIMIT
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2 without running
    When container integ- is started with args and env
      | arg_env              | value    |
      | arg_cpu_quota        | 20000    |
      | arg_cpu_period       | 5000     |
      | env_JAVA_CORE_LIMIT  | 2        |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:ParallelGCThreads=2\s
     And container log should match regex ^ *JAVA_OPTS: *.* -Djava.util.concurrent.ForkJoinPool.common.parallelism=2\s
     And container log should match regex ^ *JAVA_OPTS: *.* -XX:CICompilerCount=2\s

  Scenario: CLOUD-1524, test JAVA_CORE_LIMIT > CONTAINER_CORE_LIMIT
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2 without running
    When container integ- is started with args and env
      | arg_env              | value    |
      | arg_cpu_quota        | 20000    |
      | arg_cpu_period       | 5000     |
      | env_JAVA_CORE_LIMIT  | 6        |
   Then container log should match regex ^ *JAVA_OPTS: *.* -XX:ParallelGCThreads=4\s
    And container log should match regex ^ *JAVA_OPTS: *.* -Djava.util.concurrent.ForkJoinPool.common.parallelism=4\s
    And container log should match regex ^ *JAVA_OPTS: *.* -XX:CICompilerCount=2\s

  Scenario: CLOUD-1524, test CONTAINER_CORE_LIMIT
    Given s2i build git://github.com/jfdenise/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using wildfly-s2i-v2 without running
    When container integ- is started with args
      | arg                  | value    |
      | cpu_quota            | 20000    |
      | cpu_period           | 5000     |
   Then container log should match regex ^ *JAVA_OPTS: *.* -XX:ParallelGCThreads=4\s
    And container log should match regex ^ *JAVA_OPTS: *.* -Djava.util.concurrent.ForkJoinPool.common.parallelism=4\s
    And container log should match regex ^ *JAVA_OPTS: *.* -XX:CICompilerCount=2\s