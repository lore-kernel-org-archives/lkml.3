Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbbAUGQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:16:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:8897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbAUGQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:16:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,440,1418112000"; 
   d="yaml'?scan'208";a="654107759"
Message-ID: <1421820965.6126.23.camel@intel.com>
Subject: [LKP] [x86_64,entry] 71428f63e68: -35.9%
 will-it-scale.time.user_time +8.2% will-it-scale.per_process_ops
From: Huang Ying <ying.huang@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Wed, 21 Jan 2015 14:16:05 +0800
Content-Type: multipart/mixed; boundary="=-UN0c7SUpnsZNk6GXZQVb"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UN0c7SUpnsZNk6GXZQVb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/entry-devel
commit 71428f63e681e1b4aa1a781e3ef7c27f027d1103 ("x86_64,entry: Use sysret to return to userspace when possible")


testbox/testcase/testparams: wsm/will-it-scale/performance-unlink2

c9a418c3dc3993cb  71428f63e681e1b4aa1a781e3e  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     35.37 ±  0%     -39.9%      21.24 ±  0%  will-it-scale.time.user_time
    206954 ±  0%      +2.1%     211373 ±  0%  will-it-scale.per_process_ops
       992 ±  0%      +1.3%       1005 ±  0%  will-it-scale.time.system_time
     35.37 ±  0%     -39.9%      21.24 ±  0%  time.user_time
      8.51 ±  1%     -18.5%       6.93 ±  1%  perf-profile.cpu-cycles.close
    157780 ±  1%     +10.5%     174306 ±  2%  slabinfo.kmalloc-256.active_objs
    157803 ±  1%     +10.5%     174330 ±  2%  slabinfo.kmalloc-256.num_objs
      4930 ±  1%     +10.5%       5447 ±  2%  slabinfo.kmalloc-256.active_slabs
      4930 ±  1%     +10.5%       5447 ±  2%  slabinfo.kmalloc-256.num_slabs
    157357 ±  1%     +10.5%     173860 ±  2%  slabinfo.shmem_inode_cache.active_objs
    157370 ±  1%     +10.5%     173871 ±  2%  slabinfo.shmem_inode_cache.num_objs
      6556 ±  1%     +10.5%       7244 ±  2%  slabinfo.shmem_inode_cache.active_slabs
      6556 ±  1%     +10.5%       7244 ±  2%  slabinfo.shmem_inode_cache.num_slabs
     44396 ±  2%      +9.9%      48785 ±  2%  proc-vmstat.nr_slab_unreclaimable

testbox/testcase/testparams: wsm/will-it-scale/performance-signal1

