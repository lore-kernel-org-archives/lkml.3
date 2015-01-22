Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbbAVCjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:39:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:49625 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbAVCjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:39:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,445,1418112000"; 
   d="yaml'?scan'208";a="654607970"
Message-ID: <1421894340.6126.55.camel@intel.com>
Subject: [LKP] [kernel] fc7f0dd3817: -2.1% will-it-scale.per_thread_ops
From: Huang Ying <ying.huang@intel.com>
To: Louis Langholtz <lou_langholtz@me.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Thu, 22 Jan 2015 10:39:00 +0800
Content-Type: multipart/mixed; boundary="=-q8F0sQ+gcZE3bYg9W0pX"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q8F0sQ+gcZE3bYg9W0pX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit fc7f0dd381720ea5ee5818645f7d0e9dece41cb0 ("kernel: avoid overflow in cmp_range")


testbox/testcase/testparams: lituya/will-it-scale/powersave-mmap2

7ad4b4ae5757b896  fc7f0dd381720ea5ee5818645f  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
    252693 ±  0%      -2.2%     247031 ±  0%  will-it-scale.per_thread_ops
      0.18 ±  0%      +1.8%       0.19 ±  0%  will-it-scale.scalability
     43536 ± 24%    +276.2%     163774 ± 33%  sched_debug.cpu#6.ttwu_local
      3.55 ±  2%     +36.2%       4.84 ±  2%  perf-profile.cpu-cycles.___might_sleep.unmap_page_range.unmap_single_vma.unmap_vmas.unmap_region
      8.49 ± 12%     -29.5%       5.99 ±  5%  perf-profile.cpu-cycles._raw_spin_lock_irqsave.__percpu_counter_add.do_munmap.vm_munmap.sys_munmap
     12.27 ±  8%     -20.2%       9.80 ±  3%  perf-profile.cpu-cycles.__percpu_counter_add.do_munmap.vm_munmap.sys_munmap.system_call_fastpath
      7.45 ±  7%     -20.8%       5.90 ±  5%  perf-profile.cpu-cycles._raw_spin_lock_irqsave.__percpu_counter_add.__vm_enough_memory.selinux_vm_enough_memory.security_vm_enough_memory_mm
     11.11 ±  3%     -12.9%       9.67 ±  3%  perf-profile.cpu-cycles.__percpu_counter_add.__vm_enough_memory.selinux_vm_enough_memory.security_vm_enough_memory_mm.mmap_region
      2.46 ±  3%     +13.1%       2.78 ±  2%  perf-profile.cpu-cycles.___might_sleep.unmap_single_vma.unmap_vmas.unmap_region.do_munmap
     11.42 ±  3%     -12.3%      10.01 ±  2%  perf-profile.cpu-cycles.__vm_enough_memory.selinux_vm_enough_memory.security_vm_enough_memory_mm.mmap_region.do_mmap_pgoff
     12.39 ±  3%     -11.2%      11.00 ±  2%  perf-profile.cpu-cycles.selinux_vm_enough_memory.security_vm_enough_memory_mm.mmap_region.do_mmap_pgoff.vm_mmap_pgoff
     12.45 ±  3%     -11.1%      11.07 ±  2%  perf-profile.cpu-cycles.security_vm_enough_memory_mm.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.sys_mmap_pgoff
     14.38 ±  1%      +9.5%      15.75 ±  1%  perf-profile.cpu-cycles.unmap_page_range.unmap_single_vma.unmap_vmas.unmap_region.do_munmap

testbox/testcase/testparams: lituya/will-it-scale/performance-mmap2

