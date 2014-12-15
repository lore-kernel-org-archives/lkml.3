Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaLOHHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:07:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:55290 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaLOHHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:07:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="428980799"
Message-ID: <1418627248.5745.186.camel@intel.com>
Subject: [LKP] [genirq] c291ee62216:
From: Huang Ying <ying.huang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Mon, 15 Dec 2014 15:07:28 +0800
Content-Type: multipart/mixed; boundary="=-nhpr9QTL4GjmFrW4wTZJ"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nhpr9QTL4GjmFrW4wTZJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/urgent
commit c291ee622165cb2c8d4e7af63fffd499354a23be ("genirq: Prevent proc race against freeing of irq descriptors")

testbox/testcase/testparams: lkp-nex04/netperf/performance-300s-200%-SCTP_STREAM

3a5dc1fafb016560  c291ee622165cb2c8d4e7af63f  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
        16 ± 44%     -73.1%          4 ± 36%  sched_debug.cfs_rq[32]:/.tg_runnable_contrib
         1 ±  0%    +175.0%          2 ± 15%  sched_debug.cfs_rq[53]:/.nr_spread_over
       814 ± 41%     -70.5%        240 ± 37%  sched_debug.cfs_rq[32]:/.avg->runnable_avg_sum
       136 ± 35%    +104.6%        278 ± 26%  sched_debug.cpu#5.curr->pid
      4149 ±  8%    +140.6%       9981 ± 22%  sched_debug.cfs_rq[35]:/.min_vruntime
      5151 ± 28%     +97.3%      10166 ± 19%  sched_debug.cfs_rq[58]:/.min_vruntime
      4897 ± 15%     +86.8%       9149 ± 23%  sched_debug.cfs_rq[41]:/.min_vruntime
      5001 ±  8%    +100.2%      10011 ±  6%  sched_debug.cfs_rq[62]:/.min_vruntime
       990 ± 25%    +103.7%       2017 ± 49%  sched_debug.cfs_rq[16]:/.exec_clock
       106 ± 40%     +65.1%        175 ± 26%  sched_debug.cfs_rq[37]:/.tg_load_contrib
      4649 ± 14%    +122.4%      10338 ± 24%  sched_debug.cfs_rq[43]:/.min_vruntime
      4432 ±  9%     +97.2%       8742 ± 15%  sched_debug.cfs_rq[54]:/.min_vruntime
      1011 ± 16%     +80.0%       1820 ± 36%  sched_debug.cfs_rq[23]:/.exec_clock
        10 ± 22%     -41.9%          6 ± 17%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
         2 ± 19%     +77.8%          4 ± 30%  sched_debug.cfs_rq[0]:/.nr_spread_over
      5093 ±  4%     +81.3%       9232 ± 18%  sched_debug.cfs_rq[56]:/.min_vruntime
       193 ± 26%     -39.5%        117 ± 45%  sched_debug.cfs_rq[38]:/.tg_load_contrib
      5340 ±  7%     +89.5%      10118 ± 13%  sched_debug.cfs_rq[48]:/.min_vruntime
      6055 ± 35%     +48.9%       9017 ± 13%  sched_debug.cfs_rq[40]:/.min_vruntime
      4871 ± 13%     +78.7%       8702 ± 24%  sched_debug.cfs_rq[57]:/.min_vruntime
      4374 ± 13%     +76.7%       7729 ± 19%  sched_debug.cfs_rq[45]:/.min_vruntime
      5321 ± 13%     +74.7%       9297 ± 22%  sched_debug.cfs_rq[59]:/.min_vruntime
      4738 ± 12%    +104.0%       9668 ±  6%  sched_debug.cfs_rq[37]:/.min_vruntime
      5426 ±  7%     +80.9%       9817 ±  2%  sched_debug.cfs_rq[51]:/.min_vruntime
      5067 ± 18%     +96.8%       9974 ± 22%  sched_debug.cfs_rq[55]:/.min_vruntime
      5318 ±  6%     +64.7%       8757 ± 26%  sched_debug.cfs_rq[42]:/.min_vruntime
      5160 ± 11%     +87.9%       9696 ±  5%  sched_debug.cfs_rq[53]:/.min_vruntime
      5208 ±  8%     +81.0%       9429 ± 13%  sched_debug.cfs_rq[50]:/.min_vruntime
      4395 ± 26%     +78.9%       7865 ±  8%  sched_debug.cfs_rq[32]:/.min_vruntime
      5596 ± 41%     +65.5%       9264 ± 19%  sched_debug.cfs_rq[49]:/.min_vruntime
       540 ± 21%     -37.9%        336 ± 11%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
       102 ± 39%     +61.9%        165 ± 24%  sched_debug.cfs_rq[37]:/.blocked_load_avg
      4916 ±  7%     +77.5%       8726 ± 11%  sched_debug.cfs_rq[38]:/.min_vruntime
       307 ±  6%     +84.3%        567 ± 31%  sched_debug.cfs_rq[54]:/.exec_clock
      5541 ± 11%     +75.9%       9746 ±  4%  sched_debug.cfs_rq[60]:/.min_vruntime
      5250 ± 22%     +72.3%       9049 ± 13%  sched_debug.cfs_rq[36]:/.min_vruntime
       285 ±  2%     +64.6%        470 ± 17%  sched_debug.cfs_rq[37]:/.exec_clock
        27 ± 42%    +102.7%         55 ± 36%  sched_debug.cfs_rq[6]:/.blocked_load_avg
        28 ± 40%     +98.3%         57 ± 35%  sched_debug.cfs_rq[6]:/.tg_load_contrib
      5523 ± 14%     +65.3%       9129 ±  9%  sched_debug.cfs_rq[52]:/.min_vruntime
      1424 ± 13%     +81.7%       2588 ± 41%  sched_debug.cpu#50.sched_count
       282 ±  6%     +59.0%        448 ± 10%  sched_debug.cfs_rq[43]:/.exec_clock
       114 ± 18%     +80.1%        206 ± 16%  sched_debug.cfs_rq[48]:/.blocked_load_avg
       285 ±  6%     +48.3%        424 ±  9%  sched_debug.cfs_rq[35]:/.exec_clock
       865 ± 13%     -34.0%        571 ± 21%  sched_debug.cpu#55.sched_goidle
       162 ± 18%     -35.1%        105 ± 13%  sched_debug.cfs_rq[54]:/.blocked_load_avg
      2017 ± 11%     -29.1%       1431 ± 16%  sched_debug.cpu#55.nr_switches
      2047 ± 11%     -28.5%       1464 ± 16%  sched_debug.cpu#55.sched_count
       302 ± 14%     -20.0%        242 ± 14%  sched_debug.cpu#53.ttwu_local
       303 ± 10%     +73.7%        527 ± 38%  sched_debug.cfs_rq[60]:/.exec_clock
       286 ± 15%     +32.1%        378 ± 13%  sched_debug.cfs_rq[45]:/.exec_clock
       127 ± 22%     +64.6%        210 ± 17%  sched_debug.cfs_rq[48]:/.tg_load_contrib
       171 ± 14%     -29.3%        121 ± 10%  sched_debug.cfs_rq[54]:/.tg_load_contrib
        92 ± 42%     +72.4%        159 ± 19%  sched_debug.cfs_rq[58]:/.blocked_load_avg
  16297106 ±  4%     +27.5%   20771822 ±  5%  cpuidle.C1-NHM.time
       453 ± 37%     +47.9%        670 ±  8%  sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum
         8 ± 43%     +54.3%         13 ±  8%  sched_debug.cfs_rq[31]:/.tg_runnable_contrib
       318 ± 10%     +67.0%        531 ± 42%  sched_debug.cfs_rq[55]:/.exec_clock
      1496 ± 14%     +37.8%       2061 ± 13%  sched_debug.cpu#37.sched_count
      1466 ± 15%     +37.8%       2019 ± 13%  sched_debug.cpu#37.nr_switches
       977 ± 14%     +73.2%       1692 ± 49%  sched_debug.cfs_rq[28]:/.exec_clock
       830 ±  6%     +22.0%       1013 ±  9%  sched_debug.cpu#45.ttwu_count
       613 ± 17%     +42.8%        876 ± 16%  sched_debug.cpu#37.sched_goidle
      8839 ±  7%     -11.4%       7828 ± 10%  sched_debug.cpu#3.ttwu_count
    116654 ±  6%     -12.7%     101799 ±  5%  meminfo.DirectMap4k
      1041 ±  6%     +34.3%       1399 ± 27%  sched_debug.cfs_rq[29]:/.exec_clock
      6.66 ± 20%    +175.2%      18.32 ±  2%  time.system_time
     16.79 ±  7%     -48.0%       8.73 ±  1%  time.user_time
         7 ±  0%     +17.9%          8 ±  5%  time.percent_of_cpu_this_job_got
     98436 ±  0%      +1.6%     100045 ±  0%  time.voluntary_context_switches

