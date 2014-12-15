Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaLOGzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:55:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:4024 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaLOGzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:55:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="yaml'?scan'208";a="498758636"
Message-ID: <1418626546.5745.183.camel@linux.intel.com>
Subject: [LKP] [sched] 05bfb65f52c: -5.2% thrulay.throughput
From: Huang Ying <ying.huang@linux.intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Mon, 15 Dec 2014 14:55:46 +0800
Content-Type: multipart/mixed; boundary="=-rA/T2kpl1mnz9Vq2/58p"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rA/T2kpl1mnz9Vq2/58p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 05bfb65f52cbdabe26ebb629959416a6cffb034d ("sched: Remove a wake_affine() condition")


testbox/testcase/testparams: ivb42/thrulay/performance-300s

afdeee0510db918b  05bfb65f52cbdabe26ebb62995  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     37071 ±  1%      -5.2%      35155 ±  1%  thrulay.throughput
         9 ± 39%    +294.4%         35 ± 45%  sched_debug.cpu#41.cpu_load[4]
       127 ± 43%    +199.0%        380 ± 33%  sched_debug.cpu#30.curr->pid
     89726 ± 35%    +249.9%     313930 ± 40%  sched_debug.cpu#12.sched_goidle
    180377 ± 34%    +248.9%     629297 ± 40%  sched_debug.cpu#12.nr_switches
    186401 ± 33%    +239.4%     632605 ± 39%  sched_debug.cpu#12.sched_count
       467 ±  9%     -51.9%        224 ± 46%  sched_debug.cfs_rq[27]:/.tg_load_contrib
        73 ± 13%     -58.6%         30 ± 41%  sched_debug.cpu#2.cpu_load[1]
        97 ± 28%     -59.1%         39 ± 47%  sched_debug.cpu#11.load
        30 ± 45%     +86.1%         56 ± 26%  sched_debug.cpu#9.cpu_load[2]
       122 ± 37%     -50.9%         60 ± 46%  sched_debug.cpu#1.cpu_load[1]
        16 ± 38%    +100.0%         32 ± 31%  sched_debug.cfs_rq[41]:/.tg_runnable_contrib
       782 ± 34%     +93.8%       1517 ± 29%  sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
       445 ± 31%     -43.3%        252 ± 35%  sched_debug.cpu#11.curr->pid
      5983 ± 11%    +106.3%      12342 ± 12%  sched_debug.cfs_rq[12]:/.exec_clock
        53 ± 24%     -38.5%         32 ± 21%  sched_debug.cpu#27.load
      1636 ± 24%     -42.9%        934 ± 22%  sched_debug.cpu#15.curr->pid
       285 ± 48%     -44.8%        157 ± 33%  sched_debug.cpu#26.curr->pid
      8138 ±  9%     +96.5%      15989 ± 11%  sched_debug.cfs_rq[12]:/.min_vruntime
       174 ± 26%     -46.4%         93 ± 25%  sched_debug.cpu#15.load
        55 ± 39%     +49.8%         82 ± 28%  sched_debug.cfs_rq[35]:/.tg_load_contrib
        47 ± 22%     +82.1%         86 ± 28%  sched_debug.cpu#6.cpu_load[2]
        26 ± 22%     -45.3%         14 ± 28%  numa-numastat.node1.other_node
        90 ± 24%     -39.7%         54 ± 19%  sched_debug.cpu#2.cpu_load[3]
        24 ± 37%     +76.5%         43 ±  6%  sched_debug.cpu#32.cpu_load[4]
    107188 ± 22%     +46.3%     156809 ± 18%  sched_debug.cpu#32.sched_count
       409 ± 12%     +54.5%        633 ± 34%  sched_debug.cpu#11.ttwu_local
       131 ± 27%     -43.5%         74 ± 39%  sched_debug.cpu#1.cpu_load[2]
       247 ± 32%     +64.1%        406 ± 29%  sched_debug.cpu#2.curr->pid
        89 ± 29%     -55.3%         39 ± 47%  sched_debug.cfs_rq[11]:/.load
        83 ± 16%     -50.7%         41 ± 26%  sched_debug.cpu#2.cpu_load[2]
    194662 ± 18%     +49.5%     290986 ± 10%  sched_debug.cpu#8.sched_count
        24 ± 22%     +75.5%         43 ± 25%  sched_debug.cpu#31.cpu_load[1]
        28 ± 46%     +57.5%         44 ± 15%  sched_debug.cpu#29.cpu_load[4]
     70637 ± 23%     +34.4%      94908 ± 17%  sched_debug.cpu#27.ttwu_count
        26 ± 40%     +62.5%         42 ± 15%  sched_debug.cpu#32.cpu_load[3]
        65 ± 20%     -30.2%         45 ± 19%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
      3044 ± 20%     -29.7%       2139 ± 19%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
        28 ±  6%     -33.0%         19 ± 16%  sched_debug.cfs_rq[39]:/.tg_runnable_contrib
      1357 ±  6%     -32.5%        915 ± 17%  sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum
       277 ± 14%     -38.6%        170 ± 18%  sched_debug.cfs_rq[40]:/.runnable_load_avg
       279 ± 14%     -39.1%        170 ± 18%  sched_debug.cfs_rq[40]:/.load
    575205 ± 11%     +29.6%     745663 ± 10%  sched_debug.cpu#11.avg_idle
    151626 ± 19%     +17.5%     178195 ± 13%  sched_debug.cpu#3.ttwu_count
    349553 ±  6%     +33.4%     466210 ± 11%  sched_debug.cpu#0.ttwu_count
       133 ±  5%     -29.6%         94 ± 26%  sched_debug.cpu#40.cpu_load[3]
      3767 ± 16%     -28.8%       2680 ± 15%  sched_debug.cpu#40.curr->pid
       279 ± 14%     -25.3%        209 ±  9%  sched_debug.cpu#40.load
        39 ±  8%     -24.7%         29 ±  7%  sched_debug.cfs_rq[15]:/.tg_runnable_contrib
      1855 ±  7%     -24.0%       1410 ±  6%  sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
       309 ±  7%     -32.9%        207 ± 20%  sched_debug.cpu#40.cpu_load[0]
       213 ±  5%     -32.4%        144 ± 22%  sched_debug.cpu#40.cpu_load[2]
    602662 ± 11%     +20.9%     728740 ±  7%  sched_debug.cpu#30.avg_idle
     84865 ± 16%     +26.5%     107350 ±  8%  sched_debug.cpu#26.ttwu_count
       285 ±  6%     -34.0%        188 ± 20%  sched_debug.cpu#40.cpu_load[1]
    178498 ± 12%     +21.2%     216368 ± 12%  sched_debug.cpu#2.ttwu_count
      5368 ±  9%     +14.5%       6147 ±  9%  sched_debug.cfs_rq[28]:/.exec_clock
    229046 ±  6%     -10.9%     204016 ±  7%  sched_debug.cpu#8.ttwu_count
    716125 ±  9%     +22.4%     876793 ±  4%  sched_debug.cpu#14.avg_idle
       921 ±  4%     +15.3%       1062 ±  5%  sched_debug.cpu#25.ttwu_local
    628697 ± 12%     +22.5%     769882 ±  8%  sched_debug.cpu#1.avg_idle
    123795 ±  7%     -13.6%     106992 ±  9%  sched_debug.cpu#32.ttwu_count
     10875 ±  4%     -16.5%       9083 ±  8%  sched_debug.cfs_rq[35]:/.min_vruntime
      5103 ±  9%     -16.2%       4277 ± 10%  sched_debug.cfs_rq[40]:/.min_vruntime
        86 ±  6%     -13.7%         74 ± 11%  sched_debug.cpu#44.ttwu_local
    538474 ± 13%     +27.6%     686910 ±  7%  sched_debug.cpu#15.avg_idle
       223 ±  4%     +16.4%        260 ±  6%  sched_debug.cpu#28.ttwu_local
     33784 ±  5%     -15.1%      28679 ± 11%  cpuidle.C1E-IVT.usage
      2764 ±  6%     -20.6%       2193 ± 20%  sched_debug.cfs_rq[20]:/.min_vruntime
       681 ± 19%     -19.1%        551 ±  6%  cpuidle.POLL.usage
     18925 ±  9%     +15.6%      21877 ±  3%  sched_debug.cfs_rq[0]:/.exec_clock
    559454 ± 13%     +21.3%     678413 ±  6%  sched_debug.cpu#27.avg_idle
     49536 ±  3%     -10.2%      44495 ±  1%  sched_debug.cpu#15.nr_load_updates
     17570 ±  6%     -17.5%      14492 ± 10%  sched_debug.cfs_rq[11]:/.min_vruntime
     57206 ±  1%      -7.6%      52840 ±  2%  sched_debug.cpu#7.nr_load_updates
     51547 ±  1%      -8.0%      47418 ±  3%  sched_debug.cpu#26.nr_load_updates
     43519 ±  1%      -9.2%      39535 ±  1%  sched_debug.cpu#43.nr_load_updates
     50591 ±  1%      -8.6%      46252 ±  2%  sched_debug.cpu#35.nr_load_updates
     45642 ±  1%     -10.1%      41051 ±  2%  sched_debug.cpu#23.nr_load_updates
     46023 ±  2%      -9.0%      41872 ±  1%  sched_debug.cpu#19.nr_load_updates
      3.42 ±  1%      +9.8%       3.75 ±  2%  turbostat.RAM_W
     58859 ±  3%      +5.9%      62353 ±  1%  vmstat.system.cs
       269 ±  2%      +3.8%        279 ±  0%  time.system_time
        93 ±  1%      +3.5%         96 ±  0%  time.percent_of_cpu_this_job_got

