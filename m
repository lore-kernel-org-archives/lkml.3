Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaL2G5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:57:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:17496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaL2G5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:57:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,658,1413270000"; 
   d="yaml'?scan'208";a="654325340"
Message-ID: <1419836251.4862.4.camel@intel.com>
Subject: [LKP] [xfs] dbe1b5ca263: +6.5% will-it-scale.per_thread_ops
From: Huang Ying <ying.huang@intel.com>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Date: Mon, 29 Dec 2014 14:57:31 +0800
Content-Type: multipart/mixed; boundary="=-Fx9fB9WDX1spGCbvgdFq"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fx9fB9WDX1spGCbvgdFq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit dbe1b5ca26396b6c61d711c8ac4de13ebb02e9f6 ("xfs: Make xfs_vn_rename compliant with renameat2() syscall")


testbox/testcase/testparams: lkp-nex05/will-it-scale/performance-pwrite1

       v3.19-rc1  dbe1b5ca26396b6c61d711c8ac  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
   1131870 ±  0%      +6.5%    1205531 ±  0%  will-it-scale.per_thread_ops
   1209729 ±  0%      +5.8%    1280184 ±  0%  will-it-scale.per_process_ops
      0.54 ±  0%      -3.1%       0.53 ±  1%  will-it-scale.scalability
      1400 ± 30%    +174.5%       3842 ± 34%  sched_debug.cpu#36.nr_switches
       810 ± 33%    +154.2%       2060 ± 25%  sched_debug.cpu#36.ttwu_count
       163 ± 41%     +96.6%        320 ± 42%  sched_debug.cpu#2.ttwu_local
       242 ± 38%     +71.4%        416 ± 19%  slabinfo.blkdev_queue.active_objs
       137 ± 28%     +99.3%        274 ± 22%  sched_debug.cpu#26.ttwu_local
        29 ± 44%    +116.0%         63 ± 28%  sched_debug.cfs_rq[50]:/.tg_load_contrib
      1296 ± 34%     +41.5%       1835 ± 19%  sched_debug.cpu#63.ttwu_local
       405 ± 30%     -42.3%        234 ± 15%  sched_debug.cpu#56.sched_goidle
       314 ± 27%     +43.6%        452 ± 11%  slabinfo.blkdev_queue.num_objs
       980 ± 28%     -37.7%        611 ± 13%  sched_debug.cpu#56.nr_switches
       684 ± 25%     +40.5%        962 ± 20%  sched_debug.cpu#10.ttwu_count
      1.03 ±  2%     -38.8%       0.63 ±  7%  perf-profile.cpu-cycles.current_kernel_time.file_update_time.__generic_file_write_iter.generic_file_write_iter.new_sync_write
       838 ± 25%     -33.1%        560 ± 14%  sched_debug.cpu#60.nr_switches
      4870 ± 19%     +25.8%       6127 ± 14%  sched_debug.cpu#63.nr_switches
      1443 ± 10%     +39.9%       2019 ± 23%  sched_debug.cpu#2.sched_count
        39 ± 20%     +55.1%         61 ± 16%  latency_stats.max.call_rwsem_down_write_failed.SyS_mprotect.system_call_fastpath
       336 ± 33%     -37.8%        209 ± 12%  sched_debug.cpu#60.sched_goidle
      2.27 ± 12%     -33.6%       1.51 ±  2%  perf-profile.cpu-cycles.rw_verify_area.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite
       394 ± 19%     -31.5%        270 ± 13%  sched_debug.cpu#52.sched_goidle
       986 ± 19%     -25.0%        740 ± 11%  sched_debug.cpu#52.nr_switches
      2.25 ±  4%     -28.4%       1.61 ±  6%  perf-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_write.sys_pwrite64.system_call_fastpath
       257 ± 15%     +52.9%        394 ± 28%  sched_debug.cpu#10.ttwu_local
      1.24 ± 10%     -26.7%       0.91 ±  8%  perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_write.sys_pwrite64
      1.12 ±  6%     -27.7%       0.81 ±  8%  perf-profile.cpu-cycles.rw_verify_area.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite64
      3385 ± 10%      +8.9%       3687 ±  8%  sched_debug.cpu#39.curr->pid
      4.01 ±  0%     +27.4%       5.11 ±  1%  perf-profile.cpu-cycles.file_update_time.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vfs_write
      1.05 ±  2%     -23.8%       0.80 ±  5%  perf-profile.cpu-cycles.iov_iter_fault_in_readable.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vfs_write
      0.83 ±  3%     +24.7%       1.03 ±  1%  perf-profile.cpu-cycles.current_fs_time.file_update_time.__generic_file_write_iter.generic_file_write_iter.new_sync_write
      0.88 ±  2%     +15.2%       1.02 ±  2%  perf-profile.cpu-cycles.__sb_end_write.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite64
      0.99 ±  1%     +14.5%       1.14 ±  1%  perf-profile.cpu-cycles.system_call.__libc_pwrite
      2.60 ±  2%     +11.7%       2.91 ±  0%  perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_pwrite64.system_call_fastpath
      3.56 ±  6%     +12.4%       4.00 ±  4%  perf-profile.cpu-cycles.unlock_page.shmem_write_end.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
       252 ±  0%      +7.8%        272 ±  1%  time.user_time

