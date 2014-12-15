Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaLOD1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:27:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:60606 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaLOD05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:26:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="428937100"
Message-ID: <1418614015.5745.166.camel@intel.com>
Subject: [LKP] [f2fs] 8b26ef98da3: + 27.4% iostat.sda.wrqm/s
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Mon, 15 Dec 2014 11:26:55 +0800
Content-Type: multipart/mixed; boundary="=-xIh/AEZ0rj5mhsBZ055n"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xIh/AEZ0rj5mhsBZ055n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 8b26ef98da3387eb57a8a5c1747c6e628948ee0c ("f2fs: use rw_semaphore for nat entry lock")

testbox/testcase/testparams: lkp-ne04/fsmark/performance-1x-32t-1HDD-f2fs-8K-400M-fsyncBeforeClose-16d-256fpd

4634d71ed190c99e  8b26ef98da3387eb57a8a5c174  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
       420 ±  0%     +12.0%        470 ±  0%  fsmark.files_per_sec
      7.37 ± 22%     -84.0%       1.18 ± 26%  turbostat.%pc6
      2122 ±  2%    +929.0%      21838 ±  1%  proc-vmstat.pgactivate
     41341 ± 34%    +226.9%     135151 ± 40%  sched_debug.cpu#4.sched_count
      4093 ± 29%    +266.1%      14988 ± 21%  sched_debug.cpu#12.ttwu_count
  20670219 ± 24%    +243.7%   71049994 ± 11%  cpuidle.C1-NHM.time
      4279 ± 25%    +237.2%      14431 ± 19%  sched_debug.cpu#14.ttwu_count
      3995 ± 19%    +237.7%      13492 ± 22%  sched_debug.cpu#11.ttwu_count
      4092 ± 25%    +230.0%      13503 ± 19%  sched_debug.cpu#15.ttwu_count
      7241 ± 14%    +218.7%      23080 ± 18%  sched_debug.cpu#3.ttwu_count
      4065 ± 28%    +251.5%      14291 ± 24%  sched_debug.cpu#13.ttwu_count
        23 ± 48%    +201.1%         69 ± 12%  cpuidle.POLL.usage
     12604 ± 11%    +161.1%      32904 ± 28%  sched_debug.cpu#11.nr_switches
      5441 ± 15%    +164.0%      14365 ± 27%  sched_debug.cpu#11.sched_goidle
     12902 ±  9%    +163.0%      33936 ± 33%  sched_debug.cpu#13.nr_switches
      8230 ± 13%    +182.2%      23230 ± 20%  sched_debug.cpu#1.ttwu_count
     13010 ±  9%    +153.2%      32947 ± 28%  sched_debug.cpu#15.nr_switches
      5571 ± 11%    +160.5%      14511 ± 30%  sched_debug.cpu#13.sched_goidle
     13596 ± 13%    +172.7%      37082 ± 38%  sched_debug.cpu#15.sched_count
      7563 ± 16%    +200.9%      22762 ± 22%  sched_debug.cpu#7.ttwu_count
      5598 ± 12%    +156.2%      14342 ± 26%  sched_debug.cpu#15.sched_goidle
     16069 ± 23%    +117.8%      34992 ± 25%  sched_debug.cpu#14.nr_switches
     14194 ±  8%    +152.8%      35879 ± 26%  sched_debug.cpu#12.nr_switches
     13397 ± 11%    +158.2%      34598 ± 22%  sched_debug.cpu#11.sched_count
     14596 ±  9%    +148.3%      36240 ± 25%  sched_debug.cpu#12.sched_count
     13647 ± 10%    +150.2%      34139 ± 32%  sched_debug.cpu#13.sched_count
      6705 ± 20%    +127.1%      15225 ± 23%  sched_debug.cpu#14.sched_goidle
      6177 ± 10%    +151.7%      15546 ± 24%  sched_debug.cpu#12.sched_goidle
     16275 ± 23%    +139.7%      39015 ± 17%  sched_debug.cpu#14.sched_count
      6218 ± 15%    +209.6%      19252 ± 45%  sched_debug.cpu#10.sched_goidle
     21820 ±  6%    +123.4%      48742 ± 25%  sched_debug.cpu#7.nr_switches
     22931 ± 10%    +159.5%      59497 ± 44%  sched_debug.cpu#5.nr_switches
      9865 ±  8%    +120.0%      21709 ± 24%  sched_debug.cpu#7.sched_goidle
     10505 ± 12%    +141.8%      25405 ± 37%  sched_debug.cpu#5.sched_goidle
     12980 ±  6%    +107.7%      26956 ± 16%  sched_debug.cpu#4.ttwu_count
     24231 ± 18%    +103.6%      49334 ± 24%  sched_debug.cpu#3.nr_switches
     11147 ± 14%     +99.2%      22210 ± 22%  sched_debug.cpu#1.sched_goidle
     11092 ± 21%     +99.0%      22076 ± 23%  sched_debug.cpu#3.sched_goidle
     29443 ±  8%     +89.3%      55744 ± 20%  sched_debug.cpu#4.nr_switches
     32087 ±  7%     +81.3%      58169 ± 18%  sched_debug.cpu#2.nr_switches
     12984 ± 17%    +111.4%      27446 ± 12%  sched_debug.cpu#2.ttwu_count
     26458 ± 18%     +89.7%      50191 ± 24%  sched_debug.cpu#1.nr_switches
     14505 ±  8%     +98.6%      28807 ± 29%  sched_debug.cpu#0.sched_goidle
     13628 ±  8%     +81.1%      24686 ± 17%  sched_debug.cpu#2.sched_goidle
     13700 ±  9%     +82.6%      25012 ± 18%  sched_debug.cpu#4.sched_goidle
     33822 ±  9%    +102.3%      68417 ± 35%  sched_debug.cpu#0.nr_switches
     18438 ± 28%    +160.1%      47957 ± 23%  cpuidle.C1-NHM.usage
      6.50 ± 10%     +73.2%      11.25 ±  7%  turbostat.%c1
        14 ± 13%     +52.5%         22 ± 12%  sched_debug.cfs_rq[13]:/.tg_runnable_contrib
    135553 ±  6%     +73.5%     235188 ±  6%  cpuidle.C3-NHM.usage
       723 ± 13%     +48.3%       1072 ± 10%  sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
     28.84 ±  9%     +52.2%      43.89 ±  5%  turbostat.%c3
     63.48 ±  3%     -31.8%      43.29 ±  5%  turbostat.%c6
     30737 ±  0%     -31.0%      21223 ±  1%  softirqs.BLOCK
      2329 ±  5%     +31.1%       3052 ± 11%  sched_debug.cfs_rq[14]:/.min_vruntime
 3.494e+08 ± 12%     +48.6%  5.192e+08 ±  5%  cpuidle.C3-NHM.time
 1.545e+09 ±  2%     -27.1%  1.126e+09 ±  2%  cpuidle.C6-NHM.time
  26451473 ±  5%     -28.7%   18850454 ± 17%  cpuidle.C1E-NHM.time
    304184 ±  6%     +36.3%     414743 ±  6%  cpuidle.C6-NHM.usage
       362 ±  2%     +28.7%        466 ±  6%  sched_debug.cfs_rq[0]:/.tg->runnable_avg
       363 ±  2%     +28.6%        467 ±  6%  sched_debug.cfs_rq[1]:/.tg->runnable_avg
       364 ±  1%     +28.4%        467 ±  6%  sched_debug.cfs_rq[2]:/.tg->runnable_avg
       367 ±  1%     +28.0%        470 ±  6%  sched_debug.cfs_rq[3]:/.tg->runnable_avg
       369 ±  1%     +27.9%        472 ±  5%  sched_debug.cfs_rq[4]:/.tg->runnable_avg
    977486 ±  1%     -21.6%     766721 ± 11%  sched_debug.cpu#13.avg_idle
       372 ±  1%     +27.2%        473 ±  6%  sched_debug.cfs_rq[5]:/.tg->runnable_avg
       373 ±  1%     +27.6%        476 ±  6%  sched_debug.cfs_rq[6]:/.tg->runnable_avg
       379 ±  1%     +27.2%        482 ±  6%  sched_debug.cfs_rq[8]:/.tg->runnable_avg
       376 ±  1%     +27.5%        479 ±  5%  sched_debug.cfs_rq[7]:/.tg->runnable_avg
       381 ±  1%     +26.8%        484 ±  6%  sched_debug.cfs_rq[9]:/.tg->runnable_avg
     41363 ±  5%     +59.4%      65923 ± 48%  sched_debug.cpu#0.ttwu_count
       384 ±  1%     +23.1%        473 ±  8%  sched_debug.cfs_rq[10]:/.tg->runnable_avg
    986988 ±  0%     -19.5%     794664 ±  4%  sched_debug.cpu#11.avg_idle
       386 ±  1%     +22.8%        474 ±  8%  sched_debug.cfs_rq[11]:/.tg->runnable_avg
       389 ±  2%     +22.0%        475 ±  8%  sched_debug.cfs_rq[13]:/.tg->runnable_avg
       392 ±  2%     +21.2%        476 ±  8%  sched_debug.cfs_rq[14]:/.tg->runnable_avg
       388 ±  1%     +22.1%        474 ±  8%  sched_debug.cfs_rq[12]:/.tg->runnable_avg
       396 ±  2%     +20.8%        478 ±  7%  sched_debug.cfs_rq[15]:/.tg->runnable_avg
    940409 ±  1%     -12.3%     824690 ±  4%  sched_debug.cpu#0.avg_idle
    927692 ±  3%     -12.9%     807567 ±  5%  sched_debug.cpu#2.avg_idle
      3216 ±  5%     -10.8%       2870 ±  3%  proc-vmstat.nr_alloc_batch
    979736 ±  0%     -13.5%     847782 ±  4%  sched_debug.cpu#12.avg_idle
    245057 ±  6%     -12.1%     215473 ± 11%  numa-vmstat.node1.numa_local
      1620 ±  4%     -11.5%       1435 ±  8%  numa-vmstat.node0.nr_alloc_batch
    894470 ±  3%     -12.4%     783635 ±  7%  sched_debug.cpu#7.avg_idle
    965398 ±  2%     -11.1%     858414 ±  6%  sched_debug.cpu#14.avg_idle
    167233 ±  0%    +239.7%     568014 ±  0%  time.voluntary_context_switches
      5760 ±  0%    +115.2%      12394 ±  1%  vmstat.system.cs
      7938 ±  2%     +86.4%      14800 ±  2%  time.involuntary_context_switches
         9 ±  7%     +72.2%         15 ±  5%  time.percent_of_cpu_this_job_got
     10.79 ±  4%     +52.9%      16.50 ±  4%  time.system_time
      1.18 ±  2%     +33.8%       1.57 ±  3%  turbostat.%c0
       394 ±  1%     +27.4%        502 ±  1%  iostat.sda.wrqm/s
     17.69 ±  0%     -13.3%      15.33 ±  0%  iostat.sda.avgqu-sz
      5140 ±  1%     +14.8%       5900 ±  0%  vmstat.io.bo
      5183 ±  1%     +14.5%       5935 ±  0%  iostat.sda.wkB/s
       833 ±  0%     -10.5%        746 ±  0%  iostat.sda.w/s
       122 ±  0%     -10.4%        109 ±  0%  time.elapsed_time
      1174 ±  1%      +5.4%       1238 ±  1%  vmstat.system.in
      2.17 ±  1%      -4.6%       2.06 ±  1%  turbostat.GHz
   1280314 ±  0%      +2.9%    1317252 ±  0%  time.file_system_outputs

