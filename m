Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKGGAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:00:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:38139 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaKGGAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:00:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="412841995"
Date: Fri, 7 Nov 2014 14:00:40 +0800
From: LKP <lkp@01.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [x86_64,entry] f04e05b81e4: -62.7% time.user_time
Message-ID: <20141107060040.GD30507@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GpGaEY17fSl8rd50"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/entry
commit f04e05b81e4d9ae88bee379f12176f551a24394a ("x86_64,entry: Use sysret to return to userspace when possible")


f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  testbox/testcase/testparams
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     24.09 ±  4%     -62.7%       8.99 ±  3%  lkp-wsx02/aim9/performance-300s-creat-clo
     24.09           -62.7%       8.99        GEO-MEAN time.user_time

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
      1571 ±  1%     -13.5%       1359 ±  0%  lkp-wsx02/aim9/performance-300s-creat-clo
      1571           -13.5%       1359        GEO-MEAN vmstat.system.cs

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
       276 ±  0%      +5.5%        291 ±  0%  lkp-wsx02/aim9/performance-300s-creat-clo
       276            +5.5%        291        GEO-MEAN time.system_time

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  ---------------------------
       430 ± 36%     -36.0%        275 ± 39%  lkp-wsx02/aim9/performance-300s-creat-clo
       430           -36.0%        275        GEO-MEAN sched_debug.cpu#38.ttwu_count

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
  52761811 ± 29%     -54.7%   23885493 ± 11%  lkp-wsx02/aim9/performance-300s-creat-clo
  52761811           -54.7%   23885493        GEO-MEAN cpuidle.C1E-NHM.time

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     21939 ±  8%     +42.6%      31283 ± 23%  lkp-wsx02/aim9/performance-300s-creat-clo
     21939           +42.6%      31283        GEO-MEAN numa-meminfo.node1.SUnreclaim

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
      5484 ±  8%     +40.3%       7694 ± 22%  lkp-wsx02/aim9/performance-300s-creat-clo
      5484           +40.3%       7694        GEO-MEAN numa-vmstat.node1.nr_slab_unreclaimable

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     34004 ±  2%     +69.9%      57781 ±  4%  lkp-wsx02/aim9/performance-300s-creat-clo
     34004           +69.9%      57781        GEO-MEAN slabinfo.kmalloc-256.active_objs

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
      1075 ±  2%     +68.8%       1815 ±  4%  lkp-wsx02/aim9/performance-300s-creat-clo
      1074           +68.8%       1814        GEO-MEAN slabinfo.kmalloc-256.active_slabs

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
      1075 ±  2%     +68.8%       1815 ±  4%  lkp-wsx02/aim9/performance-300s-creat-clo
      1074           +68.8%       1814        GEO-MEAN slabinfo.kmalloc-256.num_slabs

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     34415 ±  2%     +68.8%      58099 ±  4%  lkp-wsx02/aim9/performance-300s-creat-clo
     34415           +68.8%      58099        GEO-MEAN slabinfo.kmalloc-256.num_objs

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     32500 ±  7%     +31.0%      42586 ± 17%  lkp-wsx02/aim9/performance-300s-creat-clo
     32500           +31.0%      42586        GEO-MEAN numa-meminfo.node1.Slab

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     73657 ±  1%     -23.4%      56388 ±  3%  lkp-wsx02/aim9/performance-300s-creat-clo
     73657           -23.4%      56388        GEO-MEAN softirqs.RCU

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     10427 ± 14%     -16.8%       8675 ±  6%  lkp-wsx02/aim9/performance-300s-creat-clo
     10427           -16.8%       8675        GEO-MEAN sched_debug.cfs_rq[0]:/.exec_clock

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
     24242 ±  8%     +18.4%      28696 ± 12%  lkp-wsx02/aim9/performance-300s-creat-clo
     24242           +18.4%      28696        GEO-MEAN numa-meminfo.node3.Active

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
      2076 ±  7%     +12.1%       2328 ±  2%  lkp-wsx02/aim9/performance-300s-creat-clo
      2076           +12.1%       2327        GEO-MEAN numa-meminfo.node2.KernelStack

f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  
----------------  --------------------------  
   1139198 ±  5%      -6.6%    1063912 ±  0%  lkp-wsx02/aim9/performance-300s-creat-clo
   1139198            -6.6%    1063912        GEO-MEAN proc-vmstat.pgfault

