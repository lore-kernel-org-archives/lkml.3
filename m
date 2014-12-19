Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaLSEvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 23:51:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:13365 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbaLSEuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 23:50:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="431051437"
Message-ID: <1418964602.26403.23.camel@intel.com>
Subject: [LKP] [vmstat] 7cc36bbddde: +2.6% will-it-scale.scalability -28.7%
 time.involuntary_context_switches
From: Huang Ying <ying.huang@intel.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Fri, 19 Dec 2014 12:50:02 +0800
Content-Type: multipart/mixed; boundary="=-TQ5O/972nk6/5R1bjHQ4"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TQ5O/972nk6/5R1bjHQ4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 7cc36bbddde5cd0c98f0c06e3304ab833d662565 ("vmstat: on-demand vmstat workers V8")


testbox/testcase/testparams: lkp-sbx04/will-it-scale/performance-pread2

f0d6d1f6ff6f8525  7cc36bbddde5cd0c98f0c06e33  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
      0.00 ±  1%      +2.6%       0.00 ±  1%  will-it-scale.scalability
    533566 ±  0%      -1.2%     527362 ±  0%  will-it-scale.per_process_ops
    486263 ±  0%      -0.9%     481764 ±  0%  will-it-scale.per_thread_ops
       355 ± 14%    +163.0%        933 ± 37%  sched_debug.cpu#20.curr->pid
         6 ± 34%    +148.0%         15 ± 11%  sched_debug.cfs_rq[52]:/.load
     11214 ± 48%     -55.6%       4973 ± 14%  sched_debug.cfs_rq[11]:/.exec_clock
         5 ± 31%     -55.0%          2 ± 48%  sched_debug.cpu#5.cpu_load[1]
     88729 ± 46%     -53.2%      41487 ±  3%  sched_debug.cfs_rq[11]:/.min_vruntime
       408 ± 34%     -56.8%        176 ±  3%  sched_debug.cpu#43.ttwu_local
         7 ± 34%    +114.3%         15 ± 12%  sched_debug.cpu#52.load
        13 ± 46%     +70.4%         23 ± 26%  sched_debug.cpu#43.load
         4 ± 17%    +105.3%          9 ± 19%  sched_debug.cfs_rq[6]:/.blocked_load_avg
      6562 ± 25%    +120.1%      14443 ± 16%  sched_debug.cfs_rq[7]:/.exec_clock
         3 ± 22%     -46.7%          2 ±  0%  sched_debug.cfs_rq[28]:/.blocked_load_avg
     68456 ± 17%     -39.7%      41302 ± 47%  sched_debug.cfs_rq[46]:/.spread0
       187 ± 15%     -38.2%        115 ± 18%  sched_debug.cpu#40.ttwu_local
       941 ± 25%     +76.9%       1665 ± 19%  sched_debug.cpu#52.curr->pid
        11 ±  3%    +104.4%         23 ± 49%  sched_debug.cfs_rq[48]:/.tg_load_contrib
       534 ± 20%     +87.9%       1003 ± 48%  sched_debug.cpu#6.ttwu_local
     51437 ± 28%     +55.8%      80132 ± 19%  sched_debug.cfs_rq[8]:/.min_vruntime
     14311 ± 23%     +67.2%      23936 ± 24%  sched_debug.cpu#22.sched_goidle
         9 ±  8%     -35.9%          6 ± 26%  sched_debug.cpu#39.cpu_load[4]
     14113 ± 24%     +66.8%      23537 ± 25%  sched_debug.cpu#22.ttwu_count
     28742 ± 23%     +66.8%      47938 ± 24%  sched_debug.cpu#22.nr_switches
         7 ± 17%     -27.6%          5 ± 20%  sched_debug.cpu#42.cpu_load[0]
     58556 ± 16%     -32.5%      39547 ±  4%  sched_debug.cfs_rq[12]:/.min_vruntime
       199 ±  9%     -37.1%        125 ± 12%  sched_debug.cpu#46.ttwu_local
    161308 ± 28%     -45.6%      87699 ± 30%  sched_debug.cpu#2.sched_goidle
    322838 ± 28%     -45.6%     175601 ± 30%  sched_debug.cpu#2.nr_switches
       188 ±  8%     -30.3%        131 ± 11%  sched_debug.cpu#47.ttwu_local
    330608 ± 31%     -46.5%     176795 ± 29%  sched_debug.cpu#2.sched_count
       407 ± 12%     +39.7%        568 ± 10%  sched_debug.cpu#30.ttwu_local
        75 ± 21%     +31.5%         99 ± 19%  sched_debug.cfs_rq[8]:/.tg_runnable_contrib
         9 ± 15%     -33.3%          6 ± 11%  sched_debug.cpu#36.cpu_load[1]
      3494 ± 21%     +31.0%       4578 ± 18%  sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
       304 ±  9%     -28.7%        217 ±  9%  sched_debug.cpu#39.ttwu_local
       118 ± 10%     -25.2%         88 ± 11%  sched_debug.cpu#48.ttwu_local
    171927 ± 32%     -45.5%      93673 ± 34%  sched_debug.cpu#2.ttwu_count
     68928 ± 14%     -41.9%      40061 ± 46%  sched_debug.cfs_rq[40]:/.spread0
         9 ± 11%     -33.3%          6 ± 17%  sched_debug.cpu#38.cpu_load[4]
         9 ± 15%     -25.6%          7 ± 15%  sched_debug.cpu#38.cpu_load[3]
       537 ± 15%     -28.3%        385 ± 14%  sched_debug.cpu#9.ttwu_local
      2694 ± 15%     -21.5%       2116 ±  6%  sched_debug.cfs_rq[16]:/.avg->runnable_avg_sum
        58 ± 15%     -21.1%         45 ±  6%  sched_debug.cfs_rq[16]:/.tg_runnable_contrib
      0.05 ±  8%     +33.3%       0.07 ± 10%  turbostat.%c3
    130948 ± 11%     -40.3%      78138 ± 47%  sched_debug.cfs_rq[39]:/.spread0
       282 ± 10%     -22.1%        220 ±  7%  sched_debug.cpu#38.ttwu_local
     20679 ± 18%     -26.9%      15120 ± 17%  numa-meminfo.node2.Active(anon)
      5170 ± 18%     -26.9%       3778 ± 17%  numa-vmstat.node2.nr_active_anon
     36499 ±  4%     -24.1%      27721 ±  8%  sched_debug.cfs_rq[39]:/.exec_clock
    259406 ±  8%     -19.7%     208230 ± 10%  sched_debug.cfs_rq[39]:/.min_vruntime
       125 ±  5%     -20.5%         99 ± 14%  sched_debug.cpu#55.ttwu_local
        23 ± 10%     -26.1%         17 ± 19%  sched_debug.cfs_rq[44]:/.load
     82250 ±  9%     -20.9%      65029 ± 11%  sched_debug.cfs_rq[2]:/.min_vruntime
     80988 ±  8%     +17.1%      94812 ±  7%  meminfo.DirectMap4k
        47 ± 10%     +15.3%         54 ±  8%  sched_debug.cfs_rq[20]:/.tg_runnable_contrib
        73 ±  7%     -22.9%         56 ±  8%  sched_debug.cpu#63.ttwu_local
     46694 ±  4%     +29.7%      60558 ±  7%  sched_debug.cpu#7.nr_load_updates
      2205 ±  9%     +15.1%       2539 ±  8%  sched_debug.cfs_rq[20]:/.avg->runnable_avg_sum
       772 ± 10%     -17.6%        636 ±  4%  sched_debug.cpu#33.ttwu_local
      1.64 ±  3%     +21.3%       1.98 ± 10%  perf-profile.cpu-cycles.copy_user_generic_string.copy_page_to_iter.shmem_file_read_iter.new_sync_read.vfs_read
       140 ± 25%     -34.4%         92 ±  9%  sched_debug.cpu#54.ttwu_local
      1.27 ±  4%     -14.0%       1.09 ±  9%  perf-profile.cpu-cycles.put_page.shmem_file_read_iter.new_sync_read.vfs_read.sys_pread64
      1.72 ±  7%     -14.8%       1.46 ±  9%  perf-profile.cpu-cycles.find_get_entry.find_lock_entry.shmem_getpage_gfp.shmem_file_read_iter.new_sync_read
       251 ±  1%     -17.8%        206 ± 11%  sched_debug.cfs_rq[39]:/.tg_runnable_contrib
     11533 ±  1%     -17.7%       9492 ± 11%  sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum
    649966 ±  7%     +20.0%     779700 ±  5%  sched_debug.cpu#36.ttwu_count
      3.99 ±  2%     +20.4%       4.80 ±  7%  perf-profile.cpu-cycles.__wake_up_common.__wake_up.__wake_up_bit.unlock_page.shmem_file_read_iter
    613256 ±  9%      -9.5%     555274 ± 10%  sched_debug.cpu#26.avg_idle
       554 ± 22%     +55.5%        862 ± 39%  sched_debug.cpu#3.ttwu_local
         8 ±  4%     +51.4%         13 ± 33%  sched_debug.cfs_rq[25]:/.tg_load_contrib
    637300 ±  8%     +15.3%     734754 ±  5%  sched_debug.cpu#36.sched_goidle
   1275355 ±  8%     +15.3%    1470926 ±  5%  sched_debug.cpu#36.sched_count
   1274943 ±  8%     +15.3%    1469761 ±  5%  sched_debug.cpu#36.nr_switches
    101711 ±  5%     -13.8%      87699 ±  7%  sched_debug.cpu#39.nr_load_updates
       374 ± 19%     -31.5%        256 ± 13%  sched_debug.cpu#32.ttwu_local
    249095 ±  6%     -14.2%     213769 ±  7%  sched_debug.cfs_rq[38]:/.min_vruntime
     34404 ±  5%     -15.9%      28935 ±  8%  sched_debug.cfs_rq[38]:/.exec_clock
     44719 ±  5%     -11.1%      39771 ±  6%  sched_debug.cpu#62.nr_load_updates
      1.06 ±  6%     +13.5%       1.20 ±  6%  perf-profile.cpu-cycles.wake_bit_function.__wake_up.__wake_up_bit.unlock_page.shmem_file_read_iter
     11248 ±  5%     -13.2%       9765 ±  9%  sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum
      2425 ± 14%     +18.9%       2883 ±  7%  sched_debug.cfs_rq[19]:/.exec_clock
       245 ±  5%     -13.0%        213 ±  9%  sched_debug.cfs_rq[38]:/.tg_runnable_contrib
       129 ±  3%     -21.3%        101 ± 10%  sched_debug.cpu#53.ttwu_local
     41965 ±  9%     -13.8%      36182 ±  5%  numa-meminfo.node2.Active
      4000 ±  0%     -11.1%       3554 ±  7%  proc-vmstat.nr_shmem
     16003 ±  0%     -11.1%      14220 ±  7%  meminfo.Shmem
        94 ±  3%     +10.6%        104 ±  4%  sched_debug.cfs_rq[41]:/.tg_runnable_contrib
      5773 ± 11%     -15.2%       4893 ±  6%  numa-vmstat.node1.nr_slab_unreclaimable
      4366 ±  3%     +10.4%       4818 ±  4%  sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
     23094 ± 11%     -15.2%      19576 ±  6%  numa-meminfo.node1.SUnreclaim
     55562 ±  4%     -11.5%      49192 ± 10%  sched_debug.cpu#2.nr_load_updates
     32616 ±  3%     -10.2%      29304 ±  8%  sched_debug.cpu#61.ttwu_count
    667746 ± 13%     +21.4%     810334 ±  3%  sched_debug.cpu#34.ttwu_count
     34230 ±  6%     -11.2%      30408 ±  2%  numa-meminfo.node1.Slab
      1835 ±  2%     +12.1%       2057 ±  6%  numa-meminfo.node1.KernelStack
      4589 ±  1%     -28.7%       3271 ±  2%  time.involuntary_context_switches
       359 ±  3%      +5.2%        378 ±  0%  time.percent_of_cpu_this_job_got
      1105 ±  3%      +5.2%       1163 ±  0%  time.system_time