7ad4b4ae5757b896  fc7f0dd381720ea5ee5818645f  
----------------  --------------------------  
    268761 ±  0%      -2.1%     263177 ±  0%  will-it-scale.per_thread_ops
      0.18 ±  0%      +1.8%       0.19 ±  0%  will-it-scale.scalability
      0.01 ± 37%     -99.3%       0.00 ± 12%  sched_debug.rt_rq[10]:/.rt_time
    104123 ± 41%     -63.7%      37788 ± 45%  sched_debug.cpu#5.ttwu_local
    459901 ± 48%     +60.7%     739071 ± 31%  sched_debug.cpu#6.ttwu_count
   1858053 ± 12%     -36.9%    1171826 ± 38%  sched_debug.cpu#10.sched_goidle
   3716823 ± 12%     -36.9%    2344353 ± 38%  sched_debug.cpu#10.nr_switches
   3777468 ± 11%     -36.9%    2383575 ± 36%  sched_debug.cpu#10.sched_count
        36 ± 28%     -40.9%         21 ±  7%  sched_debug.cpu#6.cpu_load[1]
     18042 ± 17%     +54.0%      27789 ± 30%  sched_debug.cfs_rq[4]:/.exec_clock
        56 ± 17%     -48.8%         29 ±  5%  sched_debug.cfs_rq[6]:/.runnable_load_avg
        36 ± 29%     +43.6%         52 ± 11%  sched_debug.cpu#4.load
    594415 ±  4%     +82.4%    1084432 ± 18%  sched_debug.cpu#2.ttwu_count
        15 ±  0%     +51.1%         22 ± 14%  sched_debug.cpu#4.cpu_load[4]
      2077 ± 11%     -36.7%       1315 ± 15%  sched_debug.cpu#6.curr->pid
        11 ± 28%     +48.6%         17 ± 23%  sched_debug.cpu#7.cpu_load[4]
      0.00 ± 20%     +77.0%       0.00 ± 26%  sched_debug.rt_rq[5]:/.rt_time
        16 ±  5%     +52.1%         24 ±  9%  sched_debug.cpu#4.cpu_load[3]
        17 ± 11%     +50.0%         26 ±  8%  sched_debug.cpu#4.cpu_load[2]
     48035 ±  7%     -22.2%      37362 ± 24%  sched_debug.cfs_rq[12]:/.exec_clock
        34 ± 12%     -24.5%         25 ± 20%  sched_debug.cfs_rq[12]:/.runnable_load_avg
        33 ± 11%     -24.2%         25 ± 20%  sched_debug.cpu#12.cpu_load[4]
        19 ± 25%     +50.9%         28 ±  3%  sched_debug.cpu#4.cpu_load[1]
        66 ± 17%     -24.7%         49 ±  5%  sched_debug.cpu#6.load
    421462 ± 16%     +18.8%     500676 ± 13%  sched_debug.cfs_rq[1]:/.min_vruntime
      3.60 ±  0%     +35.4%       4.87 ±  0%  perf-profile.cpu-cycles.___might_sleep.unmap_page_range.unmap_single_vma.unmap_vmas.unmap_region
        44 ±  9%     +37.9%         60 ± 17%  sched_debug.cpu#3.load
        37 ±  6%     -17.9%         30 ± 15%  sched_debug.cpu#15.cpu_load[3]
      6.96 ±  4%     -10.4%       6.24 ±  3%  perf-profile.cpu-cycles._raw_spin_lock_irqsave.__percpu_counter_add.do_munmap.vm_munmap.sys_munmap
        36 ±  6%     +24.1%         44 ±  2%  sched_debug.cpu#2.load
        39 ±  7%     -16.9%         32 ± 12%  sched_debug.cpu#15.cpu_load[2]
   1528695 ±  6%     -19.5%    1230190 ± 16%  sched_debug.cpu#10.ttwu_count
        36 ±  6%     +27.3%         46 ±  9%  sched_debug.cpu#10.load
       447 ±  3%     -13.9%        385 ± 10%  sched_debug.cfs_rq[15]:/.tg_runnable_contrib
     20528 ±  3%     -13.8%      17701 ± 10%  sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
    634808 ±  6%     +50.3%     954347 ± 24%  sched_debug.cpu#2.sched_goidle
   1270648 ±  6%     +50.3%    1909528 ± 24%  sched_debug.cpu#2.nr_switches
   1284042 ±  6%     +51.4%    1944604 ± 23%  sched_debug.cpu#2.sched_count
        55 ± 11%     +28.7%         71 ±  4%  sched_debug.cpu#8.cpu_load[0]
      6.39 ±  0%      -8.7%       5.84 ±  2%  perf-profile.cpu-cycles._raw_spin_lock_irqsave.__percpu_counter_add.__vm_enough_memory.selinux_vm_enough_memory.security_vm_enough_memory_mm
     48721 ± 11%     +19.1%      58037 ±  5%  sched_debug.cpu#11.nr_load_updates
        53 ±  9%     +16.1%         62 ±  1%  sched_debug.cpu#8.cpu_load[1]
      1909 ±  0%     +22.2%       2333 ±  9%  sched_debug.cpu#3.curr->pid
      0.95 ±  4%      -8.4%       0.87 ±  4%  perf-profile.cpu-cycles.file_map_prot_check.selinux_mmap_file.security_mmap_file.vm_mmap_pgoff.sys_mmap_pgoff
    567608 ±  8%     +11.0%     629780 ±  4%  sched_debug.cfs_rq[14]:/.min_vruntime
    804637 ± 15%     +24.4%    1000664 ± 13%  sched_debug.cpu#3.ttwu_count
    684460 ±  5%      -9.6%     618867 ±  3%  sched_debug.cpu#14.avg_idle
      1.02 ±  4%      -7.2%       0.94 ±  4%  perf-profile.cpu-cycles.selinux_mmap_file.security_mmap_file.vm_mmap_pgoff.sys_mmap_pgoff.sys_mmap
      2605 ±  2%      -5.8%       2454 ±  5%  slabinfo.kmalloc-96.active_objs
      2605 ±  2%      -5.8%       2454 ±  5%  slabinfo.kmalloc-96.num_objs
        50 ±  4%     +11.3%         56 ±  1%  sched_debug.cfs_rq[8]:/.runnable_load_avg
      1.15 ±  4%      -6.4%       1.08 ±  4%  perf-profile.cpu-cycles.security_mmap_file.vm_mmap_pgoff.sys_mmap_pgoff.sys_mmap.system_call_fastpath
      1.07 ±  2%      +9.7%       1.17 ±  3%  perf-profile.cpu-cycles.vma_compute_subtree_gap.__vma_link_rb.vma_link.mmap_region.do_mmap_pgoff

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