ivb42: Ivytown Ivy Bridge-EP
Memory: 64G




                                 thrulay.throughput

  44000 ++-*----------------------------------------------------------------+
        |..:                                                                |
  42000 *+  :       .*..*.     .*.                                          |
        |   :   *.*.      *..*.   *..*                                      |
        |    :..                      +      *.                             |
  40000 ++   *                         *..  +  *..        *                 |
        |                                  +      *.*.. .. :                |
  38000 ++                                *            *   :  .*..          |
        |                                                   *.     .*..*.*  |
  36000 ++                                             O          *         |
        |                                           O     O O       O    O  O
        O  O O  O    O  O       O      O  O    O               O  O         |
  34000 ++        O       O                  O    O                    O    |
        |                         O  O                                      |
  32000 ++-------------------O----------------------------------------------+


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
Huang, Ying


--=-rA/T2kpl1mnz9Vq2/58p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: thrulay
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
commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
model: Ivytown Ivy Bridge-EP
nr_cpu: 48
memory: 64G
rootfs: debian-x86_64.cgz
runtime: 300s
thrulay: 
testbox: ivb42
tbox_group: ivb42
kconfig: x86_64-rhel
enqueue_time: 2014-12-08 05:18:17.151038272 +08:00
head_commit: d273c3193b966e6ecdc5948b3d86efb8514ee335
base_commit: 009d0431c3914de64666bec0d350e54fdd59df6a
branch: internal-eywa/master
kernel: "/kernel/x86_64-rhel/b2776bf7149bddd1f4161f14f79520f17fc1d71d/vmlinuz-3.18.0-gb2776bf"
user: lkp
queue: cyclic
result_root: "/result/ivb42/thrulay/performance-300s/debian-x86_64.cgz/x86_64-rhel/b2776bf7149bddd1f4161f14f79520f17fc1d71d/0"
job_file: "/lkp/scheduled/ivb42/cyclic_thrulay-performance-300s-debian-x86_64.cgz-x86_64-rhel-BASE-b2776bf7149bddd1f4161f14f79520f17fc1d71d-0.yaml"
dequeue_time: 2014-12-09 09:16:04.465533630 +08:00
job_state: finished
loadavg: 1.11 0.89 0.42 1/410 10159
start_time: '1418087801'
end_time: '1418088102'
version: "/lkp/lkp/.src-20141206-060219"

--=-rA/T2kpl1mnz9Vq2/58p
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
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
thrulayd
thrulay -t 300 127.0.0.1

--=-rA/T2kpl1mnz9Vq2/58p
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-rA/T2kpl1mnz9Vq2/58p--