lkp-sbx04: Sandy Bridge-EX
Memory: 64G




                         time.involuntary_context_switches

  5000 ++-------------------------------------------------------------------+
  4500 ++*.*.*.*.*.*. .*.*.*. .*.*.*.*.*. *.*.*.*                           |
       *             *       *           *                                  |
  4000 ++                                                                   |
  3500 O+O O O   O     O O O     O O                                        |
       |       O   O O       O O     O O OO O   O O   O O O O O O O O O O O O
  3000 ++                                                                   |
  2500 ++                                                                   |
  2000 ++                                                                   |
       |                                                                    |
  1500 ++                                                                   |
  1000 ++                                                                   |
       |                                                                    |
   500 ++                                                                   |
     0 ++-------------------------------------O-----O-----------------------+


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


--=-TQ5O/972nk6/5R1bjHQ4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

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
model: Sandy Bridge-EX
nr_cpu: 64
memory: 64G
nr_ssd_partitions: 4
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2CW240A3_CVCV20430*-part1"
swap_partitions: 
perf-profile:
  freq: 800
will-it-scale:
  test:
  - pread2
testbox: lkp-sbx04
tbox_group: lkp-sbx04
kconfig: x86_64-rhel
enqueue_time: 2014-12-08 14:35:08.024262582 +08:00
head_commit: 6888df25fb1b446378b0ea9ea978c18f492f4ee1
base_commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
branch: linux-devel/devel-hourly-2014120811
kernel: "/kernel/x86_64-rhel/b2776bf7149bddd1f4161f14f79520f17fc1d71d/vmlinuz-3.18.0-gb2776bf"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-sbx04/will-it-scale/performance-pread2/debian-x86_64.cgz/x86_64-rhel/b2776bf7149bddd1f4161f14f79520f17fc1d71d/0"
job_file: "/lkp/scheduled/lkp-sbx04/cyclic_will-it-scale-performance-pread2-x86_64-rhel-BASE-b2776bf7149bddd1f4161f14f79520f17fc1d71d-0.yaml"
dequeue_time: 2014-12-08 17:23:43.107041538 +08:00
job_state: finished
loadavg: 43.43 21.08 8.32 1/530 13949
start_time: '1418030675'
end_time: '1418030984'
version: "/lkp/lkp/.src-20141206-060219"

--=-TQ5O/972nk6/5R1bjHQ4
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
./runtest.py pread2 16 1 8 16 24 32 48 64

--=-TQ5O/972nk6/5R1bjHQ4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-TQ5O/972nk6/5R1bjHQ4--

