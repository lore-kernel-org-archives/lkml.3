Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaJ0CQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:16:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:45365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaJ0CQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:16:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="yaml'?scan'208";a="611819023"
Date: Mon, 27 Oct 2014 10:15:43 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: LKP <lkp@linux.intel.com>, Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [mm] 3193913ce62: 4.7% will-it-scale.per_process_ops
Message-ID: <20141027021543.GE27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ2U398070+RC21q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 3193913ce62c63056bc67a6ae378beaf494afa66 ("mm: page_alloc: default node-ordering on 64-bit NUMA, zone-ordering on 32-bit")


97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
      0.08 ±  0%      +6.2%       0.08 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
      0.08            +6.2%       0.08        GEO-MEAN will-it-scale.scalability

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    238085 ±  0%      +4.7%     249169 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
    238085            +4.7%     249169        GEO-MEAN will-it-scale.per_process_ops

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    210740 ±  0%      +2.2%     215479 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
    210740            +2.2%     215479        GEO-MEAN will-it-scale.per_thread_ops

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      2733 ±  0%      -1.6%       2689 ±  0%  client7/netperf/performance-900s-200%-TCP_STREAM
      2733            -1.6%       2689        GEO-MEAN netperf.Throughput_Mbps

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         4 ± 40%    +2e+09%   92498119 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
         4          +2e+09%   92498119        GEO-MEAN proc-vmstat.pgalloc_dma32

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         3 ± 45%     -73.7%          1 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
         3           -73.7%          1        GEO-MEAN sched_debug.cfs_rq[33]:/.runnable_load_avg

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      4069 ± 33%    +201.3%      12262 ± 49%  lkp-wsx01/will-it-scale/performance-page_fault1
      4069          +201.3%      12262        GEO-MEAN sched_debug.cpu#25.sched_goidle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      8353 ± 33%    +195.8%      24712 ± 48%  lkp-wsx01/will-it-scale/performance-page_fault1
      8353          +195.8%      24712        GEO-MEAN sched_debug.cpu#25.nr_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      8388 ± 33%    +195.2%      24763 ± 48%  lkp-wsx01/will-it-scale/performance-page_fault1
      8388          +195.2%      24763        GEO-MEAN sched_debug.cpu#25.sched_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    544767 ± 41%     -54.8%     246478 ± 47%  client7/netperf/performance-900s-200%-TCP_STREAM
    544767           -54.8%     246478        GEO-MEAN cpuidle.C1-NHM.time

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         3 ± 19%     -57.9%          1 ± 30%  lkp-wsx01/will-it-scale/performance-page_fault1
         3           -57.9%          1        GEO-MEAN sched_debug.cfs_rq[30]:/.runnable_load_avg

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         4 ± 15%     -55.0%          1 ± 41%  lkp-wsx01/will-it-scale/performance-page_fault1
         4           -55.0%          1        GEO-MEAN sched_debug.cpu#30.cpu_load[0]

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         4 ± 35%     -60.9%          1 ± 41%  lkp-wsx01/will-it-scale/performance-page_fault1
         4           -60.9%          1        GEO-MEAN sched_debug.cpu#22.cpu_load[0]

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      3784 ± 35%    +138.2%       9015 ± 49%  lkp-wsx01/will-it-scale/performance-page_fault1
      3784          +138.2%       9015        GEO-MEAN sched_debug.cpu#29.sched_goidle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      1704 ± 36%     +82.4%       3109 ± 32%  lkp-wsx01/will-it-scale/performance-page_fault1
      1704           +82.4%       3109        GEO-MEAN sched_debug.cpu#22.ttwu_local

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      7771 ± 34%    +134.1%      18194 ± 48%  lkp-wsx01/will-it-scale/performance-page_fault1
      7770          +134.1%      18194        GEO-MEAN sched_debug.cpu#29.nr_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      7806 ± 34%    +133.3%      18216 ± 48%  lkp-wsx01/will-it-scale/performance-page_fault1
      7806          +133.3%      18216        GEO-MEAN sched_debug.cpu#29.sched_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
        44 ± 16%     -49.5%         22 ± 15%  client7/netperf/performance-900s-200%-TCP_STREAM
        44           -49.5%         22        GEO-MEAN sched_debug.cpu#11.nr_uninterruptible

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      1679 ± 12%     -32.6%       1131 ± 13%  lkp-wsx01/will-it-scale/performance-page_fault1
      1678           -32.6%       1131        GEO-MEAN sched_debug.cpu#33.curr->pid

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
        29 ± 14%     -34.9%         19 ± 19%  lkp-wsx01/will-it-scale/performance-page_fault1
        29           -34.9%         18        GEO-MEAN sched_debug.cfs_rq[51]:/.nr_spread_over

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      1516 ± 24%     -23.5%       1160 ± 21%  lkp-wsx01/will-it-scale/performance-page_fault1
      1516           -23.5%       1160        GEO-MEAN sched_debug.cpu#37.curr->pid

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      4991 ± 15%     +42.4%       7106 ± 21%  lkp-wsx01/will-it-scale/performance-page_fault1
      4991           +42.4%       7106        GEO-MEAN sched_debug.cpu#22.ttwu_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
        18 ± 24%     +42.4%         26 ± 23%  lkp-wsx01/will-it-scale/performance-page_fault1
        18           +42.4%         26        GEO-MEAN sched_debug.cpu#51.cpu_load[3]

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      2077 ± 15%     -34.3%       1365 ± 16%  lkp-wsx01/will-it-scale/performance-page_fault1
      2077           -34.3%       1365        GEO-MEAN sched_debug.cpu#30.curr->pid

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      6608 ± 13%     +30.9%       8648 ± 21%  lkp-wsx01/will-it-scale/performance-page_fault1
      6608           +30.9%       8648        GEO-MEAN sched_debug.cpu#22.sched_goidle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     13690 ± 13%     +29.8%      17766 ± 20%  lkp-wsx01/will-it-scale/performance-page_fault1
     13690           +29.8%      17765        GEO-MEAN sched_debug.cpu#22.nr_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     13732 ± 13%     +29.6%      17792 ± 20%  lkp-wsx01/will-it-scale/performance-page_fault1
     13732           +29.6%      17792        GEO-MEAN sched_debug.cpu#22.sched_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      6728 ± 17%     -21.9%       5252 ± 10%  client7/netperf/performance-900s-200%-TCP_STREAM
      6728           -21.9%       5252        GEO-MEAN cpuidle.C6-NHM.usage

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      5777 ± 16%     +46.6%       8469 ± 23%  lkp-wsx01/will-it-scale/performance-page_fault1
      5777           +46.6%       8469        GEO-MEAN sched_debug.cpu#21.sched_goidle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     12608 ± 14%     +42.5%      17962 ± 22%  lkp-wsx01/will-it-scale/performance-page_fault1
     12607           +42.5%      17962        GEO-MEAN sched_debug.cpu#21.nr_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     12665 ± 14%     +42.0%      17983 ± 22%  lkp-wsx01/will-it-scale/performance-page_fault1
     12665           +42.0%      17983        GEO-MEAN sched_debug.cpu#21.sched_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
  41168114 ± 17%     -27.5%   29866057 ±  7%  client7/netperf/performance-900s-200%-TCP_STREAM
  41168114           -27.5%   29866057        GEO-MEAN cpuidle.C6-NHM.time

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      1848 ± 19%     -26.0%       1367 ± 23%  lkp-wsx01/will-it-scale/performance-page_fault1
      1848           -26.0%       1367        GEO-MEAN sched_debug.cpu#29.curr->pid

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     59132 ±  0%     -25.8%      43889 ±  0%  client7/netperf/performance-900s-200%-TCP_STREAM
     59132           -25.8%      43889        GEO-MEAN numa-vmstat.node0.numa_interleave

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         8 ± 21%     -34.9%          5 ± 18%  lkp-wsx01/will-it-scale/performance-page_fault1
         8           -34.9%          5        GEO-MEAN sched_debug.cpu#65.cpu_load[0]

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         7 ±  9%     -25.6%          5 ± 16%  lkp-wsx01/will-it-scale/performance-page_fault1
         7           -25.6%          5        GEO-MEAN sched_debug.cpu#65.cpu_load[1]

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
         6 ± 12%     +29.0%          8 ± 13%  lkp-wsx01/will-it-scale/performance-page_fault1
         6           +29.0%          7        GEO-MEAN sched_debug.cpu#19.cpu_load[0]

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      2464 ±  9%     -24.6%       1857 ± 19%  lkp-wsx01/will-it-scale/performance-page_fault1
      2464           -24.6%       1857        GEO-MEAN sched_debug.cpu#21.curr->pid

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       642 ±  4%     -20.5%        511 ±  9%  lkp-wsx01/will-it-scale/performance-page_fault1
       642           -20.5%        511        GEO-MEAN slabinfo.ip_fib_trie.num_objs

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       642 ±  4%     -20.5%        511 ±  9%  lkp-wsx01/will-it-scale/performance-page_fault1
       642           -20.5%        511        GEO-MEAN slabinfo.ip_fib_trie.active_objs

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       314 ±  6%     -22.6%        243 ± 15%  lkp-wsx01/will-it-scale/performance-page_fault1
       314           -22.6%        243        GEO-MEAN sched_debug.cfs_rq[79]:/.tg_runnable_contrib

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     14409 ±  6%     -22.3%      11197 ± 14%  lkp-wsx01/will-it-scale/performance-page_fault1
     14409           -22.3%      11197        GEO-MEAN sched_debug.cfs_rq[79]:/.avg->runnable_avg_sum

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       203 ±  9%     -13.8%        175 ±  8%  lkp-wsx01/will-it-scale/performance-page_fault1
       203           -13.8%        175        GEO-MEAN sched_debug.cfs_rq[35]:/.tg_runnable_contrib

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      9346 ±  9%     -13.6%       8078 ±  8%  lkp-wsx01/will-it-scale/performance-page_fault1
      9346           -13.6%       8078        GEO-MEAN sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      0.24 ± 16%     -26.9%       0.17 ±  5%  client7/netperf/performance-900s-200%-TCP_STREAM
      0.24           -26.9%       0.17        GEO-MEAN turbostat.%c6

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     17920 ±  7%     -13.3%      15538 ±  7%  lkp-wsx01/will-it-scale/performance-page_fault1
     17920           -13.3%      15538        GEO-MEAN sched_debug.cfs_rq[65]:/.avg->runnable_avg_sum

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       389 ±  7%     -13.2%        338 ±  7%  lkp-wsx01/will-it-scale/performance-page_fault1
       389           -13.2%        338        GEO-MEAN sched_debug.cfs_rq[65]:/.tg_runnable_contrib

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      1843 ±  1%     -23.6%       1408 ±  2%  client7/netperf/performance-900s-200%-TCP_STREAM
      1295 ±  3%     -10.7%       1156 ±  3%  lkp-wsx01/will-it-scale/performance-page_fault1
      1545           -17.4%       1275        GEO-MEAN numa-vmstat.node0.nr_alloc_batch

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    426745 ± 12%     -18.6%     347562 ± 11%  lkp-wsx01/will-it-scale/performance-page_fault1
    426745           -18.6%     347562        GEO-MEAN sched_debug.cfs_rq[35]:/.min_vruntime

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       211 ±  4%     -13.4%        182 ±  7%  lkp-wsx01/will-it-scale/performance-page_fault1
       211           -13.4%        182        GEO-MEAN sched_debug.cpu#73.ttwu_local

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
   7560956 ±  0%     +18.7%    8973197 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
   7560956           +18.7%    8973197        GEO-MEAN numa-numastat.node0.local_node

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
   7566122 ±  0%     +18.7%    8978364 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
   7566122           +18.7%    8978364        GEO-MEAN numa-numastat.node0.numa_hit

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    329055 ±  9%     +23.0%     404724 ±  6%  lkp-wsx01/will-it-scale/performance-page_fault1
    329055           +23.0%     404724        GEO-MEAN softirqs.SCHED

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
   3822373 ±  0%     +17.6%    4496660 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
   3822373           +17.6%    4496660        GEO-MEAN numa-vmstat.node0.numa_hit

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
   3817085 ±  0%     +17.7%    4490957 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
   3817085           +17.7%    4490957        GEO-MEAN numa-vmstat.node0.numa_local

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
 2.358e+09 ±  0%     -15.0%  2.004e+09 ±  0%  client7/netperf/performance-900s-200%-TCP_STREAM
 2.358e+09           -15.0%  2.004e+09        GEO-MEAN proc-vmstat.pgalloc_normal

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      1777 ± 13%     +34.4%       2387 ± 16%  lkp-wsx01/will-it-scale/performance-page_fault1
      1776           +34.4%       2387        GEO-MEAN sched_debug.cpu#74.sched_goidle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    663710 ± 10%     +22.1%     810425 ±  5%  client7/netperf/performance-900s-200%-TCP_STREAM
    663710           +22.1%     810425        GEO-MEAN sched_debug.cpu#9.avg_idle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      3338 ±  0%     -13.8%       2876 ±  1%  client7/netperf/performance-900s-200%-TCP_STREAM
      3338           -13.8%       2876        GEO-MEAN proc-vmstat.nr_alloc_batch

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     47807 ±  6%     +19.2%      56984 ± 11%  lkp-wsx01/will-it-scale/performance-page_fault1
     47807           +19.2%      56984        GEO-MEAN sched_debug.cpu#25.nr_load_updates

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      3741 ± 13%     +33.3%       4985 ± 16%  lkp-wsx01/will-it-scale/performance-page_fault1
      3740           +33.3%       4985        GEO-MEAN sched_debug.cpu#74.nr_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    295529 ±  3%     +16.2%     343525 ±  3%  lkp-wsx01/will-it-scale/performance-page_fault1
    295529           +16.2%     343525        GEO-MEAN softirqs.RCU

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      3374 ±  4%      -9.0%       3070 ±  5%  client7/netperf/performance-900s-200%-TCP_STREAM
      3374            -9.0%       3070        GEO-MEAN sched_debug.cpu#4.curr->pid

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      3900 ± 12%     +31.4%       5124 ± 15%  lkp-wsx01/will-it-scale/performance-page_fault1
      3900           +31.4%       5124        GEO-MEAN sched_debug.cpu#74.sched_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     14175 ±  3%     -19.5%      11408 ± 13%  lkp-wsx01/will-it-scale/performance-page_fault1
     14175           -19.5%      11408        GEO-MEAN sched_debug.cfs_rq[78]:/.avg->runnable_avg_sum

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       308 ±  3%     -19.5%        248 ± 13%  lkp-wsx01/will-it-scale/performance-page_fault1
       308           -19.5%        248        GEO-MEAN sched_debug.cfs_rq[78]:/.tg_runnable_contrib

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    605032 ±  8%     +19.7%     723984 ± 11%  client7/netperf/performance-900s-200%-TCP_STREAM
    605032           +19.7%     723983        GEO-MEAN sched_debug.cpu#6.avg_idle

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    493721 ±  2%     -10.8%     440327 ±  3%  lkp-wsx01/will-it-scale/performance-page_fault1
    493721           -10.8%     440327        GEO-MEAN sched_debug.cfs_rq[31]:/.min_vruntime

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    691172 ±  9%     -14.7%     589776 ±  1%  lkp-wsx01/will-it-scale/performance-page_fault1
    691172           -14.7%     589776        GEO-MEAN sched_debug.cfs_rq[21]:/.min_vruntime

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
  10083100 ±  0%      -9.5%    9128227 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
  10083100            -9.5%    9128227        GEO-MEAN time.maximum_resident_set_size

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     99367 ±  3%      +8.2%     107474 ±  5%  client7/netperf/performance-900s-200%-TCP_STREAM
     99367            +8.2%     107474        GEO-MEAN sched_debug.cpu#11.ttwu_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      8369 ± 10%     +11.0%       9289 ±  2%  lkp-wsx01/will-it-scale/performance-page_fault1
      8369           +11.0%       9289        GEO-MEAN sched_debug.cpu#51.sched_count

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      8073 ± 10%     +11.1%       8968 ±  2%  lkp-wsx01/will-it-scale/performance-page_fault1
      8073           +11.1%       8968        GEO-MEAN sched_debug.cpu#51.nr_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     81.24 ±  1%     -16.7%      67.64 ±  1%  lkp-wsx01/will-it-scale/performance-page_fault1
     81.24           -16.7%      67.64        GEO-MEAN time.user_time

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
    248649 ±  2%      +6.0%     263514 ±  1%  client7/netperf/performance-900s-200%-TCP_STREAM
     13518 ±  2%     -16.2%      11335 ±  2%  lkp-wsx01/will-it-scale/performance-page_fault1
     57977            -5.7%      54652        GEO-MEAN time.involuntary_context_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
       577 ±  0%      +1.5%        585 ±  0%  client7/netperf/performance-900s-200%-TCP_STREAM
      1155 ±  0%     -11.4%       1024 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
       816            -5.2%        774        GEO-MEAN time.percent_of_cpu_this_job_got

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      5059 ±  0%      +1.5%       5132 ±  0%  client7/netperf/performance-900s-200%-TCP_STREAM
      3521 ±  0%     -11.3%       3123 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
      4220            -5.1%       4004        GEO-MEAN time.system_time

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
      6480 ±  0%      +5.8%       6855 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
      6480            +5.8%       6855        GEO-MEAN vmstat.system.cs

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
   2613356 ±  0%      -1.4%    2576765 ±  0%  client7/netperf/performance-900s-200%-TCP_STREAM
    791288 ±  0%      +8.0%     854734 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
   1438026            +3.2%    1484065        GEO-MEAN time.voluntary_context_switches

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     36.32 ±  0%      -4.4%      34.72 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
     36.32            -4.4%      34.72        GEO-MEAN turbostat.%c0

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
     30544 ±  0%      -4.3%      29236 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
     30544            -4.3%      29236        GEO-MEAN vmstat.system.in