--=-q8F0sQ+gcZE3bYg9W0pX
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
  nfsstat: 
  cpuidle: 
  cpufreq-stats: 
  turbostat: 
  pmeter: 
  sched_debug:
    interval: 10
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- powersave
commit: ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc
model: Grantley Haswell
nr_cpu: 16
memory: 16G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
perf-profile:
  freq: 800
will-it-scale:
  test:
  - mmap2
testbox: lituya
tbox_group: lituya
kconfig: x86_64-rhel
enqueue_time: 2015-01-18 14:10:07.541442957 +08:00
head_commit: b213d55915f2ee6748ba62f743b5e70564ab31e7
base_commit: ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc
branch: linux-devel/devel-hourly-2015011917
kernel: "/kernel/x86_64-rhel/ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc/vmlinuz-3.19.0-rc5-gec6f34e"
user: lkp
queue: cyclic
rootfs: debian-x86_64-2015-01-13.cgz
result_root: "/result/lituya/will-it-scale/powersave-mmap2/debian-x86_64-2015-01-13.cgz/x86_64-rhel/ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc/0"
job_file: "/lkp/scheduled/lituya/cyclic_will-it-scale-powersave-mmap2-x86_64-rhel-BASE-ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc-0.yaml"
dequeue_time: 2015-01-19 18:08:35.232473498 +08:00
job_state: finished
loadavg: 11.32 6.60 2.70 1/178 7099
start_time: '1421662149'
end_time: '1421662453'
version: "/lkp/lkp/.src-20150119-113749"

--=-q8F0sQ+gcZE3bYg9W0pX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

./runtest.py mmap2 32 1 8 12 16

--=-q8F0sQ+gcZE3bYg9W0pX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-q8F0sQ+gcZE3bYg9W0pX--