lkp-ne04: Nehalem-EP
Memory: 12G




                                 iostat.sda.wrqm/s

  600 ++--------------------------------------------------------------------+
      |                                                                     |
  500 O+O O  O O O O O  O O O O O O  O O O O O  O O O O O  O O O            |
      |                                                                     |
      |                                                                     |
  400 *+*.*..*.*.*.*.*..*.*.*.*.*.*..*.*.*.*.*..*.*.*   *    *.*.*.*.*..*.*.*
      |                                             :   :    :              |
  300 ++                                            :   ::   :              |
      |                                              : : :  :               |
  200 ++                                             : : :  :               |
      |                                              : :  : :               |
      |                                              : :  : :               |
  100 ++                                              :   ::                |
      |                                               :    :                |
    0 ++----------------------------------------------*----*----------------+


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


--=-xIh/AEZ0rj5mhsBZ055n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: fsmark
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
commit: b6c4cf175369b31552fad86422f1f4d9847b16eb
model: Nehalem-EP
memory: 12G
hdd_partitions: "/dev/disk/by-id/ata-ST3500514NS_9WJ03EBA-part3"
swap_partitions: "/dev/disk/by-id/ata-ST3120026AS_5MS07HA2-part2"
rootfs_partition: "/dev/disk/by-id/ata-ST3500514NS_9WJ03EBA-part1"
iterations: 1x
nr_threads: 32t
disk: 1HDD
fs:
- f2fs
fs2:
- 
fsmark:
  filesize:
  - 8K
  test_size: 400M
  sync_method: fsyncBeforeClose
  nr_directories: 16d
  nr_files_per_directory: 256fpd