lkp-nex05: Nehalem-EX
Memory: 192G




                             will-it-scale.per_process_ops

   1.4e+06 ++--O--------------O---------------------------------------------+
  1.38e+06 O+         O   O                                                 |
           |                      O                                         |
  1.36e+06 ++      O                                                        |
  1.34e+06 ++                                                               |
           |                                                                |
  1.32e+06 ++                         O                                     |
   1.3e+06 ++                                O   O       O                  |
  1.28e+06 ++                             O          O       O      O   O   |
           |                                                     O          O
  1.26e+06 ++                                                               |
  1.24e+06 ++                                                               |
           |                                                                |
  1.22e+06 ++        .*...*...*...*...*...*..*                              |
   1.2e+06 *+--*---*--------------------------------------------------------+


                             will-it-scale.per_thread_ops

  1.32e+06 ++---------------------------------------------------------------+
   1.3e+06 ++  O      O   O                                                 |
           O       O          O                                             |
  1.28e+06 ++                     O                                         |
  1.26e+06 ++                                                               |
           |                                                                |
  1.24e+06 ++                                                               |
  1.22e+06 ++                         O          O       O                  |
   1.2e+06 ++                             O  O       O       O   O  O   O   O
           |                                                                |
  1.18e+06 ++                                                               |
  1.16e+06 ++                                                               |
           |                        ..*...                                  |
  1.14e+06 *+..      .*...*...*...*.      *..*                              |
  1.12e+06 ++--*---*--------------------------------------------------------+


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



--=-Fx9fB9WDX1spGCbvgdFq
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
commit: 11c842876e5f1ee90b0c47a299bbf4a521d6fbaf
model: Nehalem-EX
memory: 192G
perf-profile:
  freq: 800
will-it-scale:
  test:
  - pwrite1
testbox: lkp-nex05
tbox_group: lkp-nex05
kconfig: x86_64-rhel
enqueue_time: 2014-12-25 20:09:18.995924169 +08:00
head_commit: 11c842876e5f1ee90b0c47a299bbf4a521d6fbaf
base_commit: 97bf6af1f928216fd6c5a66e8a57bfa95a659672
branch: linux-devel/devel-hourly-2014122521
kernel: "/kernel/x86_64-rhel/11c842876e5f1ee90b0c47a299bbf4a521d6fbaf/vmlinuz-3.19.0-rc1-g11c8428"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-nex05/will-it-scale/performance-pwrite1/debian-x86_64.cgz/x86_64-rhel/11c842876e5f1ee90b0c47a299bbf4a521d6fbaf/0"
job_file: "/lkp/scheduled/lkp-nex05/cyclic_will-it-scale-performance-pwrite1-x86_64-rhel-HEAD-11c842876e5f1ee90b0c47a299bbf4a521d6fbaf-0.yaml"
dequeue_time: 2014-12-26 10:52:00.613014041 +08:00
job_state: finished
loadavg: 48.21 21.86 8.53 1/523 12076
start_time: '1419562399'
end_time: '1419562713'
version: "/lkp/lkp/.src-20141226-090912"

--=-Fx9fB9WDX1spGCbvgdFq
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
./runtest.py pwrite1 20 1 10 20 30 48 64

--=-Fx9fB9WDX1spGCbvgdFq
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-Fx9fB9WDX1spGCbvgdFq--