97ee4ba7cbd30f18  3193913ce62c63056bc67a6ae3  
----------------  --------------------------  
   7423764 ±  0%      +1.9%    7566579 ±  0%  lkp-wsx01/will-it-scale/performance-page_fault1
   7423764            +1.9%    7566579        GEO-MEAN time.minor_page_faults

lkp-wsx01: Westmere-EX
Memory: 128G

client7: Nehalem EP
Memory: 48G




                                 time.system_time

  3550 ++------*---------*--------------------------------*-------*---------*
  3500 ++.*.*.   *.. .*.  +  .*..*.  .*.  .*.*..    .*.. :   *. ..  *..*. ..|
       *.           *      *.      *.   *.      *.*.     :     *         *  |
  3450 ++                                               *                   |
  3400 ++                                                                   |
       |                                                                    |
  3350 ++                                                                   |
  3300 ++                                                                   |
  3250 ++                                                                   |
       |                                                                    |
  3200 ++ O                                                                 |
  3150 ++      O O                    O                      O              |
       O    O       O O  O O  O  O O    O  O O  O O       O    O  O         |
  3100 ++                                            O  O                   |
  3050 ++-------------------------------------------------------------------+


                         time.percent_of_cpu_this_job_got

  1180 ++-------------------------------------------------------------------+
       |      .*.                                         *..               *
  1160 ++.*.*.   *.. .*..*.  .*..*.  .*.  .*.*..    .*.. :   *.  .*.*..*. ..|
  1140 *+           *      *.      *.   *.      *.*.     :     *.        *  |
       |                                                *                   |
  1120 ++                                                                   |
  1100 ++                                                                   |
       |                                                                    |
  1080 ++                                                                   |
  1060 ++                                                                   |
       |  O                                                                 |
  1040 ++      O O                    O                                     |
  1020 O+   O       O O  O O     O O    O  O O  O         O  O O  O         |
       |                      O                   O  O  O                   |
  1000 ++-------------------------------------------------------------------+


                            time.maximum_resident_set_size

  1.02e+07 ++---------------------------------------------------------------+
           |   .*.                .*.         .*..   .*..*.*..*   *..*.*..*.|
     1e+07 *+*.   *..*.*.*..*.*..*   *..*.*..*    *.*          + +          *
           |                                                    *           |
   9.8e+06 ++                                                               |
           |                                                                |
   9.6e+06 ++                                                               |
           |                                                                |
   9.4e+06 ++                                                               |
           |                                                                |
   9.2e+06 ++     O                     O O    O         O O                |
           | O       O O    O O  O O O       O    O O O         O O         |
     9e+06 O+   O        O                                    O             |
           |                                                                |
   8.8e+06 ++---------------------------------------------------------------+


                           time.voluntary_context_switches

  880000 ++-----------------------------------------------------------------+
         |                                         O                        |
  860000 ++             O           O       O    O    O    O                |
         O      O  O O    O  O O       O O    O         O    O  O           |
         | O  O                   O                               O         |
  840000 ++                                                                 |
         |                                                                  |
  820000 ++                                                                 |
         |                                                                  |
  800000 ++  .*    *.     *..*                        *.              .*..  |
         *.*.  :  :  *.. +    +  .*.    .*..*.*..*. ..  *.. .*..*.*..*      |
         |     :  :     *      *.   *..*           *       *              *.|
  780000 ++     ::                                                          *
         |      *                                                           |
  760000 ++-----------------------------------------------------------------+


                            will-it-scale.per_process_ops

  255000 ++-----------------------------------------------------------------+
         |                                                                  |
  250000 ++        O O    O            O                     O  O           |
         O              O    O O  O O       O    O O  O O  O      O         |
         | O  O O                        O    O                             |
  245000 ++                                                                 |
         |                                                                  |
  240000 ++                                                                 |
         *.*..*     .*..*.*..*.*..*.*.. .*..  *..*.*..*.*..*.*..*.*..*.*..*.*
  235000 ++    :   *                   *     +                              |
         |     :  +                         *                               |
         |      :+                                                          |
  230000 ++     *                                                           |
         |                                                                  |
  225000 ++-----------------------------------------------------------------+


                                   turbostat.%c0

  36.6 ++-------------------------------------------------------------------+
  36.4 ++     .*.                                                           *
       |   .*.   *.. .*..*.  .*..*.  .*.    .*..    .*..  *..*.  .*.*..*. ..|
  36.2 *+.*         *      *.      *.   *..*    *.*.     +     *.        *  |
    36 ++                                               *                   |
       |                                                                    |
  35.8 ++                                                                   |
  35.6 ++                                                                   |
  35.4 ++                                                                   |
       |                                                                    |
  35.2 ++                                                                   |
    35 ++ O                                                                 |
       |    O  O O                    O                                     |
  34.8 O+           O O    O     O O    O  O O  O         O  O O  O         |
  34.6 ++----------------O----O-------------------O--O--O-------------------+


                             numa-numastat.node0.numa_hit

  9.2e+06 ++----------------------------------------------------------------+
    9e+06 O+   O    O    O O         O O  O O  O O         O O  O           |
          | O    O    O       O O O                 O O O         O         |
  8.8e+06 ++                                                                |
  8.6e+06 ++                                                                |
          |                                                                 |
  8.4e+06 ++                                                                |
  8.2e+06 ++                                                                |
    8e+06 ++                                                                |
          |                                                                 |
  7.8e+06 ++                                                                |
  7.6e+06 *+*..*          .*..        .*..*.*..*.*.. .*.*.. .*.. .*..    .*.|
          |     :   *.*..*    *.*.*..*              *      *    *    *.*.   *
  7.4e+06 ++    : ..                                                        |
  7.2e+06 ++-----*----------------------------------------------------------+


                            numa-numastat.node0.local_node

  9.2e+06 ++----------------------------------------------------------------+
    9e+06 O+   O    O      O         O    O O  O O         O O  O           |
          | O    O    O  O    O O O    O            O O O         O         |
  8.8e+06 ++                                                                |
  8.6e+06 ++                                                                |
          |                                                                 |
  8.4e+06 ++                                                                |
  8.2e+06 ++                                                                |
    8e+06 ++                                                                |
          |                                                                 |
  7.8e+06 ++                                                                |
  7.6e+06 *+  .*          .*..           .*.*..*.*.. .*.*.. .*.. .*..    .*.|
          | *.  :   *.*..*    *.*.*..*.*.           *      *    *    *.*.   *
  7.4e+06 ++    : ..                                                        |
  7.2e+06 ++-----*----------------------------------------------------------+


                                  vmstat.system.in

  30800 ++------------------------------------------------------------------+
        |      .*.              .*..                 *                      |
  30600 ++  .*.   *.. .*..*.*..*     .*.. .*..*.    + +   *..*.  .*.*..*.*..*
  30400 *+.*         *              *    *      *..*   + +     *.           |
        |                                               *                   |
  30200 ++                                                                  |
  30000 ++                                                                  |
        |                                                                   |
  29800 ++                                                                  |
  29600 ++                                                                  |
        |  O                                                                |
  29400 ++   O  O O                   O                                     |
  29200 O+           O O    O       O    O O  O O    O    O  O O  O         |
        |                 O    O O                 O    O                   |
  29000 ++------------------------------------------------------------------+


                                 vmstat.system.cs

  7100 ++-------------------------------------------------------------------+
       |                                                                    |
  7000 ++                                         O                         |
  6900 O+      O O    O            O    O    O       O                      |
       |  O O       O    O O  O       O    O    O       O O    O            |
  6800 ++                        O                           O    O         |
       |                                                                    |
  6700 ++                                                                   |
       |                                                                    |
  6600 ++  .*    *..                                 *..               *    |
  6500 ++.*  :   :  *     .*..         .*..*.*..   ..            .*. .. :   |
       *.    :  :    +  .*      .*.*..*         *.*     *.*..*.*.   *   :   |
  6400 ++     : :     *.      *.                                         *..*
       |      ::                                                            |
  6300 ++------*------------------------------------------------------------+


                              proc-vmstat.pgalloc_dma32

  1e+08 ++------------------------------------------------------------------+
  9e+07 O+ O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O O  O         |
        |                                                                   |
  8e+07 ++                                                                  |
  7e+07 ++                                                                  |
        |                                                                   |
  6e+07 ++                                                                  |
  5e+07 ++                                                                  |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                                  |
  2e+07 ++                                                                  |
        |                                                                   |
  1e+07 ++                                                                  |
      0 *+-*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*


                              numa-vmstat.node0.numa_hit

  4.6e+06 ++----------------------------------------------------------------+
          O                O         O O  O O  O O         O O              |
  4.5e+06 ++O  O O  O O  O    O O O                 O O O       O O         |
  4.4e+06 ++                                                                |
          |                                                                 |
  4.3e+06 ++                                                                |
  4.2e+06 ++                                                                |
          |                                                                 |
  4.1e+06 ++                                                                |
    4e+06 ++                                                                |
          |                                                                 |
  3.9e+06 ++              .*..                                              |
  3.8e+06 *+*..*    *.  .*    *.*.*..*.*..*.*..*.*..*.*.*..*.*..*.*..*.*..*.*
          |     + ..  *.                                                    |
  3.7e+06 ++-----*----------------------------------------------------------+


                             numa-vmstat.node0.numa_local

  4.6e+06 ++----------------------------------------------------------------+
          |                O           O  O O  O O         O O              |
  4.5e+06 O+O  O O  O O  O    O O O  O              O O O       O O         |
  4.4e+06 ++                                                                |
          |                                                                 |
  4.3e+06 ++                                                                |
  4.2e+06 ++                                                                |
          |                                                                 |
  4.1e+06 ++                                                                |
    4e+06 ++                                                                |
          |                                                                 |
  3.9e+06 ++              .*..                                              |
  3.8e+06 *+*..*    *.  .*    *.*.*.. .*..*.*..*.*..*.*.*..*.*..*.*..*.*..*.|
          |     + ..  *.             *                                      *
  3.7e+06 ++-----*----------------------------------------------------------+

	[*] bisect-good sample
	[O] bisect-bad  sample