testbox: lkp-ne04
tbox_group: lkp-ne04
kconfig: x86_64-rhel
enqueue_time: 2014-12-13 00:40:16.264380860 +08:00
head_commit: b6c4cf175369b31552fad86422f1f4d9847b16eb
base_commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
branch: linux-devel/devel-hourly-2014121201
kernel: "/kernel/x86_64-rhel/b6c4cf175369b31552fad86422f1f4d9847b16eb/vmlinuz-3.18.0-gb6c4cf1"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-ne04/fsmark/performance-1x-32t-1HDD-f2fs-8K-400M-fsyncBeforeClose-16d-256fpd/debian-x86_64.cgz/x86_64-rhel/b6c4cf175369b31552fad86422f1f4d9847b16eb/0"
job_file: "/lkp/scheduled/lkp-ne04/cyclic_fsmark-performance-1x-32t-1HDD-f2fs-8K-400M-fsyncBeforeClose-16d-256fpd-x86_64-rhel-HEAD-b6c4cf175369b31552fad86422f1f4d9847b16eb-0.yaml"
dequeue_time: 2014-12-13 07:56:47.578843098 +08:00
job_state: finished
loadavg: 21.49 9.31 3.47 1/210 5298
start_time: '1418428648'
end_time: '1418428756'
version: "/lkp/lkp/.src-20141212-075301"