c9a418c3dc3993cb  71428f63e681e1b4aa1a781e3e  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     35.20 ±  2%     -35.9%      22.56 ±  1%  will-it-scale.time.user_time
    365460 ±  1%      +7.3%     391965 ±  2%  will-it-scale.per_thread_ops
    971513 ±  0%      +8.2%    1050889 ±  0%  will-it-scale.per_process_ops
      0.59 ±  1%      -5.0%       0.56 ±  0%  will-it-scale.scalability
      1028 ±  0%      +1.2%       1040 ±  0%  will-it-scale.time.system_time
       640 ± 33%     -49.5%        323 ± 20%  sched_debug.cfs_rq[7]:/.blocked_load_avg
    127248 ± 37%     +85.3%     235849 ± 22%  sched_debug.cpu#1.ttwu_local
    129447 ± 36%     +84.0%     238199 ± 21%  sched_debug.cpu#1.ttwu_count
    129567 ± 36%     +83.6%     237839 ± 22%  sched_debug.cpu#1.sched_goidle
    259984 ± 36%     +83.4%     476883 ± 21%  sched_debug.cpu#1.nr_switches
    260083 ± 36%     +83.4%     476997 ± 21%  sched_debug.cpu#1.sched_count
       725 ± 28%     -44.9%        400 ± 17%  sched_debug.cfs_rq[7]:/.tg_load_contrib
     35.20 ±  2%     -35.9%      22.56 ±  1%  time.user_time
       112 ± 30%     -33.6%         74 ± 14%  sched_debug.cfs_rq[1]:/.load
       102 ± 19%     -26.9%         74 ± 14%  sched_debug.cpu#1.load
        62 ±  4%     +33.9%         84 ±  7%  sched_debug.cfs_rq[4]:/.runnable_load_avg
       109 ±  3%     -19.5%         87 ±  9%  sched_debug.cpu#6.cpu_load[3]
        52 ±  9%     +19.6%         62 ± 11%  sched_debug.cpu#10.cpu_load[2]
        64 ±  8%     +23.9%         80 ±  6%  sched_debug.cpu#4.cpu_load[0]
        61 ± 12%     +35.2%         82 ± 23%  sched_debug.cfs_rq[10]:/.load
       103 ±  3%     -17.1%         85 ±  6%  sched_debug.cpu#6.cpu_load[2]
      0.83 ±  3%     +16.9%       0.97 ±  8%  perf-profile.cpu-cycles._raw_spin_lock_irq.get_signal.do_signal.do_notify_resume.int_signal
      0.89 ±  3%     +21.3%       1.08 ±  2%  perf-profile.cpu-cycles.setup_sigcontext.do_signal.do_notify_resume.int_signal.raise
       114 ±  4%     -19.0%         92 ± 11%  sched_debug.cpu#6.cpu_load[4]
      1861 ±  6%     -16.2%       1560 ±  8%  cpuidle.C3-NHM.usage
       410 ±  6%     -16.3%        343 ±  9%  cpuidle.C1-NHM.usage
      3.18 ±  2%     +13.8%       3.62 ±  3%  perf-profile.cpu-cycles.init_fpu.__restore_xstate_sig.restore_sigcontext.sys_rt_sigreturn.stub_rt_sigreturn
      7.29 ±  1%     +15.6%       8.43 ±  4%  perf-profile.cpu-cycles.__sigqueue_free.part.12.__dequeue_signal.dequeue_signal.get_signal.do_signal
      0.92 ±  3%     +11.7%       1.03 ±  4%  perf-profile.cpu-cycles.system_call.handler
      3469 ±  2%     -18.2%       2838 ± 15%  sched_debug.cpu#1.curr->pid
      2.37 ±  1%     +13.1%       2.67 ±  4%  perf-profile.cpu-cycles.free_uid.__sigqueue_free.__dequeue_signal.dequeue_signal.get_signal
     13.43 ±  2%     +13.4%      15.23 ±  3%  perf-profile.cpu-cycles.get_signal.do_signal.do_notify_resume.int_signal.raise
     12.93 ±  3%     +12.8%      14.58 ±  4%  perf-profile.cpu-cycles.__send_signal.send_signal.do_send_sig_info.do_send_specific.do_tkill
      2.67 ±  1%     +12.7%       3.01 ±  4%  perf-profile.cpu-cycles.memset.init_fpu.__restore_xstate_sig.restore_sigcontext.sys_rt_sigreturn
     10.12 ±  2%     +11.9%      11.33 ±  3%  perf-profile.cpu-cycles.stub_rt_sigreturn.raise
     13.75 ±  3%     +12.6%      15.49 ±  4%  perf-profile.cpu-cycles.send_signal.do_send_sig_info.do_send_specific.do_tkill.sys_tgkill
     23.31 ±  2%     +12.3%      26.18 ±  3%  perf-profile.cpu-cycles.do_notify_resume.int_signal.raise
      1.04 ±  5%     +14.4%       1.19 ±  5%  perf-profile.cpu-cycles.__lock_task_sighand.do_send_sig_info.do_send_specific.do_tkill.sys_tgkill
     23.37 ±  2%     +12.3%      26.25 ±  3%  perf-profile.cpu-cycles.int_signal.raise
     22.76 ±  2%     +12.2%      25.55 ±  3%  perf-profile.cpu-cycles.do_signal.do_notify_resume.int_signal.raise
     20.06 ±  3%     +11.9%      22.45 ±  4%  perf-profile.cpu-cycles.do_send_specific.do_tkill.sys_tgkill.system_call_fastpath.raise
      0.81 ±  7%     +17.6%       0.95 ±  5%  perf-profile.cpu-cycles._raw_spin_unlock_irqrestore.try_to_wake_up.wake_up_state.signal_wake_up_state.complete_signal
     16.43 ±  3%     +12.1%      18.41 ±  4%  perf-profile.cpu-cycles.do_send_sig_info.do_send_specific.do_tkill.sys_tgkill.system_call_fastpath
      9.83 ±  2%     +11.6%      10.97 ±  3%  perf-profile.cpu-cycles.sys_rt_sigreturn.stub_rt_sigreturn.raise
      3.44 ±  4%     +14.2%       3.93 ±  4%  perf-profile.cpu-cycles.signal_wake_up_state.complete_signal.__send_signal.send_signal.do_send_sig_info
        96 ±  3%     -12.7%         84 ±  3%  sched_debug.cpu#6.cpu_load[1]
      8.99 ±  2%     +13.6%      10.21 ±  3%  perf-profile.cpu-cycles.__dequeue_signal.dequeue_signal.get_signal.do_signal.do_notify_resume
     10.33 ±  2%     +13.0%      11.66 ±  4%  perf-profile.cpu-cycles.dequeue_signal.get_signal.do_signal.do_notify_resume.int_signal
     22.68 ±  3%     +11.7%      25.33 ±  3%  perf-profile.cpu-cycles.sys_tgkill.system_call_fastpath.raise
      8.64 ±  2%     +11.7%       9.66 ±  3%  perf-profile.cpu-cycles.restore_sigcontext.sys_rt_sigreturn.stub_rt_sigreturn.raise
     22.37 ±  3%     +11.6%      24.96 ±  3%  perf-profile.cpu-cycles.do_tkill.sys_tgkill.system_call_fastpath.raise
     22.87 ±  3%     +11.7%      25.53 ±  3%  perf-profile.cpu-cycles.system_call_fastpath.raise
      8.12 ±  2%     +11.9%       9.08 ±  3%  perf-profile.cpu-cycles.__restore_xstate_sig.restore_sigcontext.sys_rt_sigreturn.stub_rt_sigreturn.raise
      4.11 ±  4%     +12.3%       4.61 ±  4%  perf-profile.cpu-cycles.complete_signal.__send_signal.send_signal.do_send_sig_info.do_send_specific
      1.17 ±  5%     +10.7%       1.30 ±  4%  perf-profile.cpu-cycles.selinux_task_kill.security_task_kill.check_kill_permission.do_send_specific.do_tkill
      5.84 ±  4%     +13.6%       6.63 ±  5%  perf-profile.cpu-cycles.__sigqueue_alloc.__send_signal.send_signal.do_send_sig_info.do_send_specific
      1.32 ±  5%     +11.4%       1.47 ±  4%  perf-profile.cpu-cycles.security_task_kill.check_kill_permission.do_send_specific.do_tkill.sys_tgkill