To reproduce:

	apt-get install ruby ruby-oj
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
	cd lkp-tests
	bin/setup-local job.yaml # the job file attached in this email
	bin/run-local   job.yaml


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Fengguang

--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: will-it-scale
default_monitors:
  wait: pre-test
  uptime: 
  iostat: 
  vmstat: 
  numa-numastat: 
  numa-vmstat: 
  numa-meminfo: 
  proc-vmstat: 
  proc-stat: 
  meminfo: 
  slabinfo: 
  interrupts: 
  lock_stat: 
  latency_stats: 
  softirqs: 
  bdi_dev_mapping: 
  diskstats: 
  energy: 
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
  pmeter: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: f114040e3ea6e07372334ade75d1ee0775c355e1
model: Westmere-EX
memory: 128G
nr_cpu: 80
nr_hdd_partitions: 0
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
rootfs: clearlinux-x86_64.cgz
perf-profile:
  freq: 800
will-it-scale:
  test:
  - page_fault1
enqueue_time: 2014-10-20 11:14:36.566460713 +08:00
testbox: lkp-wsx01
tbox_group: lkp-wsx01
kconfig: x86_64-rhel
head_commit: 1a7ad083caf4a29b00d7eaabfd81f63d6fecde5a
base_commit: f114040e3ea6e07372334ade75d1ee0775c355e1
branch: linux-devel/devel-hourly-2014102013
kernel: "/kernel/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/vmlinuz-3.18.0-rc1-gf114040"
user: lkp
queue: cyclic
result_root: "/result/lkp-wsx01/will-it-scale/performance-page_fault1/clearlinux-x86_64.cgz/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/0"
job_file: "/lkp/scheduled/lkp-wsx01/cyclic_will-it-scale-performance-page_fault1-clearlinux-x86_64.cgz-x86_64-rhel-BASE-f114040e3ea6e07372334ade75d1ee0775c355e1-0.yaml"
dequeue_time: 2014-10-20 13:41:08.597013596 +08:00
job_state: finished
loadavg: 53.96 26.56 10.62 1/637 12621
start_time: '1413783739'
end_time: '1413784050'
version: "/lkp/lkp/.src-20141020-092052"

--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu64/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu65/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu66/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu67/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu68/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu69/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu70/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu71/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu72/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu73/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu74/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu75/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu76/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu77/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu78/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu79/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
./runtest.py page_fault1 16 1 10 20 30 40 60 80

--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--rQ2U398070+RC21q--
