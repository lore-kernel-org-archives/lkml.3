Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaCVL7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:59:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:1823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaCVL7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,709,1389772800"; 
   d="scan'208";a="497389720"
Date: Sat, 22 Mar 2014 19:59:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched] 373e9ec30ad: -9.8% qperf.tcp_bw.bw.MB_sec
Message-ID: <20140322115947.GA14767@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Alex,

FYI, we noticed the below changes on

https://github.com/alexshi/power-scheduling.git single-balance
commit 373e9ec30ad1efee2c4ba6b58fc317626e6482d0 ("sched: only do load balance on tick_do_timer_cpu")

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      0.10 ~ 3%   +2134.7%       2.32 ~ 3%  lkp-st02/micro/ebizzy/200%-100-10
      0.10 ~ 3%   +2134.7%       2.32 ~ 3%  TOTAL ebizzy.throughput.per_thread.stddev_percent

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2432 ~50%     -56.3%       1064 ~ 0%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
      2432 ~50%     -56.3%       1064 ~ 0%  TOTAL fileio.request_latency_max_ms

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1541 ~ 0%     +90.4%       2936 ~ 0%  lkp-st02/micro/ebizzy/200%-100-10
      1541 ~ 0%     +90.4%       2936 ~ 0%  TOTAL ebizzy.throughput.per_thread.max

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       135 ~ 4%     +76.4%        238 ~33%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
       135 ~ 4%     +76.4%        238 ~33%  TOTAL fileio.requests_per_sec

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1443 ~ 0%     -31.2%        993 ~ 1%  lkp-st02/micro/ebizzy/200%-100-10
      1443 ~ 0%     -31.2%        993 ~ 1%  TOTAL ebizzy.throughput.per_thread.min

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       273 ~ 0%     -11.2%        242 ~ 1%  lkp-a06/micro/qperf/600s
       273 ~ 0%     -11.2%        242 ~ 1%  TOTAL qperf.udp_bw.send_bw.MB_sec

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       268 ~ 0%      -9.8%        242 ~ 0%  lkp-a06/micro/qperf/600s
       268 ~ 0%      -9.8%        242 ~ 0%  TOTAL qperf.tcp_bw.bw.MB_sec

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       266 ~ 0%      -9.8%        240 ~ 1%  lkp-a06/micro/qperf/600s
       266 ~ 0%      -9.8%        240 ~ 1%  TOTAL qperf.udp_bw.recv_bw.MB_sec

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     18752 ~ 4%     -19.1%      15167 ~11%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     48281 ~ 2%     -81.3%       9035 ~ 1%  lkp-a06/micro/qperf/600s
    139171 ~ 8%     -96.6%       4794 ~ 8%  lkp-nex05/micro/will-it-scale/sched_yield
     35512 ~ 1%     -82.0%       6404 ~ 2%  lkp-st02/micro/ebizzy/200%-100-10
    241717 ~ 5%     -85.4%      35402 ~ 6%  TOTAL softirqs.SCHED

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   1359067 ~ 4%     -30.7%     942510 ~ 2%  lkp-a06/micro/qperf/600s
     63196 ~ 0%     -84.2%       9974 ~ 1%  lkp-nex05/micro/will-it-scale/sched_yield
   1422264 ~ 3%     -33.0%     952484 ~ 2%  TOTAL interrupts.RES

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   1013906 ~ 4%     +76.3%    1787578 ~33%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
   1013906 ~ 4%     +76.3%    1787578 ~33%  TOTAL proc-vmstat.pgpgin

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     71377 ~ 3%     +74.3%     124397 ~32%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     71377 ~ 3%     +74.3%     124397 ~32%  TOTAL proc-vmstat.pgactivate

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
 2.076e+08 ~ 2%     -33.4%  1.383e+08 ~ 9%  lkp-a06/micro/qperf/600s
 2.076e+08 ~ 2%     -33.4%  1.383e+08 ~ 9%  TOTAL cpuidle.C1.time

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     69494 ~ 3%     +69.9%     118079 ~31%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     69494 ~ 3%     +69.9%     118079 ~31%  TOTAL interrupts.43:PCI-MSI-edge.virtio1-requests

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
  10201776 ~14%     -30.1%    7133067 ~10%  lkp-a06/micro/qperf/600s
  10201776 ~14%     -30.1%    7133067 ~10%  TOTAL cpuidle.C3.time

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
    128295 ~ 0%     -27.7%      92701 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
    128295 ~ 0%     -27.7%      92701 ~ 0%  TOTAL cpuidle.C3-NHM.usage

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
  52277488 ~ 4%     -26.6%   38366608 ~ 6%  lkp-a06/micro/qperf/600s
  52277488 ~ 4%     -26.6%   38366608 ~ 6%  TOTAL cpuidle.C2.time

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     49609 ~ 2%     +38.8%      68871 ~19%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     49609 ~ 2%     +38.8%      68871 ~19%  TOTAL proc-vmstat.nr_active_file

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
    198429 ~ 2%     +38.8%     275466 ~19%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
    198429 ~ 2%     +38.8%     275466 ~19%  TOTAL meminfo.Active(file)

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      3955 ~ 7%     -24.8%       2972 ~14%  lkp-a06/micro/qperf/600s
      3955 ~ 7%     -24.8%       2972 ~14%  TOTAL cpuidle.C3.usage

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1.55 ~ 1%     +27.6%       1.98 ~ 2%  lkp-nex05/micro/will-it-scale/sched_yield
      1.55 ~ 1%     +27.6%       1.98 ~ 2%  TOTAL perf-profile.cpu-cycles.trace_hardirqs_off_thunk.__sched_yield

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
    220670 ~ 2%     +34.9%     297725 ~17%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
    220670 ~ 2%     +34.9%     297725 ~17%  TOTAL meminfo.Active

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     20.03 ~ 0%     +25.8%      25.20 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
     20.03 ~ 0%     +25.8%      25.20 ~ 0%  TOTAL turbostat.%c1

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2.16 ~ 1%     +19.9%       2.58 ~ 2%  lkp-nex05/micro/will-it-scale/sched_yield
      2.16 ~ 1%     +19.9%       2.58 ~ 2%  TOTAL perf-profile.cpu-cycles.native_read_tsc.native_sched_clock.sched_clock.sched_clock_cpu.update_rq_clock

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     23914 ~ 4%     -14.9%      20344 ~ 4%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     26884 ~ 4%     -13.4%      23292 ~ 4%  lkp-st02/micro/ebizzy/200%-100-10
     50798 ~ 4%     -14.1%      43636 ~ 4%  TOTAL interrupts.IWI

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      7955 ~ 6%     -14.7%       6789 ~ 3%  lkp-st02/micro/ebizzy/200%-100-10
      7955 ~ 6%     -14.7%       6789 ~ 3%  TOTAL slabinfo.kmalloc-64.active_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      3409 ~ 6%     -14.0%       2932 ~ 3%  lkp-st02/micro/ebizzy/200%-100-10
      3409 ~ 6%     -14.0%       2932 ~ 3%  TOTAL slabinfo.kmalloc-192.active_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1.18 ~ 1%     +15.5%       1.36 ~ 1%  lkp-nex05/micro/will-it-scale/sched_yield
      1.18 ~ 1%     +15.5%       1.36 ~ 1%  TOTAL perf-profile.cpu-cycles.rb_erase.__dequeue_entity.pick_next_task_fair.__schedule.schedule

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1.18 ~ 2%     +16.6%       1.37 ~ 1%  lkp-nex05/micro/will-it-scale/sched_yield
      1.18 ~ 2%     +16.6%       1.37 ~ 1%  TOTAL perf-profile.cpu-cycles.rb_erase.pick_next_task_fair.__schedule.schedule.sys_sched_yield

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2743 ~ 4%     -13.4%       2375 ~ 2%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
      2743 ~ 4%     -13.4%       2375 ~ 2%  TOTAL uptime.idle

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       954 ~ 1%     -15.0%        811 ~ 1%  lkp-nex05/micro/will-it-scale/sched_yield
       954 ~ 1%     -15.0%        811 ~ 1%  TOTAL slabinfo.taskstats.num_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       954 ~ 1%     -15.0%        811 ~ 1%  lkp-nex05/micro/will-it-scale/sched_yield
       954 ~ 1%     -15.0%        811 ~ 1%  TOTAL slabinfo.taskstats.active_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1.81 ~ 2%     -11.7%       1.60 ~ 1%  lkp-nex05/micro/will-it-scale/sched_yield
      1.81 ~ 2%     -11.7%       1.60 ~ 1%  TOTAL perf-profile.cpu-cycles.__dequeue_entity.pick_next_task_fair.__schedule.schedule.sys_sched_yield

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     25646 ~ 1%     +13.7%      29148 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
     25646 ~ 1%     +13.7%      29148 ~ 0%  TOTAL interrupts.0:IO-APIC-edge.timer

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   2294497 ~ 0%     -11.1%    2040824 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
   2294497 ~ 0%     -11.1%    2040824 ~ 0%  TOTAL interrupts.LOC

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2972 ~ 0%     +15.2%       3423 ~ 8%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
      2972 ~ 0%     +15.2%       3423 ~ 8%  TOTAL slabinfo.radix_tree_node.num_slabs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2972 ~ 0%     +15.2%       3423 ~ 8%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
      2972 ~ 0%     +15.2%       3423 ~ 8%  TOTAL slabinfo.radix_tree_node.active_slabs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     83186 ~ 0%     +15.2%      95811 ~ 8%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     83186 ~ 0%     +15.2%      95811 ~ 8%  TOTAL slabinfo.radix_tree_node.active_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     83245 ~ 0%     +15.2%      95861 ~ 8%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     83245 ~ 0%     +15.2%      95861 ~ 8%  TOTAL slabinfo.radix_tree_node.num_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   1245903 ~ 0%     -10.2%    1118862 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
   1245903 ~ 0%     -10.2%    1118862 ~ 0%  TOTAL softirqs.TIMER

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      6.34 ~ 1%     -10.5%       5.67 ~ 2%  lkp-nex05/micro/will-it-scale/sched_yield
      6.34 ~ 1%     -10.5%       5.67 ~ 2%  TOTAL perf-profile.cpu-cycles.put_prev_task_fair.__schedule.schedule.sys_sched_yield.system_call_fastpath

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      3621 ~ 3%      -9.6%       3275 ~ 2%  lkp-st02/micro/ebizzy/200%-100-10
      3621 ~ 3%      -9.6%       3275 ~ 2%  TOTAL slabinfo.kmalloc-192.num_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   9066611 ~ 0%      -8.3%    8313872 ~ 1%  lkp-a06/micro/qperf/600s
   9066611 ~ 0%      -8.3%    8313872 ~ 1%  TOTAL proc-vmstat.pgalloc_dma32

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      8137 ~ 4%      -7.9%       7495 ~ 2%  lkp-st02/micro/ebizzy/200%-100-10
      8137 ~ 4%      -7.9%       7495 ~ 2%  TOTAL slabinfo.kmalloc-64.num_objs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
  24350865 ~ 0%      -8.3%   22328921 ~ 1%  lkp-a06/micro/qperf/600s
  24350865 ~ 0%      -8.3%   22328921 ~ 1%  TOTAL proc-vmstat.pgfree

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
  15285179 ~ 0%      -8.3%   14016032 ~ 1%  lkp-a06/micro/qperf/600s
  15285179 ~ 0%      -8.3%   14016032 ~ 1%  TOTAL proc-vmstat.pgalloc_normal

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     91110 ~23%  +8.6e+05%  7.845e+08 ~ 2%  lkp-nex05/micro/will-it-scale/sched_yield
     91110 ~23%  +8.6e+05%  7.845e+08 ~ 2%  TOTAL time.involuntary_context_switches

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     14152 ~ 1%      +2.2%      14464 ~ 0%  lkp-a06/micro/qperf/600s
     14152 ~ 1%      +2.2%      14464 ~ 0%  TOTAL vmstat.system.cs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       968 ~ 4%     +91.9%       1858 ~34%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
       968 ~ 4%     +91.9%       1858 ~34%  TOTAL vmstat.io.bi

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   2027778 ~ 4%     +76.3%    3575122 ~33%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
   2027778 ~ 4%     +76.3%    3575122 ~33%  TOTAL time.file_system_inputs

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2961 ~ 3%     -19.7%       2378 ~ 3%  lkp-a06/micro/qperf/600s
      8365 ~ 0%     -11.3%       7416 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
     11326 ~ 1%     -13.5%       9795 ~ 1%  TOTAL vmstat.system.in

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       589 ~ 0%     -15.6%        497 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
       589 ~ 0%     -15.6%        497 ~ 0%  TOTAL time.user_time

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       904 ~ 0%     -13.6%        781 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
       904 ~ 0%     -13.6%        781 ~ 0%  TOTAL time.percent_of_cpu_this_job_got

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      2244 ~ 0%     -13.0%       1951 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
      2244 ~ 0%     -13.0%       1951 ~ 0%  TOTAL time.system_time

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     44.92 ~ 0%     -11.5%      39.74 ~ 0%  lkp-nex05/micro/will-it-scale/sched_yield
     44.92 ~ 0%     -11.5%      39.74 ~ 0%  TOTAL turbostat.%c0

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
     63860 ~ 2%      +8.7%      69402 ~ 1%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     63860 ~ 2%      +8.7%      69402 ~ 1%  TOTAL vmstat.io.bo

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
      1047 ~ 2%      -8.0%        963 ~ 1%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
      1047 ~ 2%      -8.0%        963 ~ 1%  TOTAL time.elapsed_time

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
   3887389 ~20%      +9.7%    4262549 ~ 0%  lkp-a06/micro/qperf/600s
   3887389 ~20%      +9.7%    4262549 ~ 0%  TOTAL time.voluntary_context_switches


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                            qperf.udp_bw.send_bw.MB_sec

   280 ++-------------------------------------------------------------------+
       |                                        .*.....                     |
   275 *+...*.....*....        ...*....*....  ..       *                    |
   270 ++              *....*..             *.                              |
       |                                                                    |
   265 ++                                                                   |
   260 ++                                                                   |
       |                                                                    |
   255 ++                                                                   |
   250 ++                                              O                    |
       |                                                                    |
   245 ++                              O                                    |
   240 O+   O     O               O         O                    O     O    O
       |               O    O                               O               |
   235 ++----------------------------------------O--------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

./qperf
./qperf 127.0.0.1 --time 100 tcp_bw tcp_lat udp_bw udp_lat sctp_bw sctp_lat quit

--X1bOJ3K7DJ5YkBrT--