wsm: Westmere
Memory: 6G




                          will-it-scale.time.user_time

  40 ++---------------------------------------------------------------------+
     *..*..*...*..*..*..*...*..*..*      *..*..  .*..  ..*..                |
  35 ++                           :      :     *.    *.     *..*..*...*     |
  30 ++                           :     :                                   |
     |                             :    :                                   |
  25 ++                            :    :                                   |
     O  O  O   O  O         O  O  O:   :                                    O
  20 ++              O  O          : O : O  O  O  O  O   O  O  O  O   O  O  |
     |                              :  :                                    |
  15 ++                             :  :                                    |
  10 ++                             : :                                     |
     |                              : :                                     |
   5 ++                              ::                                     |
     |                               :                                      |
   0 ++------------------------------*--------------------------------------+


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


--=-UN0c7SUpnsZNk6GXZQVb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: will-it-scale
default-monitors:
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
commit: b84235367120b60c3392e774e9725a3fe6a7464d
model: Westmere
memory: 6G
nr_hdd_partitions: 1
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
netconsole_port: 6667
perf-profile:
  freq: 800
will-it-scale:
  test:
  - unlink2
testbox: wsm
tbox_group: wsm
kconfig: x86_64-rhel
enqueue_time: 2015-01-17 05:37:46.268783133 +08:00
head_commit: b84235367120b60c3392e774e9725a3fe6a7464d
base_commit: eaa27f34e91a14cdceed26ed6c6793ec1d186115
branch: linux-devel/devel-hourly-2015011718
kernel: "/kernel/x86_64-rhel/b84235367120b60c3392e774e9725a3fe6a7464d/vmlinuz-3.19.0-rc4-gb842353"
user: lkp
queue: cyclic
rootfs: debian-x86_64-2015-01-13.cgz
result_root: "/result/wsm/will-it-scale/performance-unlink2/debian-x86_64-2015-01-13.cgz/x86_64-rhel/b84235367120b60c3392e774e9725a3fe6a7464d/0"
job_file: "/lkp/scheduled/wsm/cyclic_will-it-scale-performance-unlink2-x86_64-rhel-HEAD-b84235367120b60c3392e774e9725a3fe6a7464d-0.yaml"
dequeue_time: 2015-01-17 21:15:38.970763422 +08:00
nr_cpu: "$(nproc)"
job_state: finished
loadavg: 8.46 4.91 2.02 1/146 6699
start_time: '1421500574'
end_time: '1421500878'
version: "/lkp/lkp/.src-20150116-113525"

--=-UN0c7SUpnsZNk6GXZQVb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

./runtest.py unlink2 32 1 6 9 12

--=-UN0c7SUpnsZNk6GXZQVb
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-UN0c7SUpnsZNk6GXZQVb--