--=-xIh/AEZ0rj5mhsBZ055n
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
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
mkfs -t f2fs /dev/sda3
mount -t f2fs /dev/sda3 /fs/sda3
./fs_mark -d /fs/sda3/1 -d /fs/sda3/2 -d /fs/sda3/3 -d /fs/sda3/4 -d /fs/sda3/5 -d /fs/sda3/6 -d /fs/sda3/7 -d /fs/sda3/8 -d /fs/sda3/9 -d /fs/sda3/10 -d /fs/sda3/11 -d /fs/sda3/12 -d /fs/sda3/13 -d /fs/sda3/14 -d /fs/sda3/15 -d /fs/sda3/16 -d /fs/sda3/17 -d /fs/sda3/18 -d /fs/sda3/19 -d /fs/sda3/20 -d /fs/sda3/21 -d /fs/sda3/22 -d /fs/sda3/23 -d /fs/sda3/24 -d /fs/sda3/25 -d /fs/sda3/26 -d /fs/sda3/27 -d /fs/sda3/28 -d /fs/sda3/29 -d /fs/sda3/30 -d /fs/sda3/31 -d /fs/sda3/32 -D 16 -N 256 -n 1600 -L 1 -S 1 -s 8192

--=-xIh/AEZ0rj5mhsBZ055n
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-xIh/AEZ0rj5mhsBZ055n--