lkp-wsx02: Westmere-EX
Memory: 128G




                                 time.user_time

  26 ++-----------------*----------------*--------*-------------------------+
     | .*..*...  .*..*.     *..*..*.. ..      .*.          .*..*..   .*..*..|
  24 *+        *.                    *      *.       *...*.        ..       *
  22 ++                                                           *         |
     |                                                                      |
  20 ++                                                                     |
  18 ++                                                                     |
     |                                                                      |
  16 ++                                                                     |
  14 ++                                                                     |
     |                                                                      |
  12 ++                                                                     |
  10 ++                                                                     |
     O     O         O  O      O  O                  O   O  O     O         |
   8 ++-O------O--O---------O--------O---O--O--O--O------------O------------+


                                 time.system_time

  294 ++--------------------------------------------------------------------+
  292 ++        O           O         O  O  O  O   O                        |
      O  O  O      O  O  O     O   O                  O  O  O  O  O         |
  290 ++                                                                    |
  288 ++                                                                    |
      |                                                                     |
  286 ++                                                                    |
  284 ++                                                                    |
  282 ++                                                                    |
      |                                                                     |
  280 ++                                                                    |
  278 ++                                                          *..       |
      *..     ..*..                  .*..   *..      .*..*..    ..   .     .*
  276 ++ *..*.     *..*..*..*..*...*.     ..   *...*.       *..*      *..*. |
  274 ++---------------------------------*----------------------------------+


                                    softirqs.RCU

  80000 ++------------------------------------------------------------------+
        |                                                                   |
  75000 ++               ..*..*..*..              .*..      .*..   *..      |
        *..*..*..*..  .*.           *..*..  .*..*.    *.. ..     ..   *..*..*
        |           *.                    *.             *      *           |
  70000 ++                                                                  |
        |                                                                   |
  65000 ++                                                                  |
        |                                                                   |
  60000 ++                                                   O              |
        |                                                                   |
        |  O        O         O           O     O     O  O                  |
  55000 O+    O  O     O   O     O  O  O     O     O            O  O        |
        |                                                                   |
  50000 ++------------------------------------------------------------------+


                          slabinfo.kmalloc-256.active_objs

  70000 ++------------------------------------------------------------------+
        |                                                                   |
  65000 ++                          O  O                                    |
  60000 ++    O                  O        O  O  O  O  O  O                  |
        O  O     O  O  O   O                                 O     O        |
  55000 ++                                                                  |
        |                     O                                 O           |
  50000 ++                                                                  |
        |                                                                   |
  45000 ++                                                                  |
  40000 ++                                                                  |
        |          .*..                                                     |
  35000 ++.*..  .*.    *..    *..*..        .*..     .*..*...  .*..     .*..*
        *.    *.          . ..      *..*..*.    *..*.        *.    *..*.    |
  30000 ++-----------------*------------------------------------------------+


                            slabinfo.kmalloc-256.num_objs

  70000 ++------------------------------------------------------------------+
        |                              O                                    |
  65000 ++                          O                                       |
  60000 ++    O  O               O        O  O  O  O  O  O                  |
        O  O        O  O   O                                 O     O        |
  55000 ++                                                                  |
        |                     O                                 O           |
  50000 ++                                                                  |
        |                                                                   |
  45000 ++                                                                  |
  40000 ++                                                                  |
        |          .*..                                                     |
  35000 *+.*..  .*.    *...  .*..*..        .*..     .*..*...*..*..*..  .*..*
        |     *.           *.       *..*..*.    *..*.                 *.    |
  30000 ++------------------------------------------------------------------+


                         slabinfo.kmalloc-256.active_slabs

  2200 ++-------------------------------------------------------------------+
       |                              O                                     |
  2000 ++                          O         O     O                        |
       |     O  O      O  O     O         O     O     O  O                  |
  1800 O+ O         O                                       O      O        |
       |                                                       O            |
  1600 ++                    O                                              |
       |                                                                    |
  1400 ++                                                                   |
       |                                                                    |
  1200 ++       *...*..                                                     |
       *..*.. ..       *..  .*..*..  .*...*..*..     .*..*..*..*...*..  .*..*
  1000 ++    *            *.       *.           *..*.                 *.    |
       |                                                                    |
   800 ++-------------------------------------------------------------------+


                          slabinfo.kmalloc-256.num_slabs

  2200 ++-------------------------------------------------------------------+
       |                              O                                     |
  2000 ++                          O         O     O                        |
       |     O  O      O  O     O         O     O     O  O                  |
  1800 O+ O         O                                       O      O        |
       |                                                       O            |
  1600 ++                    O                                              |
       |                                                                    |
  1400 ++                                                                   |
       |                                                                    |
  1200 ++       *...*..                                                     |
       *..*.. ..       *..  .*..*..  .*...*..*..     .*..*..*..*...*..  .*..*
  1000 ++    *            *.       *.           *..*.                 *.    |
       |                                                                    |
   800 ++-------------------------------------------------------------------+

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

--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: aim9
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
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: 7c130ce86d3169fb078ea36d2351a9bc5394f7bf
model: Westmere-EX
memory: 128G
nr_cpu: 80
nr_hdd_partitions: 0
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
aim9:
  testtime: 300s
  test:
  - creat-clo
enqueue_time: 2014-11-05 16:29:36.050246728 +08:00
testbox: lkp-wsx02
tbox_group: lkp-wsx02
kconfig: x86_64-rhel
head_commit: 7c130ce86d3169fb078ea36d2351a9bc5394f7bf
base_commit: 0df1f2487d2f0d04703f142813d53615d62a1da4
branch: linux-devel/devel-hourly-2014110522
kernel: "/kernel/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/vmlinuz-3.18.0-rc3-wl-ath-g7c130ce"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-wsx02/aim9/performance-300s-creat-clo/debian-x86_64.cgz/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/0"
job_file: "/lkp/scheduled/lkp-wsx02/cyclic_aim9-performance-300s-creat-clo-x86_64-rhel-HEAD-7c130ce86d3169fb078ea36d2351a9bc5394f7bf-0.yaml"
dequeue_time: 2014-11-06 01:16:18.253589953 +08:00
job_state: finished
loadavg: 0.91 0.72 0.34 1/633 13360
start_time: '1415207896'
end_time: '1415208196'
version: "/lkp/lkp/.src-20141105-221953"

--GpGaEY17fSl8rd50
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

--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--GpGaEY17fSl8rd50--