lkp-nex04: Nehalem-EX
Memory: 256G


                           time.voluntary_context_switches

  100500 ++-----------------------------------------------------------------+
         O       O                    O          O                          |
         |  O                            O          O                       |
  100000 ++           O  O  O O     O          O                            |
         |    O                  O          O          O                    |
         |          O                                                       |
   99500 ++                                                                 |
         |                                                                  |
   99000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   98500 ++        .*.*..                          .*.. .*..    .*..*..     |
         *..*.*..*.      *..*.*..*..*.*..*..*..*.*.    *    *..*       *.*..*
         |                                                                  |
   98000 ++-----------------------------------------------------------------+


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


--=-nhpr9QTL4GjmFrW4wTZJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: netperf
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
commit: 057b16997d77a23a4dd2b8e8a9bd56656afac86d
model: Nehalem-EX
memory: 256G
nr_ssd_partitions: 6
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSD*part1"
swap_partitions: "/dev/disk/by-id/ata-WDC_WD10EARS-00Y5B1_WD-WCAV5F059074-part2"
runtime: 300s
nr_threads:
- 200%
perf-profile:
  freq: 800
netperf:
  test:
  - SCTP_STREAM
testbox: lkp-nex04
tbox_group: lkp-nex04
kconfig: x86_64-rhel
enqueue_time: 2014-12-14 00:52:11.886525322 +08:00
head_commit: 057b16997d77a23a4dd2b8e8a9bd56656afac86d
base_commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
branch: linux-devel/devel-hourly-2014121400
kernel: "/kernel/x86_64-rhel/057b16997d77a23a4dd2b8e8a9bd56656afac86d/vmlinuz-3.18.0-g057b169"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-nex04/netperf/performance-300s-200%-SCTP_STREAM/debian-x86_64.cgz/x86_64-rhel/057b16997d77a23a4dd2b8e8a9bd56656afac86d/0"
job_file: "/lkp/scheduled/lkp-nex04/cyclic_netperf-performance-300s-200%-SCTP_STREAM-x86_64-rhel-HEAD-057b16997d77a23a4dd2b8e8a9bd56656afac86d-0.yaml"
dequeue_time: 2014-12-14 08:50:11.387688351 +08:00
job_state: finished
loadavg: 0.16 0.22 0.14 2/526 13068
start_time: '1418518283'
end_time: '1418518586'
version: "/lkp/lkp/.src-20141214-052354"

--=-nhpr9QTL4GjmFrW4wTZJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

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
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
netserver
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300
netperf -t SCTP_STREAM -c -C -l 300

--=-nhpr9QTL4GjmFrW4wTZJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-nhpr9QTL4GjmFrW4wTZJ--

