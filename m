Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbbAHC1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:27:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:50727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbbAHC1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:27:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="yaml'?scan'208";a="509086049"
Message-ID: <1420684064.6201.86.camel@linux.intel.com>
Subject: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
From: Huang Ying <ying.huang@linux.intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Thu, 08 Jan 2015 10:27:44 +0800
Content-Type: multipart/mixed; boundary="=-qx4GqOMEEGEvpm1fVi4Z"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qx4GqOMEEGEvpm1fVi4Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit c8c06efa8b552608493b7066c234cfa82c47fcea ("mm: convert i_mmap_mutex to rwsem")


testbox/testcase/testparams: lituya/unixbench/performance-execl

83cde9e8ba95d180  c8c06efa8b552608493b7066c2  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
    721721 ±  1%    +303.6%    2913110 ±  3%  unixbench.time.voluntary_context_switches
     11767 ±  0%      -7.6%      10867 ±  1%  unixbench.score
 2.323e+08 ±  0%      -7.2%  2.157e+08 ±  1%  unixbench.time.minor_page_faults
       207 ±  0%      -7.0%        192 ±  1%  unixbench.time.user_time
   4923450 ±  0%      -5.7%    4641672 ±  0%  unixbench.time.involuntary_context_switches
       584 ±  0%      -5.2%        554 ±  0%  unixbench.time.percent_of_cpu_this_job_got
       948 ±  0%      -4.9%        902 ±  0%  unixbench.time.system_time
         0 ±  0%      +Inf%     672942 ±  2%  latency_stats.hits.call_rwsem_down_write_failed.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
         0 ±  0%      +Inf%     703126 ±  6%  latency_stats.hits.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%     317363 ±  7%  latency_stats.hits.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%     173298 ±  8%  latency_stats.hits.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%      50444 ±  1%  latency_stats.hits.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%     104157 ±  0%  latency_stats.hits.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%      51342 ±  1%  latency_stats.hits.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%       1474 ±  7%  latency_stats.hits.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.SyS_munmap.system_call_fastpath
         0 ±  0%      +Inf%     311514 ±  8%  latency_stats.hits.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%        194 ± 10%  latency_stats.hits.call_rwsem_down_write_failed.copy_process.do_fork.SyS_clone.stub_clone
     40292 ±  2%    -100.0%          0 ±  0%  latency_stats.hits.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
     19886 ±  3%    -100.0%          0 ±  0%  latency_stats.hits.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
     18370 ±  3%    -100.0%          0 ±  0%  latency_stats.hits.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
      5863 ±  5%    -100.0%          0 ±  0%  latency_stats.hits.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
      9374 ±  4%    -100.0%          0 ±  0%  latency_stats.hits.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
     39987 ±  2%    -100.0%          0 ±  0%  latency_stats.hits.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
     11332 ±  3%    -100.0%          0 ±  0%  latency_stats.hits.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
      5540 ±  6%    -100.0%          0 ±  0%  latency_stats.hits.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         9 ± 39%    -100.0%          0 ±  0%  latency_stats.hits.copy_process.do_fork.SyS_clone.stub_clone
       490 ±  5%    +301.2%       1967 ± 12%  sched_debug.cpu#10.nr_uninterruptible
       498 ±  4%    +297.0%       1978 ± 10%  sched_debug.cpu#13.nr_uninterruptible
       528 ± 11%    +284.4%       2032 ±  9%  sched_debug.cpu#8.nr_uninterruptible
       510 ±  5%    +278.0%       1930 ±  8%  sched_debug.cpu#12.nr_uninterruptible
       502 ±  3%    +279.9%       1910 ±  8%  sched_debug.cpu#15.nr_uninterruptible
       488 ±  4%    +297.4%       1942 ±  7%  sched_debug.cpu#11.nr_uninterruptible
        61 ± 17%     -51.0%         30 ± 42%  sched_debug.cpu#4.cpu_load[0]
       537 ± 14%    +267.6%       1977 ±  8%  sched_debug.cpu#9.nr_uninterruptible
       549 ± 14%    +256.2%       1958 ± 11%  sched_debug.cpu#14.nr_uninterruptible
    721721 ±  1%    +303.6%    2913110 ±  3%  time.voluntary_context_switches
        32 ± 23%     +41.4%         45 ± 15%  sched_debug.cpu#0.cpu_load[1]
    138118 ± 15%     +22.8%     169551 ± 10%  sched_debug.cpu#7.sched_goidle
    110150 ± 13%     +35.9%     149694 ± 10%  sched_debug.cpu#11.sched_goidle
    125451 ± 12%     +34.5%     168781 ±  9%  sched_debug.cpu#11.ttwu_count
        30 ± 15%     +29.3%         39 ± 15%  sched_debug.cpu#12.cpu_load[3]
    126828 ±  3%     +29.1%     163741 ±  4%  sched_debug.cpu#6.sched_goidle
    160802 ± 12%     +21.5%     195384 ±  8%  sched_debug.cpu#7.ttwu_count
    123454 ±  4%     +30.5%     161069 ±  4%  sched_debug.cpu#14.ttwu_count
    148649 ±  2%     +32.6%     197144 ±  4%  sched_debug.cpu#2.ttwu_count
    114238 ±  6%     +31.1%     149740 ±  6%  sched_debug.cpu#8.sched_goidle
    128654 ±  5%     +27.1%     163499 ±  7%  sched_debug.cpu#15.ttwu_count
        38 ±  7%     -16.1%         32 ±  6%  sched_debug.cpu#2.cpu_load[3]
    378291 ± 11%     +16.3%     440023 ±  7%  sched_debug.cpu#7.sched_count
    378057 ± 11%     +16.0%     438383 ±  7%  sched_debug.cpu#7.nr_switches
    159246 ±  6%     +20.6%     192115 ±  7%  sched_debug.cpu#4.ttwu_count
        39 ± 11%     -17.6%         32 ± 10%  sched_debug.cpu#4.cpu_load[3]
    355445 ±  2%     +20.5%     428445 ±  3%  sched_debug.cpu#6.sched_count
    321621 ±  9%     +23.6%     397380 ±  7%  sched_debug.cpu#11.sched_count
    355193 ±  2%     +20.1%     426758 ±  3%  sched_debug.cpu#6.nr_switches
    321376 ±  9%     +23.2%     396022 ±  7%  sched_debug.cpu#11.nr_switches
    152398 ±  3%     +28.3%     195489 ± 10%  sched_debug.cpu#3.ttwu_count
    125919 ±  3%     +34.8%     169795 ±  4%  sched_debug.cpu#2.sched_goidle
    330747 ±  4%     +20.2%     397424 ±  4%  sched_debug.cpu#8.sched_count
        36 ±  5%     -13.1%         31 ±  6%  sched_debug.cpu#2.cpu_load[4]
    330460 ±  4%     +19.9%     396085 ±  4%  sched_debug.cpu#8.nr_switches
        31 ± 11%     +14.4%         35 ±  6%  sched_debug.cpu#8.cpu_load[3]
    159635 ±  4%     +20.6%     192490 ± 10%  sched_debug.cpu#1.ttwu_count
    155809 ±  5%     +16.3%     181259 ±  5%  sched_debug.cpu#5.ttwu_count
    133028 ±  6%     +17.2%     155920 ±  5%  sched_debug.cpu#5.sched_goidle
    354261 ±  2%     +24.5%     440990 ±  3%  sched_debug.cpu#2.sched_count
      1399 ± 16%     +24.6%       1744 ±  4%  sched_debug.cpu#12.curr->pid
    354028 ±  2%     +24.1%     439371 ±  3%  sched_debug.cpu#2.nr_switches
    165045 ±  9%     +14.2%     188419 ±  3%  sched_debug.cpu#0.ttwu_count
    129864 ±  4%     +30.1%     168934 ± 12%  sched_debug.cpu#3.sched_goidle
    361169 ±  2%     +21.1%     437280 ±  9%  sched_debug.cpu#3.nr_switches
    361390 ±  2%     +21.4%     438886 ±  9%  sched_debug.cpu#3.sched_count
    113836 ±  5%     +26.8%     144302 ±  8%  sched_debug.cpu#15.sched_goidle
    223075 ±  4%     +34.9%     300833 ±  8%  cpuidle.C3-HSW.usage
    109472 ±  5%     +29.5%     141802 ±  4%  sched_debug.cpu#14.sched_goidle
    320251 ±  3%     +19.3%     382084 ±  3%  sched_debug.cpu#14.sched_count
    328264 ±  4%     +17.5%     385651 ±  6%  sched_debug.cpu#15.nr_switches
    319985 ±  3%     +19.0%     380734 ±  3%  sched_debug.cpu#14.nr_switches
        32 ± 16%     +41.9%         45 ± 20%  sched_debug.cpu#12.cpu_load[2]
        37 ±  6%     -12.8%         32 ±  6%  sched_debug.cpu#1.cpu_load[4]
    328504 ±  4%     +17.8%     386960 ±  6%  sched_debug.cpu#15.sched_count
        37 ± 35%     +83.2%         68 ± 20%  sched_debug.cpu#12.cpu_load[0]
    129752 ±  6%     +30.6%     169483 ±  6%  sched_debug.cpu#8.ttwu_count
    282972 ±  0%     -15.8%     238308 ±  1%  sched_debug.cfs_rq[9]:/.min_vruntime
    284112 ±  0%     -16.0%     238794 ±  1%  sched_debug.cfs_rq[11]:/.min_vruntime
    282666 ±  0%     -16.2%     236884 ±  1%  sched_debug.cfs_rq[10]:/.min_vruntime
    285118 ±  0%     -15.3%     241361 ±  1%  sched_debug.cfs_rq[2]:/.min_vruntime
    285813 ±  0%     -15.5%     241598 ±  1%  sched_debug.cfs_rq[1]:/.min_vruntime
    286458 ±  1%     -15.5%     242012 ±  1%  sched_debug.cfs_rq[0]:/.min_vruntime
       891 ± 33%     +71.6%       1530 ±  9%  sched_debug.cpu#15.curr->pid
    283618 ±  0%     -15.9%     238477 ±  1%  sched_debug.cfs_rq[14]:/.min_vruntime
    286794 ±  0%     -15.4%     242695 ±  1%  sched_debug.cfs_rq[3]:/.min_vruntime
    282507 ±  0%     -15.9%     237672 ±  1%  sched_debug.cfs_rq[15]:/.min_vruntime
    283428 ±  0%     -16.2%     237542 ±  1%  sched_debug.cfs_rq[12]:/.min_vruntime
    284953 ±  0%     -16.6%     237517 ±  1%  sched_debug.cfs_rq[13]:/.min_vruntime
   1270469 ±  1%     +24.5%    1581318 ±  3%  cpuidle.C6-HSW.usage
    282363 ±  1%     -16.2%     236514 ±  1%  sched_debug.cfs_rq[8]:/.min_vruntime
    286105 ±  0%     -15.9%     240483 ±  1%  sched_debug.cfs_rq[4]:/.min_vruntime
    136240 ±  7%     +21.8%     165966 ±  8%  sched_debug.cpu#4.sched_goidle
    137467 ±  5%     +21.6%     167200 ± 12%  sched_debug.cpu#1.sched_goidle
    285463 ±  0%     -15.6%     241015 ±  1%  sched_debug.cfs_rq[5]:/.min_vruntime
    287745 ±  0%     -15.6%     242855 ±  2%  sched_debug.cfs_rq[7]:/.min_vruntime
    148602 ±  3%     +27.3%     189130 ±  3%  sched_debug.cpu#6.ttwu_count
    377362 ±  4%     +15.4%     435571 ±  9%  sched_debug.cpu#1.sched_count
    284598 ±  0%     -15.2%     241230 ±  1%  sched_debug.cfs_rq[6]:/.min_vruntime
    377157 ±  4%     +15.1%     433927 ±  9%  sched_debug.cpu#1.nr_switches
    374585 ±  5%     +15.0%     430900 ±  6%  sched_debug.cpu#4.nr_switches
    374823 ±  5%     +15.4%     432576 ±  6%  sched_debug.cpu#4.sched_count
   2069241 ±  0%     +75.3%    3628295 ±  0%  cpuidle.C1-HSW.usage
        41 ± 47%    +122.3%         92 ± 31%  sched_debug.cfs_rq[3]:/.load
 1.475e+08 ±  2%     +46.1%  2.155e+08 ±  1%  cpuidle.C1-HSW.time
      2000 ± 27%     -36.0%       1279 ± 17%  sched_debug.cpu#4.curr->pid
        91 ± 23%     -51.1%         44 ± 26%  sched_debug.cpu#4.load
  20440136 ±  3%     +13.5%   23206516 ± 10%  cpuidle.C3-HSW.time
        42 ± 46%     +82.8%         77 ± 20%  sched_debug.cpu#3.load
    334868 ±  0%     -40.1%     200692 ±  5%  latency_stats.hits.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault.clear_user.padzero.load_elf_binary
    195507 ±  0%     -40.0%     117305 ±  8%  latency_stats.hits.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
       541 ±  1%     +24.4%        672 ±  1%  cpuidle.POLL.usage
    124903 ±  8%     -22.8%      96485 ±  7%  sched_debug.cpu#10.ttwu_local
       840 ±  5%     -26.7%        616 ±  4%  latency_stats.hits.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
    127712 ± 11%     -10.3%     114520 ±  6%  sched_debug.cpu#9.ttwu_local
    620351 ±  3%     -14.2%     532554 ±  5%  sched_debug.cpu#3.avg_idle
    607039 ±  4%     -12.6%     530814 ±  3%  sched_debug.cpu#6.avg_idle
    669680 ±  2%     -11.6%     591883 ±  5%  sched_debug.cpu#15.avg_idle
      9349 ±  1%      +9.2%      10211 ±  3%  slabinfo.vm_area_struct.active_objs
      9411 ±  1%      +8.7%      10227 ±  3%  slabinfo.vm_area_struct.num_objs
         0 ±  0%      +Inf%         51 ±  9%  latency_stats.avg.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
       932 ± 10%    -100.0%          0 ±  0%  latency_stats.max.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
    146109 ±  5%    -100.0%          0 ±  0%  latency_stats.sum.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
    341728 ±  1%    -100.0%          0 ±  0%  latency_stats.sum.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%      10487 ± 13%  latency_stats.sum.call_rwsem_down_write_failed.copy_process.do_fork.SyS_clone.stub_clone
         0 ±  0%      +Inf%         54 ± 19%  latency_stats.avg.call_rwsem_down_write_failed.copy_process.do_fork.SyS_clone.stub_clone
         7 ±  6%    -100.0%          0 ±  0%  latency_stats.avg.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%        573 ± 10%  latency_stats.max.call_rwsem_down_write_failed.copy_process.do_fork.SyS_clone.stub_clone
         2 ± 15%    -100.0%          0 ±  0%  latency_stats.max.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.SyS_munmap.system_call_fastpath
         8 ±  0%    -100.0%          0 ±  0%  latency_stats.avg.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%          1 ± 33%  latency_stats.avg.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.SyS_munmap.system_call_fastpath
         1 ± 24%    -100.0%          0 ±  0%  latency_stats.avg.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.SyS_munmap.system_call_fastpath
         0 ±  0%      +Inf%       3059 ± 20%  latency_stats.sum.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.SyS_munmap.system_call_fastpath
         0 ±  0%      +Inf%       2178 ± 11%  latency_stats.max.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%         14 ±  3%  latency_stats.avg.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
       878 ± 10%    -100.0%          0 ±  0%  latency_stats.max.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%       1915 ±  8%  latency_stats.max.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%         12 ±  5%  latency_stats.avg.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%    1327137 ±  5%  latency_stats.sum.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
       518 ± 11%    -100.0%          0 ±  0%  latency_stats.max.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%       1944 ± 16%  latency_stats.max.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%         10 ±  8%  latency_stats.avg.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%     548178 ±  5%  latency_stats.sum.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%       2247 ± 10%  latency_stats.max.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         2 ±  0%    -100.0%          0 ±  0%  latency_stats.avg.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%         61 ±  5%  latency_stats.avg.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%   10731426 ± 14%  latency_stats.sum.call_rwsem_down_write_failed.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
     13994 ±  7%    -100.0%          0 ±  0%  latency_stats.sum.vma_adjust.__split_vma.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
       966 ±  8%    -100.0%          0 ±  0%  latency_stats.max.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
       867 ± 19%    -100.0%          0 ±  0%  latency_stats.max.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%       2175 ±  4%  latency_stats.max.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%         62 ±  5%  latency_stats.avg.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%   19888298 ± 13%  latency_stats.sum.call_rwsem_down_write_failed.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
     15115 ±  6%    -100.0%          0 ±  0%  latency_stats.sum.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         2 ±  0%    -100.0%          0 ±  0%  latency_stats.avg.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
       536 ± 16%    -100.0%          0 ±  0%  latency_stats.max.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
    118730 ±  3%    -100.0%          0 ±  0%  latency_stats.sum.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%       2269 ±  2%  latency_stats.max.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%     771346 ±  3%  latency_stats.sum.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.vm_munmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%   37036112 ± 15%  latency_stats.sum.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.exit_mmap.mmput.flush_old_exec.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%       2316 ±  5%  latency_stats.max.call_rwsem_down_write_failed.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
         0 ±  0%      +Inf%         54 ± 10%  latency_stats.avg.call_rwsem_down_write_failed.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
         0 ±  0%      +Inf%   36764596 ± 13%  latency_stats.sum.call_rwsem_down_write_failed.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
         5 ±  0%    -100.0%          0 ±  0%  latency_stats.avg.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
     36701 ±  2%    -100.0%          0 ±  0%  latency_stats.sum.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
     63412 ±  3%    -100.0%          0 ±  0%  latency_stats.sum.vma_adjust.__split_vma.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%         60 ±  5%  latency_stats.avg.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         0 ±  0%      +Inf%   19176722 ± 14%  latency_stats.sum.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
         5 ±  9%    -100.0%          0 ±  0%  latency_stats.avg.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
       929 ± 15%    -100.0%          0 ±  0%  latency_stats.max.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
         6 ±  6%    -100.0%          0 ±  0%  latency_stats.avg.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
    283534 ±  1%    -100.0%          0 ±  0%  latency_stats.sum.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
       676 ±  6%    -100.0%          0 ±  0%  latency_stats.max.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         3 ± 11%    -100.0%          0 ±  0%  latency_stats.avg.vma_link.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.vm_mmap.load_elf_binary.search_binary_handler.do_execve_common.SyS_execve.stub_execve
         0 ±  0%      +Inf%       2156 ±  4%  latency_stats.max.call_rwsem_down_write_failed.unlink_file_vma.free_pgtables.unmap_region.do_munmap.mmap_region.do_mmap_pgoff.vm_mmap_pgoff.SyS_mmap_pgoff.SyS_mmap.system_call_fastpath
     38.04 ±  0%      -5.4%      35.98 ±  0%  turbostat.%c0
        26 ± 31%     -50.5%         13 ±  3%  latency_stats.avg.kthread_stop.smpboot_destroy_threads.smpboot_unregister_percpu_thread.proc_dowatchdog.proc_sys_call_handler.proc_sys_write.vfs_write.SyS_write.system_call_fastpath
       168 ± 30%     -43.3%         95 ±  0%  latency_stats.max.kthread_stop.smpboot_destroy_threads.smpboot_unregister_percpu_thread.proc_dowatchdog.proc_sys_call_handler.proc_sys_write.vfs_write.SyS_write.system_call_fastpath
       408 ± 32%     -48.9%        208 ±  2%  latency_stats.sum.kthread_stop.smpboot_destroy_threads.smpboot_unregister_percpu_thread.proc_dowatchdog.proc_sys_call_handler.proc_sys_write.vfs_write.SyS_write.system_call_fastpath
         2 ±  0%     -50.0%          1 ±  0%  latency_stats.avg.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
    567580 ±  0%     -49.5%     286885 ±  5%  latency_stats.sum.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault.clear_user.padzero.load_elf_binary
     85194 ±  0%     +20.5%     102669 ±  0%  vmstat.system.cs
    336221 ±  1%     -46.7%     179256 ±  9%  latency_stats.sum.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
      1729 ±  6%     -36.7%       1094 ±  3%  latency_stats.sum.wait_on_page_bit_killable.__lock_page_or_retry.filemap_fault.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
        20 ±  4%     -34.1%         13 ± 23%  latency_stats.max.stop_one_cpu.sched_exec.do_execve_common.SyS_execve.stub_execve
     71302 ± 11%     -25.9%      52817 ±  7%  latency_stats.sum.path_lookupat.filename_lookup.user_path_at_empty.user_path_at.SyS_access.system_call_fastpath
     57.77 ±  0%      -1.2%      57.06 ±  0%  turbostat.Pkg_W
       206 ±  6%     +19.0%        245 ±  6%  latency_stats.sum.sync_inodes_sb.sync_inodes_one_sb.iterate_supers.sys_sync.system_call_fastpath
      1756 ±  5%     +10.5%       1940 ±  5%  latency_stats.max.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.vfs_open.do_last.path_openat.do_filp_open.do_sys_open.SyS_open.system_call_fastpath
      2148 ±  4%      -6.4%       2010 ±  5%  latency_stats.avg.wait_woken.inotify_read.vfs_read.SyS_read.system_call_fastpath
     10744 ±  4%      -6.5%      10050 ±  5%  latency_stats.sum.wait_woken.inotify_read.vfs_read.SyS_read.system_call_fastpath
       109 ±  1%      +8.0%        117 ±  2%  latency_stats.avg.do_wait.SyS_wait4.system_call_fastpath
       403 ±  3%      -7.4%        373 ±  3%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_setattr.nfs3_proc_create.nfs_create.vfs_create.do_last.path_openat
    137032 ±  1%      +6.5%     145948 ±  2%  latency_stats.sum.do_wait.SyS_wait4.system_call_fastpath
       141 ±  0%      +6.6%        150 ±  2%  latency_stats.avg.pipe_wait.pipe_read.new_sync_read.vfs_read.SyS_read.system_call_fastpath
      4898 ±  2%      -6.0%       4604 ±  4%  latency_stats.max.wait_woken.n_tty_read.tty_read.vfs_read.SyS_read.system_call_fastpath
      5797 ±  2%      -7.0%       5393 ±  1%  latency_stats.sum.stop_one_cpu.sched_exec.do_execve_common.SyS_execve.stub_execve
      4650 ±  0%      -3.3%       4497 ±  1%  latency_stats.max.wait_woken.inotify_read.vfs_read.SyS_read.system_call_fastpath


testbox/testcase/testparams: ivb43/vm-scalability/performance-300s-mmap-xread-seq-mt

83cde9e8ba95d180  c8c06efa8b552608493b7066c2  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
        17 ± 48%     -80.0%          3 ± 14%  sched_debug.cpu#35.cpu_load[2]
      1.20 ± 30%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.mutex_optimistic_spin.__mutex_lock_slowpath
      1.34 ± 30%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.smp_call_function_interrupt.call_function_interrupt.mutex_optimistic_spin.__mutex_lock_slowpath.mutex_lock
    441348 ± 47%     -76.0%     105848 ± 15%  sched_debug.cpu#29.nr_switches
    441662 ± 47%     -75.8%     107048 ± 14%  sched_debug.cpu#29.sched_count
    219946 ± 47%     -76.1%      52633 ± 15%  sched_debug.cpu#29.sched_goidle
      0.99 ± 13%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.__mutex_unlock_slowpath.mutex_unlock.rmap_walk.try_to_unmap.shrink_page_list
      0.99 ± 13%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.mutex_unlock.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      1.89 ± 30%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.call_function_interrupt.mutex_optimistic_spin.__mutex_lock_slowpath.mutex_lock.rmap_walk
     27.22 ± 38%     -79.5%       5.59 ±  1%  perf-profile.cpu-cycles.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone
     27.14 ± 39%     -79.6%       5.53 ±  1%  perf-profile.cpu-cycles.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec
      5.75 ± 49%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.mutex_optimistic_spin.__mutex_lock_slowpath.mutex_lock.rmap_walk.try_to_unmap
      5.87 ± 48%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.__mutex_lock_slowpath.mutex_lock.rmap_walk.try_to_unmap.shrink_page_list
      5.91 ± 47%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.mutex_lock.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      0.00 ±  0%      +Inf%       4.16 ±  2%  perf-profile.cpu-cycles.call_rwsem_down_write_failed.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list
      0.00 ±  0%      +Inf%       4.15 ±  2%  perf-profile.cpu-cycles.rwsem_down_write_failed.call_rwsem_down_write_failed.rmap_walk.page_referenced.shrink_page_list
      4.94 ±  4%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.mutex_spin_on_owner.mutex_optimistic_spin.__mutex_lock_slowpath.mutex_lock.rmap_walk
      0.00 ±  0%      +Inf%       3.18 ±  2%  perf-profile.cpu-cycles.rwsem_spin_on_owner.rwsem_down_write_failed.call_rwsem_down_write_failed.rmap_walk.page_referenced
     26.20 ± 40%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.mutex_optimistic_spin.__mutex_lock_slowpath.mutex_lock.rmap_walk.page_referenced
     26.80 ± 39%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.__mutex_lock_slowpath.mutex_lock.rmap_walk.page_referenced.shrink_page_list
     26.88 ± 39%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.mutex_lock.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list
      0.00 ±  0%      +Inf%       1.49 ±  0%  perf-profile.cpu-cycles.call_rwsem_wake.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      0.00 ±  0%      +Inf%       1.49 ±  0%  perf-profile.cpu-cycles.rwsem_wake.call_rwsem_wake.rmap_walk.try_to_unmap.shrink_page_list
      0.00 ±  0%      +Inf%       1.39 ±  1%  perf-profile.cpu-cycles.wake_up_process.__rwsem_do_wake.rwsem_wake.call_rwsem_wake.rmap_walk
      0.00 ±  0%      +Inf%       1.28 ±  0%  perf-profile.cpu-cycles.__rwsem_do_wake.rwsem_wake.call_rwsem_wake.rmap_walk.try_to_unmap
      0.00 ±  0%      +Inf%       1.22 ±  0%  perf-profile.cpu-cycles.try_to_wake_up.wake_up_process.__rwsem_do_wake.rwsem_wake.call_rwsem_wake
      0.00 ±  0%      +Inf%       1.17 ±  2%  perf-profile.cpu-cycles.call_rwsem_down_write_failed.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      0.00 ±  0%      +Inf%       1.16 ±  2%  perf-profile.cpu-cycles.rwsem_down_write_failed.call_rwsem_down_write_failed.rmap_walk.try_to_unmap.shrink_page_list
      0.00 ±  0%      +Inf%       1.03 ±  1%  perf-profile.cpu-cycles.call_rwsem_wake.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list
      0.00 ±  0%      +Inf%       1.03 ±  0%  perf-profile.cpu-cycles.rwsem_wake.call_rwsem_wake.rmap_walk.page_referenced.shrink_page_list
        32 ± 10%     -96.2%          1 ± 34%  sched_debug.cfs_rq[17]:/.nr_spread_over
        42 ±  0%     -84.5%          6 ± 41%  sched_debug.cpu#31.load
        44 ±  4%     -85.2%          6 ± 41%  sched_debug.cfs_rq[31]:/.load
    534530 ± 21%     -79.3%     110651 ± 35%  sched_debug.cpu#32.nr_switches
    535267 ± 20%     -79.1%     111666 ± 35%  sched_debug.cpu#32.sched_count
    266369 ± 20%     -79.4%      54763 ± 36%  sched_debug.cpu#32.sched_goidle
 116443.25 ± 37%    -100.0%       0.00 ±  0%  sched_debug.cfs_rq[11]:/.max_vruntime
 116443.25 ± 37%    -100.0%       0.00 ±  0%  sched_debug.cfs_rq[11]:/.MIN_vruntime
        18 ± 44%     -72.2%          5 ± 14%  sched_debug.cpu#35.cpu_load[0]
        18 ± 44%     -76.4%          4 ± 25%  sched_debug.cpu#35.cpu_load[1]
      1.02 ± 29%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.flush_smp_call_function_queue.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.mutex_optimistic_spin
 141571.82 ± 19%    -100.0%       0.00 ±  0%  sched_debug.cfs_rq[0]:/.MIN_vruntime
 141571.82 ± 19%    -100.0%       0.00 ±  0%  sched_debug.cfs_rq[0]:/.max_vruntime
        17 ± 48%     -75.7%          4 ± 34%  sched_debug.cfs_rq[35]:/.runnable_load_avg
       823 ± 43%     -72.0%        230 ± 14%  sched_debug.cpu#35.ttwu_local
       961 ± 38%     -63.8%        347 ± 38%  sched_debug.cpu#43.ttwu_local
    135338 ± 38%     -59.8%      54354 ± 43%  sched_debug.cpu#27.ttwu_count
        20 ± 20%     -77.5%          4 ± 36%  sched_debug.cpu#46.cpu_load[0]
         3 ± 14%     -64.3%          1 ± 34%  sched_debug.cfs_rq[33]:/.nr_spread_over
      4944 ± 15%     -69.0%       1533 ±  8%  sched_debug.cpu#19.ttwu_local
    244794 ± 46%     -64.2%      87628 ± 17%  sched_debug.cpu#45.nr_switches
    121511 ± 46%     -64.2%      43527 ± 17%  sched_debug.cpu#45.sched_goidle
    248225 ± 47%     -64.0%      89438 ± 17%  sched_debug.cpu#45.sched_count
      2.06 ± 25%     -65.1%       0.72 ±  3%  perf-profile.cpu-cycles.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone.kswapd_shrink_zone
      2.07 ± 25%     -64.9%       0.73 ±  3%  perf-profile.cpu-cycles.shrink_zone.kswapd_shrink_zone.kswapd.kthread.ret_from_fork
      2.07 ± 25%     -64.9%       0.73 ±  3%  perf-profile.cpu-cycles.kswapd_shrink_zone.kswapd.kthread.ret_from_fork
      2.07 ± 25%     -64.9%       0.73 ±  3%  perf-profile.cpu-cycles.shrink_lruvec.shrink_zone.kswapd_shrink_zone.kswapd.kthread
      2.07 ± 25%     -64.9%       0.73 ±  3%  perf-profile.cpu-cycles.kswapd.kthread.ret_from_fork
      2.07 ± 25%     -64.9%       0.73 ±  3%  perf-profile.cpu-cycles.shrink_inactive_list.shrink_lruvec.shrink_zone.kswapd_shrink_zone.kswapd
         9 ± 47%     -63.2%          3 ± 24%  sched_debug.cpu#45.cpu_load[4]
     38.51 ± 31%     -60.4%      15.25 ±  0%  perf-profile.cpu-cycles.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone.shrink_zones
     38.58 ± 31%     -60.2%      15.35 ±  0%  perf-profile.cpu-cycles.shrink_inactive_list.shrink_lruvec.shrink_zone.shrink_zones.do_try_to_free_pages
     38.59 ± 31%     -60.2%      15.36 ±  0%  perf-profile.cpu-cycles.shrink_lruvec.shrink_zone.shrink_zones.do_try_to_free_pages.try_to_free_pages
     38.59 ± 31%     -60.2%      15.37 ±  0%  perf-profile.cpu-cycles.shrink_zone.shrink_zones.do_try_to_free_pages.try_to_free_pages.__alloc_pages_nodemask
     38.05 ± 30%     -60.1%      15.17 ±  0%  perf-profile.cpu-cycles.shrink_zones.do_try_to_free_pages.try_to_free_pages.__alloc_pages_nodemask.alloc_pages_current
     36.81 ± 31%     -60.0%      14.74 ±  1%  perf-profile.cpu-cycles.do_try_to_free_pages.try_to_free_pages.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc
     36.81 ± 31%     -60.0%      14.74 ±  1%  perf-profile.cpu-cycles.try_to_free_pages.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead
     25.59 ± 30%     -60.5%      10.10 ±  3%  perf-profile.cpu-cycles.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.ondemand_readahead
     25.61 ± 30%     -60.5%      10.12 ±  3%  perf-profile.cpu-cycles.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead
     25.61 ± 30%     -60.4%      10.13 ±  3%  perf-profile.cpu-cycles.__page_cache_alloc.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead.filemap_fault
       646 ± 31%     -56.3%        282 ± 20%  sched_debug.cpu#24.ttwu_local
    110062 ± 35%     -58.0%      46222 ± 26%  sched_debug.cpu#41.sched_goidle
      2.17 ± 23%     -61.4%       0.83 ±  2%  perf-profile.cpu-cycles.ret_from_fork
      2.17 ± 23%     -61.4%       0.83 ±  2%  perf-profile.cpu-cycles.kthread.ret_from_fork
    221912 ± 35%     -57.9%      93448 ± 26%  sched_debug.cpu#41.nr_switches
    235539 ± 28%     -59.6%      95119 ± 25%  sched_debug.cpu#41.sched_count
    113095 ± 48%     -55.7%      50108 ± 19%  sched_debug.cpu#25.ttwu_count
       689 ± 25%     -62.8%        256 ± 12%  sched_debug.cpu#29.ttwu_local
    101269 ± 36%     -57.0%      43518 ± 16%  sched_debug.cpu#42.sched_goidle
    203648 ± 36%     -57.0%      87618 ± 15%  sched_debug.cpu#42.nr_switches
    205852 ± 35%     -56.8%      88943 ± 15%  sched_debug.cpu#42.sched_count
    270505 ± 43%     -57.0%     116240 ± 14%  sched_debug.cpu#33.sched_count
         6 ± 38%     -42.3%          3 ± 34%  sched_debug.cpu#44.cpu_load[4]
       140 ± 45%     -56.6%         61 ± 43%  sched_debug.cfs_rq[13]:/.tg_load_contrib
    177724 ±  9%    +217.1%     563500 ±  2%  sched_debug.cpu#2.sched_goidle
    132568 ± 42%     -56.8%      57335 ± 14%  sched_debug.cpu#33.sched_goidle
    266176 ± 42%     -56.8%     115093 ± 14%  sched_debug.cpu#33.nr_switches
    361283 ±  9%    +219.0%    1152534 ±  1%  sched_debug.cpu#2.sched_count
    358987 ±  9%    +214.5%    1129044 ±  3%  sched_debug.cpu#2.nr_switches
    357519 ± 43%     -56.8%     154299 ± 24%  sched_debug.cpu#22.avg_idle
     11.50 ± 31%     -56.1%       5.05 ±  9%  perf-profile.cpu-cycles.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.filemap_fault
     11.50 ± 31%     -56.0%       5.06 ±  9%  perf-profile.cpu-cycles.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.filemap_fault.__do_fault
     11.50 ± 31%     -56.1%       5.05 ±  9%  perf-profile.cpu-cycles.__page_cache_alloc.__do_page_cache_readahead.filemap_fault.__do_fault.do_read_fault
     11.52 ± 31%     -56.0%       5.07 ±  9%  perf-profile.cpu-cycles.__do_page_cache_readahead.filemap_fault.__do_fault.do_read_fault.handle_mm_fault
       158 ± 17%     -64.5%         56 ± 30%  sched_debug.cfs_rq[17]:/.blocked_load_avg
       916 ± 16%     -63.9%        330 ± 20%  sched_debug.cpu#44.ttwu_local
    140398 ± 14%     -62.8%      52291 ± 13%  sched_debug.cpu#44.sched_goidle
    282255 ± 14%     -62.7%     105251 ± 13%  sched_debug.cpu#44.nr_switches
    283232 ± 13%     -61.3%     109484 ± 10%  sched_debug.cpu#44.sched_count
       722 ± 30%     -53.2%        337 ± 16%  sched_debug.cpu#38.ttwu_local
      4035 ± 47%     -36.9%       2548 ± 31%  meminfo.AnonHugePages
    104439 ± 13%     -60.3%      41412 ± 17%  sched_debug.cpu#35.ttwu_count
     40.27 ± 27%     -54.5%      18.31 ±  0%  perf-profile.cpu-cycles.handle_mm_fault.__do_page_fault.do_page_fault.page_fault.do_unit
     39.04 ± 28%     -54.5%      17.78 ±  0%  perf-profile.cpu-cycles.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault.do_page_fault
     39.04 ± 28%     -54.5%      17.78 ±  0%  perf-profile.cpu-cycles.filemap_fault.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault
     40.29 ± 27%     -54.5%      18.34 ±  0%  perf-profile.cpu-cycles.__do_page_fault.do_page_fault.page_fault.do_unit
     40.30 ± 27%     -54.5%      18.34 ±  0%  perf-profile.cpu-cycles.do_page_fault.page_fault.do_unit
    144634 ± 29%     -61.9%      55063 ± 25%  sched_debug.cpu#34.sched_goidle
     40.31 ± 27%     -54.4%      18.37 ±  0%  perf-profile.cpu-cycles.page_fault.do_unit
    290308 ± 29%     -61.9%     110535 ± 25%  sched_debug.cpu#34.nr_switches
       678 ± 36%     -49.6%        341 ± 31%  sched_debug.cpu#42.ttwu_local
    291037 ± 29%     -61.7%     111505 ± 25%  sched_debug.cpu#34.sched_count
     39.17 ± 28%     -54.2%      17.96 ±  0%  perf-profile.cpu-cycles.do_read_fault.isra.58.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
    127105 ± 42%     -56.0%      55930 ± 28%  sched_debug.cpu#34.ttwu_count
       571 ± 37%     -50.8%        281 ± 22%  sched_debug.cpu#31.ttwu_local
         8 ± 29%     -50.0%          4 ± 42%  sched_debug.cpu#24.cpu_load[4]
     27.52 ± 27%     -53.8%      12.71 ±  2%  perf-profile.cpu-cycles.page_cache_async_readahead.filemap_fault.__do_fault.do_read_fault.handle_mm_fault
     27.52 ± 27%     -53.8%      12.70 ±  2%  perf-profile.cpu-cycles.ondemand_readahead.page_cache_async_readahead.filemap_fault.__do_fault.do_read_fault
     27.51 ± 27%     -53.8%      12.70 ±  2%  perf-profile.cpu-cycles.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead.filemap_fault.__do_fault
    198359 ± 18%    +216.5%     627757 ±  2%  sched_debug.cpu#3.sched_goidle
    399579 ± 18%    +214.7%    1257445 ±  2%  sched_debug.cpu#3.nr_switches
     37058 ± 24%     -48.5%      19099 ± 37%  proc-vmstat.pgactivate
    252555 ± 24%     -45.8%     136964 ± 45%  sched_debug.cpu#8.avg_idle
       785 ± 18%     -59.5%        318 ± 28%  sched_debug.cpu#30.ttwu_local
      3604 ± 19%     -55.9%       1587 ±  7%  sched_debug.cpu#17.ttwu_local
        13 ± 23%     -63.5%          4 ± 40%  sched_debug.cpu#46.cpu_load[1]
    411392 ± 19%    +218.1%    1308463 ±  6%  sched_debug.cpu#3.sched_count
     11248 ± 44%     -46.7%       5996 ±  8%  sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum
        38 ± 18%     -53.9%         17 ± 19%  sched_debug.cpu#16.cpu_load[3]
       243 ± 44%     -46.6%        130 ±  8%  sched_debug.cfs_rq[29]:/.tg_runnable_contrib
    124035 ± 22%     -56.1%      54473 ± 31%  sched_debug.cpu#32.ttwu_count
    120002 ± 28%     -54.7%      54347 ± 10%  sched_debug.cpu#26.ttwu_count
        41 ± 19%     -53.0%         19 ± 26%  sched_debug.cfs_rq[1]:/.runnable_load_avg
        21 ± 16%    +151.2%         54 ± 29%  sched_debug.cpu#7.load
      8200 ± 41%    +207.2%      25186 ± 18%  cpuidle.C3-IVT.usage
       179 ± 13%     -57.9%         75 ± 30%  sched_debug.cfs_rq[17]:/.tg_load_contrib
       266 ± 25%     -52.1%        127 ± 11%  sched_debug.cfs_rq[27]:/.tg_runnable_contrib
     12234 ± 25%     -52.0%       5868 ± 11%  sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum
        36 ± 19%     -52.1%         17 ± 21%  sched_debug.cpu#16.cpu_load[4]
        57 ± 35%     -53.5%         26 ± 23%  sched_debug.cpu#1.load
       911 ± 41%     -45.6%        495 ± 24%  sched_debug.cpu#29.curr->pid
       192 ± 19%     -62.8%         71 ± 42%  sched_debug.cfs_rq[34]:/.blocked_load_avg
    100556 ± 29%     -53.5%      46739 ± 32%  sched_debug.cpu#46.sched_goidle
    202682 ± 29%     -53.4%      94439 ± 32%  sched_debug.cpu#46.nr_switches
    203033 ± 29%     -51.1%      99370 ± 30%  sched_debug.cpu#46.sched_count
    112925 ±  6%     -58.7%      46633 ± 33%  sched_debug.cpu#30.ttwu_count
       197 ± 17%     -60.8%         77 ± 40%  sched_debug.cfs_rq[34]:/.tg_load_contrib
        57 ± 35%     -37.3%         35 ± 26%  sched_debug.cfs_rq[1]:/.load
       488 ±  5%     -56.1%        214 ± 12%  sched_debug.cpu#34.ttwu_local
        42 ± 19%     -49.4%         21 ± 18%  sched_debug.cpu#3.cpu_load[4]
    108113 ± 28%     -50.1%      53902 ± 19%  sched_debug.cpu#28.ttwu_count
     83738 ± 36%     -24.2%      63466 ± 46%  sched_debug.cpu#47.sched_goidle
        20 ± 25%    +136.2%         47 ± 36%  sched_debug.cfs_rq[21]:/.load
    395212 ±  1%     -59.5%     159962 ± 16%  sched_debug.cpu#21.avg_idle
        34 ± 33%     -36.2%         22 ± 34%  sched_debug.cpu#15.cpu_load[4]
    113163 ± 11%     -53.6%      52505 ± 12%  sched_debug.cpu#29.ttwu_count
    169129 ± 36%     -24.1%     128298 ± 45%  sched_debug.cpu#47.nr_switches
    169646 ± 36%     -23.5%     129736 ± 45%  sched_debug.cpu#47.sched_count
        33 ± 34%     -39.6%         20 ± 12%  sched_debug.cpu#15.cpu_load[0]
     11699 ± 13%     -45.7%       6354 ± 20%  sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum
        43 ±  9%     -48.8%         22 ± 26%  sched_debug.cpu#1.cpu_load[1]
       470 ± 12%     -52.7%        222 ±  8%  sched_debug.cpu#33.ttwu_local
      3739 ± 23%     -39.4%       2265 ± 38%  sched_debug.cpu#13.ttwu_local
       254 ± 13%     -45.6%        138 ± 19%  sched_debug.cfs_rq[28]:/.tg_runnable_contrib
        44 ± 11%     -50.0%         22 ± 21%  sched_debug.cpu#1.cpu_load[0]
      3607 ± 14%     -48.6%       1854 ± 17%  sched_debug.cpu#23.ttwu_local
    394541 ±  1%     -51.8%     190213 ± 29%  sched_debug.cpu#18.avg_idle
    232039 ± 49%    +206.2%     710604 ± 10%  sched_debug.cpu#32.avg_idle
        33 ± 31%     -37.3%         21 ± 19%  sched_debug.cpu#15.cpu_load[1]
         9 ± 15%     -50.0%          4 ± 45%  sched_debug.cpu#24.cpu_load[3]
        42 ±  9%     -53.0%         19 ± 21%  sched_debug.cpu#16.cpu_load[0]
        34 ± 33%     -35.5%         22 ± 31%  sched_debug.cpu#15.cpu_load[3]
        39 ± 16%     -53.8%         18 ± 18%  sched_debug.cpu#16.cpu_load[2]
        41 ± 12%     -53.0%         19 ± 21%  sched_debug.cpu#16.cpu_load[1]
    325127 ± 11%     -50.1%     162114 ± 13%  sched_debug.cpu#19.avg_idle
        41 ± 17%     -47.6%         21 ± 11%  sched_debug.cpu#3.cpu_load[3]
       210 ± 26%     -39.8%        126 ±  9%  sched_debug.cfs_rq[30]:/.tg_runnable_contrib
      9654 ± 26%     -39.5%       5844 ±  9%  sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum
        42 ±  7%     -48.2%         21 ± 26%  sched_debug.cpu#1.cpu_load[2]
        34 ± 32%     -35.3%         22 ± 27%  sched_debug.cpu#15.cpu_load[2]
    264389 ± 32%     -42.1%     153208 ± 30%  sched_debug.cpu#17.avg_idle
        32 ± 31%     -38.3%         19 ±  7%  sched_debug.cfs_rq[15]:/.runnable_load_avg
        41 ±  7%     -54.3%         18 ± 24%  sched_debug.cfs_rq[16]:/.runnable_load_avg
       225 ± 17%     -44.1%        126 ±  8%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
    348597 ±  0%    +103.0%     707663 ±  5%  sched_debug.cpu#34.avg_idle
    449999 ± 22%    +147.2%    1112495 ±  5%  sched_debug.cpu#14.sched_count
     77241 ± 24%     -41.3%      45332 ±  4%  numa-meminfo.node1.Active(anon)
    458252 ± 14%    +134.4%    1074159 ±  3%  sched_debug.cpu#15.nr_switches
    143667 ±  8%     -47.3%      75686 ± 34%  sched_debug.cpu#36.nr_switches
    198599 ± 12%     -40.4%     118410 ± 26%  sched_debug.cpu#24.sched_count
     10367 ± 17%     -44.1%       5797 ±  8%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
    226163 ± 15%    +136.4%     534622 ±  3%  sched_debug.cpu#15.sched_goidle
     71145 ±  8%     -47.8%      37141 ± 34%  sched_debug.cpu#36.sched_goidle
     18829 ± 25%     -40.4%      11220 ±  4%  numa-vmstat.node1.nr_active_anon
        65 ± 10%     -48.5%         33 ± 18%  sched_debug.cfs_rq[16]:/.load
    145293 ±  7%     -46.4%      77894 ± 33%  sched_debug.cpu#36.sched_count
     97284 ±  2%     -49.6%      49014 ± 24%  sched_debug.cpu#25.sched_goidle
    195675 ±  2%     -49.6%      98683 ± 24%  sched_debug.cpu#25.nr_switches
    550098 ±  9%    +121.5%    1218282 ±  1%  cpuidle.C6-IVT.usage
       199 ± 27%     -37.4%        124 ±  6%  sched_debug.cfs_rq[47]:/.tg_runnable_contrib
    195734 ±  2%     -48.6%     100523 ± 25%  sched_debug.cpu#25.sched_count
    307889 ± 24%     -43.3%     174487 ± 18%  sched_debug.cpu#20.avg_idle
    216214 ± 21%    +140.6%     520172 ±  2%  sched_debug.cpu#14.sched_goidle
         5 ± 20%     -40.0%          3 ± 23%  sched_debug.cpu#36.cpu_load[4]
        40 ±  3%     -46.3%         21 ± 26%  sched_debug.cpu#1.cpu_load[3]
        10 ± 20%     -42.5%          5 ± 25%  sched_debug.cfs_rq[42]:/.load
         5 ±  9%     -40.9%          3 ± 33%  sched_debug.cpu#36.cpu_load[3]
      0.02 ±  0%    +125.0%       0.04 ± 45%  turbostat.%c3
    436214 ± 21%    +139.0%    1042659 ±  2%  sched_debug.cpu#14.nr_switches
      9142 ± 27%     -37.1%       5751 ±  6%  sched_debug.cfs_rq[47]:/.avg->runnable_avg_sum
       250 ± 10%     -46.2%        134 ± 11%  sched_debug.cfs_rq[31]:/.tg_runnable_contrib
       185 ± 25%     -36.0%        118 ±  9%  sched_debug.cfs_rq[36]:/.tg_runnable_contrib
        68 ±  6%     -45.3%         37 ± 11%  sched_debug.cpu#16.load
     11467 ± 10%     -46.1%       6181 ± 11%  sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum
      8527 ± 25%     -36.1%       5451 ±  9%  sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum
      2757 ± 16%     -39.8%       1658 ±  5%  sched_debug.cpu#15.curr->pid
      3100 ± 17%     -28.6%       2212 ± 32%  sched_debug.cpu#18.ttwu_local
        24 ±  2%    +141.8%         59 ± 44%  sched_debug.cpu#18.load
        39 ± 18%     -44.3%         22 ± 11%  sched_debug.cpu#3.cpu_load[2]
     10432 ±  8%     -42.1%       6036 ±  9%  sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum
       227 ±  7%     -42.4%        130 ±  9%  sched_debug.cfs_rq[38]:/.tg_runnable_contrib
     93977 ±  8%     -39.9%      56508 ± 30%  sched_debug.cpu#24.sched_goidle
    189361 ±  8%     -40.0%     113550 ± 30%  sched_debug.cpu#24.nr_switches
      2759 ±  8%     -47.3%       1454 ± 19%  sched_debug.cpu#1.curr->pid
        37 ± 17%     -41.3%         22 ± 14%  sched_debug.cpu#3.cpu_load[1]
        35 ± 18%     -38.0%         22 ± 21%  sched_debug.cpu#3.cpu_load[0]
        39 ±  1%     -45.6%         21 ± 30%  sched_debug.cpu#1.cpu_load[4]
      1186 ± 23%     -31.6%        811 ± 30%  sched_debug.cpu#47.curr->pid
    354895 ± 13%    +105.7%     730183 ±  8%  sched_debug.cpu#35.avg_idle
     10495 ± 27%     -39.9%       6305 ± 14%  sched_debug.cfs_rq[24]:/.avg->runnable_avg_sum
     87380 ± 17%     -37.4%      54692 ± 10%  sched_debug.cpu#33.ttwu_count
       228 ± 27%     -39.8%        137 ± 14%  sched_debug.cfs_rq[24]:/.tg_runnable_contrib
       208 ± 24%     -38.4%        128 ±  9%  sched_debug.cfs_rq[34]:/.tg_runnable_contrib
       819 ± 24%     -39.3%        497 ± 21%  sched_debug.cpu#41.ttwu_local
       944 ±  5%     -43.2%        536 ±  7%  cpuidle.POLL.usage
      9573 ± 24%     -38.2%       5920 ±  9%  sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum
        90 ±  4%     -35.1%         58 ± 35%  sched_debug.cfs_rq[11]:/.blocked_load_avg
    378417 ±  8%     +94.6%     736481 ±  9%  sched_debug.cpu#33.avg_idle
        20 ± 25%    +128.8%         45 ± 24%  sched_debug.cfs_rq[7]:/.load
     61938 ± 12%     -39.4%      37530 ±  5%  sched_debug.cfs_rq[32]:/.exec_clock
    521095 ± 24%    +117.9%    1135582 ±  6%  sched_debug.cpu#15.sched_count
         9 ± 15%     -52.6%          4 ± 36%  sched_debug.cpu#46.cpu_load[2]
    100874 ± 20%     -34.5%      66025 ±  1%  meminfo.Active(anon)
    292119 ± 28%     -43.7%     164431 ± 27%  sched_debug.cpu#13.avg_idle
    113098 ±  4%     -50.5%      56017 ± 22%  sched_debug.cpu#31.ttwu_count
    333765 ±  0%     +81.9%     607170 ±  1%  sched_debug.cpu#20.ttwu_count
     29688 ± 15%     -36.9%      18721 ±  7%  sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
     57876 ± 17%     -35.5%      37332 ±  6%  sched_debug.cfs_rq[27]:/.exec_clock
       647 ± 15%     -36.9%        408 ±  7%  sched_debug.cfs_rq[15]:/.tg_runnable_contrib
     33982 ±  9%     -39.3%      20638 ±  9%  sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum
      1211 ± 25%     -40.3%        723 ± 21%  sched_debug.cpu#42.curr->pid
       742 ±  9%     -39.3%        450 ±  9%  sched_debug.cfs_rq[3]:/.tg_runnable_contrib
       674 ± 21%     -39.0%        411 ± 11%  sched_debug.cpu#39.ttwu_local
     24927 ± 20%     -33.6%      16551 ±  1%  proc-vmstat.nr_active_anon
         8 ±  5%     -41.2%          5 ± 24%  sched_debug.cfs_rq[28]:/.load
         8 ± 12%     -37.5%          5 ± 42%  sched_debug.cpu#42.cpu_load[0]
         8 ±  5%     -41.2%          5 ± 24%  sched_debug.cpu#28.load
         8 ± 12%     -37.5%          5 ± 42%  sched_debug.cfs_rq[42]:/.runnable_load_avg
       769 ± 26%     -38.0%        476 ± 18%  sched_debug.cpu#40.ttwu_local
     59399 ± 13%     -37.5%      37105 ±  2%  sched_debug.cfs_rq[29]:/.exec_clock
       593 ± 19%     -38.4%        365 ± 25%  sched_debug.cpu#45.ttwu_local
     73311 ± 25%     -34.4%      48092 ± 11%  sched_debug.cpu#37.sched_goidle
     58720 ± 15%     -36.9%      37068 ±  4%  sched_debug.cfs_rq[28]:/.exec_clock
     58563 ± 13%     -37.3%      36691 ±  4%  sched_debug.cfs_rq[30]:/.exec_clock
   3205188 ± 12%     -35.1%    2079297 ± 27%  cpuidle.C1E-IVT.time
    147981 ± 25%     -34.2%      97422 ± 11%  sched_debug.cpu#37.nr_switches
     58567 ± 13%     -36.4%      37225 ±  4%  sched_debug.cfs_rq[34]:/.exec_clock
       223 ±  1%     -46.0%        120 ±  9%  sched_debug.cfs_rq[35]:/.tg_runnable_contrib
     58949 ±  9%     -37.0%      37126 ±  1%  sched_debug.cfs_rq[31]:/.exec_clock
         6 ±  7%     -38.5%          4 ± 35%  sched_debug.cpu#46.cpu_load[4]
        20 ± 17%    +119.5%         45 ± 24%  sched_debug.cfs_rq[18]:/.load
    148106 ± 25%     -33.6%      98405 ± 11%  sched_debug.cpu#37.sched_count
    101872 ± 21%     -34.0%      67261 ±  6%  numa-meminfo.node1.Shmem
     10276 ±  1%     -46.0%       5553 ±  9%  sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum
       852 ±  5%     -33.3%        568 ± 30%  sched_debug.cpu#27.curr->pid
     56228 ± 14%     -33.9%      37144 ±  2%  sched_debug.cfs_rq[25]:/.exec_clock
      8322 ± 15%     -34.2%       5477 ±  8%  sched_debug.cfs_rq[43]:/.avg->runnable_avg_sum
       180 ± 15%     -33.9%        119 ±  8%  sched_debug.cfs_rq[43]:/.tg_runnable_contrib
      3142 ±  5%     -35.1%       2041 ± 13%  sched_debug.cpu#20.ttwu_local
     79503 ± 13%     -36.2%      50683 ± 24%  sched_debug.cpu#41.ttwu_count
     11075 ± 13%     -34.2%       7290 ± 23%  sched_debug.cfs_rq[32]:/.avg->runnable_avg_sum
    107991 ± 18%     -31.5%      73987 ±  0%  meminfo.Shmem
       241 ± 13%     -34.5%        158 ± 23%  sched_debug.cfs_rq[32]:/.tg_runnable_contrib
    243694 ± 17%     -34.0%     160859 ± 21%  sched_debug.cpu#16.avg_idle
     24984 ± 21%     -33.1%      16716 ±  6%  numa-vmstat.node1.nr_shmem
        34 ± 14%     -37.5%         21 ± 17%  sched_debug.cfs_rq[3]:/.runnable_load_avg
     26661 ± 17%     -30.5%      18541 ±  1%  proc-vmstat.nr_shmem
    263599 ±  4%     -32.6%     177657 ± 18%  sched_debug.cpu#1.avg_idle
       176 ± 19%     -29.8%        123 ±  3%  sched_debug.cfs_rq[44]:/.tg_runnable_contrib
     56734 ± 11%     -34.4%      37240 ±  1%  sched_debug.cfs_rq[26]:/.exec_clock
     54635 ± 13%     -33.1%      36526 ±  1%  sched_debug.cfs_rq[24]:/.exec_clock
        46 ± 36%    +129.9%        105 ±  8%  sched_debug.cfs_rq[5]:/.tg_load_contrib
      8104 ± 19%     -29.7%       5697 ±  3%  sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum
         9 ± 11%     -38.9%          5 ± 45%  sched_debug.cpu#34.cpu_load[0]
         9 ± 11%     -41.7%          5 ± 41%  sched_debug.cpu#42.cpu_load[1]
        10 ±  0%     -47.5%          5 ± 36%  sched_debug.cfs_rq[31]:/.runnable_load_avg
         4 ± 11%     -38.9%          2 ± 30%  sched_debug.cpu#42.cpu_load[4]
    393940 ±  1%     -35.9%     252557 ± 15%  sched_debug.cpu#0.avg_idle
     55119 ±  8%     -34.2%      36278 ±  3%  sched_debug.cfs_rq[35]:/.exec_clock
       204 ±  0%     -40.2%        122 ±  2%  sched_debug.cfs_rq[45]:/.tg_runnable_contrib
       878 ± 11%     -30.9%        607 ± 18%  sched_debug.cpu#46.curr->pid
      9421 ±  0%     -40.5%       5602 ±  3%  sched_debug.cfs_rq[45]:/.avg->runnable_avg_sum
     71278 ± 19%     -34.3%      46823 ± 14%  sched_debug.cpu#45.ttwu_count
       706 ±  2%     -37.3%        443 ± 16%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
       640 ± 21%     -27.5%        464 ± 11%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
     32384 ±  2%     -37.2%      20347 ± 16%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
     29418 ± 21%     -27.6%      21302 ± 11%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
    115950 ±  7%     -32.3%      78456 ±  3%  sched_debug.cfs_rq[14]:/.exec_clock
        12 ±  4%     +50.0%         18 ± 16%  sched_debug.cfs_rq[19]:/.runnable_load_avg
    337262 ± 38%    +115.2%     725624 ±  5%  sched_debug.cpu#30.avg_idle
       509 ± 14%     -37.4%        318 ± 40%  sched_debug.cpu#25.ttwu_local
    415228 ±  3%     +60.6%     666835 ± 10%  sched_debug.cpu#24.avg_idle
    122127 ±  8%     -33.8%      80901 ±  1%  sched_debug.cfs_rq[3]:/.exec_clock
         7 ±  6%     -46.7%          4 ± 39%  sched_debug.cpu#31.cpu_load[4]
         7 ±  6%     -40.0%          4 ± 24%  sched_debug.cpu#42.cpu_load[2]
         7 ± 14%     -32.1%          4 ± 31%  sched_debug.cpu#47.cpu_load[3]
         8 ±  0%     -46.9%          4 ± 34%  sched_debug.cpu#46.cpu_load[3]
         7 ±  6%     -40.0%          4 ± 40%  sched_debug.cfs_rq[28]:/.runnable_load_avg
      2828 ±  5%     -33.2%       1890 ± 18%  sched_debug.cpu#16.ttwu_local
       973 ±  2%     -38.1%        602 ± 30%  sched_debug.cpu#38.curr->pid
     12.72 ± 16%     -26.7%       9.33 ±  0%  perf-profile.cpu-cycles.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone
    120434 ± 16%     -28.4%      86248 ±  3%  numa-meminfo.node1.Active
    115868 ±  7%     -32.1%      78675 ±  1%  sched_debug.cfs_rq[15]:/.exec_clock
      2730 ±  1%     -35.4%       1764 ±  5%  sched_debug.cpu#3.curr->pid
     12.49 ± 16%     -25.8%       9.27 ±  0%  perf-profile.cpu-cycles.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec
     76589 ± 20%     -29.7%      53841 ± 13%  sched_debug.cpu#37.ttwu_count
         9 ± 15%     -42.1%          5 ± 48%  sched_debug.cpu#31.cpu_load[2]
    124110 ±  4%     -33.1%      82971 ±  2%  sched_debug.cfs_rq[2]:/.exec_clock
     75681 ± 15%     -37.4%      47341 ± 22%  sched_debug.cpu#43.ttwu_count
   2937556 ± 14%     -26.6%    2157455 ±  1%  sched_debug.cfs_rq[9]:/.min_vruntime
    351956 ± 41%    +113.5%     751528 ±  3%  sched_debug.cpu#29.avg_idle
      2893 ± 10%     -31.3%       1988 ± 11%  sched_debug.cpu#2.curr->pid
    333679 ±  9%     +64.6%     549118 ±  3%  sched_debug.cpu#8.ttwu_count
        16 ± 33%     +95.5%         32 ±  8%  sched_debug.cpu#7.cpu_load[0]
     55033 ±  6%     -32.1%      37382 ±  3%  sched_debug.cfs_rq[33]:/.exec_clock
   2912268 ± 14%     -24.9%    2186689 ±  1%  sched_debug.cfs_rq[11]:/.min_vruntime
    103839 ± 17%     -23.2%      79742 ±  2%  sched_debug.cfs_rq[9]:/.exec_clock
    221835 ±  3%     -36.6%     140546 ± 14%  sched_debug.cpu#5.avg_idle
        39 ± 18%     -24.7%         29 ±  9%  sched_debug.cfs_rq[15]:/.load
     49071 ±  9%     -26.8%      35934 ±  4%  sched_debug.cfs_rq[36]:/.exec_clock
   2709012 ± 16%     -22.3%    2104190 ±  1%  sched_debug.cfs_rq[21]:/.min_vruntime
         6 ±  0%     -45.8%          3 ± 25%  sched_debug.cpu#42.cpu_load[3]
         8 ± 12%     -40.6%          4 ± 40%  sched_debug.cpu#31.cpu_load[3]
        11 ±  4%     -47.8%          6 ± 40%  sched_debug.cpu#38.cpu_load[0]
         8 ± 12%     -50.0%          4 ± 50%  sched_debug.cpu#27.cpu_load[4]
    386952 ± 23%     +83.0%     708259 ±  2%  sched_debug.cpu#26.avg_idle
      7326 ±  9%     -23.5%       5608 ±  9%  sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum
   3191103 ±  2%     -31.4%    2188471 ±  1%  sched_debug.cfs_rq[2]:/.min_vruntime
     82086 ±  6%     -33.0%      54958 ±  8%  sched_debug.cpu#44.ttwu_count
   2890142 ± 13%     -24.9%    2171243 ±  1%  sched_debug.cfs_rq[10]:/.min_vruntime
      2457 ± 18%     -29.9%       1723 ± 19%  sched_debug.cpu#9.curr->pid
   2727512 ± 14%     -23.3%    2091338 ±  1%  sched_debug.cfs_rq[23]:/.min_vruntime
       159 ±  9%     -23.3%        122 ±  9%  sched_debug.cfs_rq[42]:/.tg_runnable_contrib
      2462 ± 13%     -27.1%       1795 ± 10%  sched_debug.cpu#16.curr->pid
   2701103 ± 15%     -22.1%    2102936 ±  2%  sched_debug.cfs_rq[22]:/.min_vruntime
   3034169 ± 10%     -25.7%    2254798 ±  1%  sched_debug.cfs_rq[0]:/.min_vruntime
   3155734 ±  1%     -31.3%    2168304 ±  0%  sched_debug.cfs_rq[3]:/.min_vruntime
   2281498 ± 10%     -26.4%    1680208 ±  2%  sched_debug.cfs_rq[32]:/.min_vruntime
   3057557 ±  6%     -27.7%    2209313 ±  1%  sched_debug.cfs_rq[1]:/.min_vruntime
   2254079 ±  9%     -25.8%    1671750 ±  2%  sched_debug.cfs_rq[28]:/.min_vruntime
     92291 ± 18%     -19.2%      74589 ±  1%  sched_debug.cfs_rq[23]:/.exec_clock
   3063883 ±  1%     -30.1%    2142059 ±  3%  sched_debug.cfs_rq[14]:/.min_vruntime
     50151 ±  6%     -26.7%      36747 ±  3%  sched_debug.cfs_rq[39]:/.exec_clock
     35769 ±  8%     -29.9%      25064 ±  6%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
   3068829 ±  1%     -30.9%    2120576 ±  2%  sched_debug.cfs_rq[15]:/.min_vruntime
       781 ±  8%     -30.0%        547 ±  6%  sched_debug.cfs_rq[2]:/.tg_runnable_contrib
   2256242 ±  9%     -25.7%    1675498 ±  1%  sched_debug.cfs_rq[29]:/.min_vruntime
     50205 ±  6%     -26.9%      36707 ±  3%  sched_debug.cfs_rq[37]:/.exec_clock
   3250759 ±  5%     -27.5%    2358220 ±  0%  softirqs.TIMER
   2244501 ± 10%     -25.3%    1676302 ±  2%  sched_debug.cfs_rq[27]:/.min_vruntime
   2232461 ±  9%     -25.1%    1671122 ±  2%  sched_debug.cfs_rq[30]:/.min_vruntime
    412796 ± 25%     +75.6%     724762 ± 10%  sched_debug.cpu#25.avg_idle
    101241 ± 15%     -20.2%      80832 ±  1%  sched_debug.cfs_rq[10]:/.exec_clock
   2880339 ± 10%     -22.6%    2228081 ±  2%  sched_debug.cfs_rq[12]:/.min_vruntime
  3.77e+09 ± 12%     +62.4%  6.121e+09 ±  1%  cpuidle.C6-IVT.time
     31003 ± 16%     -29.6%      21815 ± 16%  sched_debug.cfs_rq[14]:/.avg->runnable_avg_sum
       676 ± 16%     -29.5%        476 ± 16%  sched_debug.cfs_rq[14]:/.tg_runnable_contrib
   2240325 ±  7%     -25.3%    1672621 ±  1%  sched_debug.cfs_rq[31]:/.min_vruntime
   2228382 ±  9%     -24.7%    1677834 ±  2%  sched_debug.cfs_rq[34]:/.min_vruntime
    236748 ±  3%     -34.0%     156159 ± 12%  sched_debug.cpu#4.avg_idle
   2888090 ±  7%     -25.1%    2163595 ±  2%  sched_debug.cfs_rq[13]:/.min_vruntime
         9 ±  5%     -36.8%          6 ± 20%  sched_debug.cpu#38.cpu_load[2]
        19 ±  2%     -30.8%         13 ±  3%  vmstat.procs.r
   2206299 ±  9%     -24.0%    1676888 ±  1%  sched_debug.cfs_rq[25]:/.min_vruntime
     48946 ±  4%     -26.4%      36012 ±  1%  sched_debug.cfs_rq[44]:/.exec_clock
   2169012 ±  9%     -23.0%    1670950 ±  1%  sched_debug.cfs_rq[24]:/.min_vruntime
    267987 ±  3%     -39.6%     161758 ± 25%  sched_debug.cpu#7.avg_idle
   2220319 ±  7%     -24.5%    1675674 ±  1%  sched_debug.cfs_rq[26]:/.min_vruntime
      1614 ±  6%     -28.2%       1160 ± 10%  sched_debug.cpu#9.ttwu_local
     49240 ±  4%     -26.6%      36165 ±  4%  sched_debug.cfs_rq[43]:/.exec_clock
      2351 ± 13%     -21.0%       1857 ± 14%  sched_debug.cpu#14.curr->pid
   2148224 ±  8%     -22.8%    1659387 ±  2%  sched_debug.cfs_rq[35]:/.min_vruntime
     50310 ±  6%     -22.7%      38883 ±  5%  sched_debug.cfs_rq[47]:/.exec_clock
     50877 ±  4%     -25.5%      37897 ±  1%  sched_debug.cfs_rq[38]:/.exec_clock
   2185406 ±  7%     -23.1%    1681305 ±  2%  sched_debug.cfs_rq[33]:/.min_vruntime
     48668 ±  5%     -25.3%      36375 ±  3%  sched_debug.cfs_rq[45]:/.exec_clock
   2735251 ±  8%     -21.3%    2151871 ±  0%  sched_debug.cfs_rq[8]:/.min_vruntime
       892 ±  1%     -30.4%        621 ±  9%  sched_debug.cpu#28.curr->pid
     18745 ±  4%     -24.6%      14130 ±  2%  sched_debug.cfs_rq[11]:/.tg->runnable_avg
     18738 ±  4%     -24.6%      14127 ±  2%  sched_debug.cfs_rq[10]:/.tg->runnable_avg
     18727 ±  4%     -24.6%      14123 ±  2%  sched_debug.cfs_rq[8]:/.tg->runnable_avg
     18732 ±  4%     -24.6%      14125 ±  2%  sched_debug.cfs_rq[9]:/.tg->runnable_avg
     18722 ±  4%     -24.6%      14120 ±  2%  sched_debug.cfs_rq[7]:/.tg->runnable_avg
     25479 ±  3%     -27.5%      18484 ± 14%  sched_debug.cfs_rq[16]:/.avg->runnable_avg_sum
     49186 ±  8%     -24.7%      37045 ±  4%  sched_debug.cfs_rq[46]:/.exec_clock
        10 ±  4%     -42.9%          6 ± 45%  sched_debug.cpu#38.cpu_load[1]
       556 ±  3%     -27.4%        404 ± 14%  sched_debug.cfs_rq[16]:/.tg_runnable_contrib
    184300 ± 10%     -19.5%     148390 ±  1%  meminfo.Active
   2906500 ±  2%     -25.4%    2167333 ±  0%  sched_debug.cfs_rq[4]:/.min_vruntime
     18732 ±  4%     -24.6%      14125 ±  2%  sched_debug.cfs_rq[1]:/.tg->runnable_avg
     18734 ±  4%     -24.6%      14131 ±  2%  sched_debug.cfs_rq[2]:/.tg->runnable_avg
     18722 ±  4%     -24.6%      14114 ±  2%  sched_debug.cfs_rq[0]:/.tg->runnable_avg
     48754 ±  3%     -25.8%      36196 ±  3%  sched_debug.cfs_rq[41]:/.exec_clock
      2342 ±  3%     -29.4%       1654 ± 13%  sched_debug.cpu#14.ttwu_local
     86444 ±  8%     -20.5%      68719 ±  2%  sched_debug.cpu#28.nr_load_updates
   2117189 ±  6%     -21.0%    1672016 ±  2%  sched_debug.cfs_rq[37]:/.min_vruntime
     89642 ±  6%     -20.9%      70889 ±  2%  sched_debug.cpu#32.nr_load_updates
     18719 ±  4%     -24.4%      14155 ±  2%  sched_debug.cfs_rq[5]:/.tg->runnable_avg
     18719 ±  4%     -24.4%      14158 ±  2%  sched_debug.cfs_rq[6]:/.tg->runnable_avg
     18746 ±  4%     -24.3%      14194 ±  2%  sched_debug.cfs_rq[12]:/.tg->runnable_avg
     18705 ±  4%     -24.4%      14147 ±  2%  sched_debug.cfs_rq[3]:/.tg->runnable_avg
     18711 ±  4%     -24.4%      14151 ±  2%  sched_debug.cfs_rq[4]:/.tg->runnable_avg
     18747 ±  4%     -24.3%      14200 ±  2%  sched_debug.cfs_rq[13]:/.tg->runnable_avg
     18750 ±  4%     -24.2%      14209 ±  2%  sched_debug.cfs_rq[14]:/.tg->runnable_avg
     18757 ±  4%     -24.2%      14220 ±  2%  sched_debug.cfs_rq[16]:/.tg->runnable_avg
     18763 ±  4%     -24.2%      14223 ±  2%  sched_debug.cfs_rq[17]:/.tg->runnable_avg
   2566671 ± 10%     -18.9%    2081331 ±  2%  sched_debug.cfs_rq[20]:/.min_vruntime
     18753 ±  4%     -24.2%      14220 ±  2%  sched_debug.cfs_rq[15]:/.tg->runnable_avg
    113665 ±  2%     -24.8%      85481 ±  0%  sched_debug.cfs_rq[1]:/.exec_clock
     18680 ±  5%     -23.6%      14275 ±  3%  sched_debug.cfs_rq[22]:/.tg->runnable_avg
        17 ± 31%     +75.7%         30 ±  7%  sched_debug.cpu#7.cpu_load[1]
     18766 ±  4%     -24.1%      14241 ±  2%  sched_debug.cfs_rq[18]:/.tg->runnable_avg
     18767 ±  4%     -24.2%      14228 ±  2%  sched_debug.cfs_rq[19]:/.tg->runnable_avg
     18665 ±  5%     -23.8%      14231 ±  2%  sched_debug.cfs_rq[20]:/.tg->runnable_avg
     18674 ±  5%     -23.8%      14235 ±  2%  sched_debug.cfs_rq[21]:/.tg->runnable_avg
     18674 ±  5%     -23.5%      14280 ±  3%  sched_debug.cfs_rq[23]:/.tg->runnable_avg
    104108 ±  6%     -22.1%      81073 ±  3%  sched_debug.cfs_rq[13]:/.exec_clock
      1481 ± 13%     -19.1%       1198 ±  7%  sched_debug.cpu#10.ttwu_local
     18677 ±  5%     -23.8%      14223 ±  3%  sched_debug.cfs_rq[24]:/.tg->runnable_avg
     18677 ±  5%     -23.8%      14223 ±  3%  sched_debug.cfs_rq[25]:/.tg->runnable_avg
     18680 ±  5%     -23.8%      14228 ±  3%  sched_debug.cfs_rq[26]:/.tg->runnable_avg
    675646 ± 28%     +71.2%    1156997 ±  2%  sched_debug.cpu#1.sched_count
     18627 ±  5%     -23.6%      14228 ±  3%  sched_debug.cfs_rq[27]:/.tg->runnable_avg
     18631 ±  5%     -23.2%      14308 ±  3%  sched_debug.cfs_rq[30]:/.tg->runnable_avg
     18627 ±  5%     -23.6%      14230 ±  3%  sched_debug.cfs_rq[28]:/.tg->runnable_avg
     18628 ±  5%     -23.6%      14231 ±  3%  sched_debug.cfs_rq[29]:/.tg->runnable_avg
       165 ±  2%     -25.1%        124 ±  8%  sched_debug.cfs_rq[41]:/.tg_runnable_contrib
     18636 ±  5%     -23.2%      14310 ±  3%  sched_debug.cfs_rq[31]:/.tg->runnable_avg
      7637 ±  2%     -25.5%       5692 ±  8%  sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
     18621 ±  5%     -23.2%      14310 ±  3%  sched_debug.cfs_rq[32]:/.tg->runnable_avg
    117808 ±  7%     -20.2%      93969 ±  1%  sched_debug.cfs_rq[0]:/.exec_clock
     28849 ± 12%     -19.8%      23134 ±  6%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
     18603 ±  4%     -23.1%      14313 ±  3%  sched_debug.cfs_rq[33]:/.tg->runnable_avg
     18736 ±  4%     -22.6%      14498 ±  1%  sched_debug.cfs_rq[37]:/.tg->runnable_avg
     18730 ±  4%     -22.6%      14494 ±  1%  sched_debug.cfs_rq[36]:/.tg->runnable_avg
     18722 ±  4%     -22.6%      14491 ±  1%  sched_debug.cfs_rq[35]:/.tg->runnable_avg
     18736 ±  4%     -22.6%      14501 ±  1%  sched_debug.cfs_rq[39]:/.tg->runnable_avg
     18734 ±  4%     -22.6%      14499 ±  1%  sched_debug.cfs_rq[38]:/.tg->runnable_avg
     18603 ±  4%     -22.1%      14485 ±  1%  sched_debug.cfs_rq[34]:/.tg->runnable_avg
    103545 ±  5%     -21.5%      81273 ±  1%  sched_debug.cfs_rq[4]:/.exec_clock
     47941 ±  2%     -24.4%      36242 ±  2%  sched_debug.cfs_rq[42]:/.exec_clock
   2070791 ±  6%     -19.1%    1675576 ±  2%  sched_debug.cfs_rq[47]:/.min_vruntime
       629 ± 12%     -19.6%        505 ±  6%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
    331579 ± 27%     +70.3%     564606 ±  2%  sched_debug.cpu#1.sched_goidle
   2132511 ±  5%     -20.7%    1691609 ±  1%  sched_debug.cfs_rq[38]:/.min_vruntime
   2072109 ±  7%     -19.8%    1662238 ±  1%  sched_debug.cfs_rq[36]:/.min_vruntime
    667043 ± 27%     +69.7%    1132176 ±  2%  sched_debug.cpu#1.nr_switches
        15 ± 46%     +95.0%         29 ± 10%  sched_debug.cfs_rq[7]:/.runnable_load_avg
     18629 ±  3%     -22.2%      14489 ±  1%  sched_debug.cfs_rq[41]:/.tg->runnable_avg
     18628 ±  3%     -22.2%      14487 ±  1%  sched_debug.cfs_rq[40]:/.tg->runnable_avg
     18631 ±  3%     -22.2%      14492 ±  1%  sched_debug.cfs_rq[43]:/.tg->runnable_avg
     18630 ±  3%     -22.2%      14490 ±  1%  sched_debug.cfs_rq[42]:/.tg->runnable_avg
   2075199 ±  7%     -19.2%    1675770 ±  2%  sched_debug.cfs_rq[46]:/.min_vruntime
     18632 ±  3%     -22.2%      14496 ±  1%  sched_debug.cfs_rq[44]:/.tg->runnable_avg
      2313 ±  3%     -24.9%       1737 ± 13%  sched_debug.cpu#4.curr->pid
     18625 ±  3%     -22.2%      14497 ±  1%  sched_debug.cfs_rq[45]:/.tg->runnable_avg
     18627 ±  3%     -22.2%      14501 ±  1%  sched_debug.cfs_rq[46]:/.tg->runnable_avg
     18627 ±  3%     -22.1%      14503 ±  1%  sched_debug.cfs_rq[47]:/.tg->runnable_avg
     87154 ±  8%     -19.7%      70009 ±  2%  sched_debug.cpu#30.nr_load_updates
   2066890 ±  5%     -19.4%    1665872 ±  1%  sched_debug.cfs_rq[44]:/.min_vruntime
        22 ± 11%     -13.3%         19 ± 13%  sched_debug.cpu#20.cpu_load[2]
        33 ±  6%     +35.6%         44 ± 12%  sched_debug.cpu#0.load
   2070604 ±  6%     -19.2%    1673355 ±  2%  sched_debug.cfs_rq[45]:/.min_vruntime
    365951 ± 33%     +72.9%     632720 ±  3%  sched_debug.cpu#18.ttwu_count
     87470 ±  7%     -19.3%      70583 ±  1%  sched_debug.cpu#29.nr_load_updates
   2780140 ±  2%     -21.6%    2178979 ±  0%  sched_debug.cfs_rq[5]:/.min_vruntime
   2113140 ±  5%     -20.9%    1671691 ±  1%  sched_debug.cfs_rq[39]:/.min_vruntime
       495 ±  2%     -22.0%        386 ±  3%  numa-vmstat.node0.nr_isolated_file
     87282 ±  5%     -19.9%      69905 ±  2%  sched_debug.cpu#31.nr_load_updates
   2776275 ±  2%     -21.6%    2177359 ±  1%  sched_debug.cfs_rq[7]:/.min_vruntime
   2797293 ±  0%     -22.4%    2171180 ±  1%  sched_debug.cfs_rq[6]:/.min_vruntime
   2067716 ±  4%     -19.8%    1659081 ±  2%  sched_debug.cfs_rq[41]:/.min_vruntime
       183 ±  4%     -21.3%        144 ± 11%  sched_debug.cfs_rq[46]:/.tg_runnable_contrib
      8446 ±  4%     -21.6%       6624 ± 11%  sched_debug.cfs_rq[46]:/.avg->runnable_avg_sum
   2068500 ±  4%     -19.5%    1665943 ±  2%  sched_debug.cfs_rq[43]:/.min_vruntime
   2064957 ±  4%     -19.1%    1669565 ±  1%  sched_debug.cfs_rq[42]:/.min_vruntime
     84917 ±  9%     -16.7%      70727 ±  3%  sched_debug.cpu#27.nr_load_updates
     49411 ±  1%     -22.9%      38114 ±  4%  sched_debug.cfs_rq[40]:/.exec_clock
   2097900 ±  4%     -19.4%    1690936 ±  2%  sched_debug.cfs_rq[40]:/.min_vruntime
      3.13 ± 12%     +46.1%       4.57 ±  1%  perf-profile.cpu-cycles.cpu_startup_entry.start_secondary
    102310 ± 10%     -14.3%      87646 ±  3%  sched_debug.cfs_rq[12]:/.exec_clock
      3.15 ± 12%     +46.0%       4.59 ±  1%  perf-profile.cpu-cycles.start_secondary
       625 ±  1%     -23.5%        478 ±  4%  sched_debug.cfs_rq[5]:/.tg_runnable_contrib
      1.34 ± 12%     +45.0%       1.95 ±  3%  perf-profile.cpu-cycles.cpuidle_enter.cpu_startup_entry.start_secondary
      5393 ±  4%     -17.7%       4439 ± 12%  numa-vmstat.node0.nr_anon_pages
     21562 ±  4%     -17.5%      17782 ± 12%  numa-meminfo.node0.AnonPages
   2670003 ±  1%     -21.2%    2104927 ±  2%  sched_debug.cfs_rq[16]:/.min_vruntime
     28696 ±  1%     -23.6%      21938 ±  4%  sched_debug.cfs_rq[5]:/.avg->runnable_avg_sum
     86063 ±  5%     -18.8%      69919 ±  3%  sched_debug.cpu#34.nr_load_updates
       676 ±  2%     -28.5%        483 ± 20%  sched_debug.cpu#46.ttwu_local
      0.98 ± 15%     +46.9%       1.44 ±  0%  perf-profile.cpu-cycles.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.start_secondary
      0.92 ± 15%     +46.4%       1.34 ±  1%  perf-profile.cpu-cycles.intel_idle.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.start_secondary
        18 ± 18%     +48.6%         27 ±  5%  sched_debug.cfs_rq[20]:/.load
   2616968 ±  2%     -19.7%    2100626 ±  1%  sched_debug.cfs_rq[17]:/.min_vruntime
     88866 ±  6%     -15.5%      75092 ±  3%  sched_debug.cfs_rq[16]:/.exec_clock
      5.32 ± 23%     +56.5%       8.34 ±  2%  turbostat.%c6
     83944 ±  6%     -17.1%      69586 ±  1%  sched_debug.cpu#25.nr_load_updates
     96567 ±  7%     -16.2%      80964 ±  2%  sched_debug.cfs_rq[6]:/.exec_clock
      2337 ±  4%     -17.8%       1922 ± 12%  sched_debug.cpu#8.curr->pid
       644 ±  2%     -18.4%        526 ±  4%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
       173 ± 10%     -19.0%        140 ± 10%  sched_debug.cfs_rq[40]:/.tg_runnable_contrib
        17 ±  8%     +37.1%         24 ± 12%  sched_debug.cpu#21.cpu_load[4]
        18 ±  5%     +29.2%         23 ± 13%  sched_debug.cpu#21.cpu_load[3]
     29479 ±  2%     -18.3%      24085 ±  4%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
      2312 ±  4%     -27.3%       1680 ± 16%  sched_debug.cpu#17.curr->pid
      7988 ± 10%     -19.0%       6468 ± 10%  sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum
        30 ±  1%     +36.9%         41 ± 27%  sched_debug.cpu#5.load
    442320 ± 20%     +50.1%     663933 ±  3%  sched_debug.cpu#4.sched_goidle
        18 ± 29%     +58.1%         29 ±  2%  sched_debug.cpu#7.cpu_load[3]
        18 ± 33%     +63.9%         29 ±  3%  sched_debug.cpu#7.cpu_load[2]
    431501 ± 36%     +65.8%     715220 ±  9%  sched_debug.cpu#27.avg_idle
     83829 ±  5%     -15.7%      70681 ±  1%  sched_debug.cpu#26.nr_load_updates
    889245 ± 20%     +49.7%    1331482 ±  4%  sched_debug.cpu#4.nr_switches
   3472067 ±  5%     -16.8%    2889475 ±  3%  numa-meminfo.node0.MemFree
       591 ±  3%     -18.0%        485 ±  5%  sched_debug.cfs_rq[13]:/.tg_runnable_contrib
     83450 ±  3%     -17.9%      68547 ±  2%  sched_debug.cpu#35.nr_load_updates
   2571432 ±  1%     -17.6%    2119533 ±  1%  sched_debug.cfs_rq[18]:/.min_vruntime
     27116 ±  3%     -17.9%      22268 ±  5%  sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
     82841 ±  5%     -15.4%      70118 ±  2%  sched_debug.cpu#24.nr_load_updates
      1.82 ± 11%     +35.2%       2.47 ±  0%  perf-profile.cpu-cycles.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead.filemap_fault
      1.81 ± 11%     +35.7%       2.46 ±  0%  perf-profile.cpu-cycles.mpage_readpages.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead
    867184 ±  5%     -15.0%     736731 ±  2%  numa-vmstat.node0.nr_free_pages
       555 ±  8%     -21.3%        436 ± 17%  sched_debug.cfs_rq[4]:/.tg_runnable_contrib
    924672 ± 19%     +47.3%    1362330 ±  3%  sched_debug.cpu#4.sched_count
      1.21 ± 18%     +44.6%       1.74 ±  0%  perf-profile.cpu-cycles.do_mpage_readpage.mpage_readpages.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead
     25390 ±  8%     -21.1%      20035 ± 17%  sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum
   2557617 ±  0%     -17.2%    2118082 ±  1%  sched_debug.cfs_rq[19]:/.min_vruntime
    351375 ±  1%     -12.9%     306106 ±  6%  softirqs.SCHED
      2370 ±  6%     -13.2%       2058 ±  6%  sched_debug.cpu#13.curr->pid
     91070 ±  7%     -12.8%      79415 ±  2%  sched_debug.cfs_rq[8]:/.exec_clock
     95294 ±  4%     -14.1%      81823 ±  0%  sched_debug.cfs_rq[5]:/.exec_clock
    238317 ±  5%     -30.9%     164683 ± 34%  sched_debug.cpu#6.avg_idle
     83424 ±  2%     -16.2%      69867 ±  2%  sched_debug.cpu#33.nr_load_updates
      8294 ±  2%     -23.4%       6355 ± 18%  sched_debug.cfs_rq[33]:/.avg->runnable_avg_sum
       180 ±  2%     -23.2%        138 ± 18%  sched_debug.cfs_rq[33]:/.tg_runnable_contrib
     95628 ±  4%     -14.2%      82063 ±  1%  sched_debug.cfs_rq[7]:/.exec_clock
    131027 ±  4%     -11.9%     115387 ±  1%  sched_debug.cpu#14.nr_load_updates
    398962 ± 35%     +58.2%     631265 ±  2%  sched_debug.cpu#19.ttwu_count
    133714 ±  5%     -11.4%     118513 ±  0%  sched_debug.cpu#3.nr_load_updates
     85431 ±  5%     -12.5%      74779 ±  1%  sched_debug.cfs_rq[17]:/.exec_clock
     78487 ±  3%     -12.9%      68362 ±  3%  sched_debug.cpu#36.nr_load_updates
       572 ±  1%     -18.1%        468 ±  9%  sched_debug.cfs_rq[8]:/.tg_runnable_contrib
    135275 ±  3%     -12.7%     118072 ±  0%  sched_debug.cpu#2.nr_load_updates
     26171 ±  1%     -17.8%      21516 ±  9%  sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
        30 ±  6%     -11.7%         26 ± 10%  sched_debug.cpu#5.cpu_load[4]
    131222 ±  5%     -11.6%     116049 ±  0%  sched_debug.cpu#15.nr_load_updates
 4.739e+09 ±  3%     -13.1%  4.119e+09 ±  2%  cpuidle.C1-IVT.time
        32 ±  3%     +25.8%         40 ± 10%  sched_debug.cpu#8.load
    486160 ±  8%     +28.9%     626649 ±  3%  sched_debug.cpu#13.ttwu_count
     79004 ±  2%     -13.1%      68621 ±  2%  sched_debug.cpu#37.nr_load_updates
     78588 ±  3%     -11.5%      69531 ±  2%  sched_debug.cpu#39.nr_load_updates
        97 ±  2%     -20.4%         77 ± 10%  sched_debug.cfs_rq[16]:/.tg_load_contrib
      2.50 ± 30%     +53.0%       3.82 ±  0%  perf-profile.cpu-cycles.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.do_unit
      2233 ±  4%     -15.2%       1893 ± 14%  sched_debug.cpu#5.curr->pid
      2.79 ± 29%     +51.9%       4.24 ±  0%  perf-profile.cpu-cycles.smp_call_function_interrupt.call_function_interrupt.do_unit
    410822 ± 32%     +53.0%     628526 ±  3%  sched_debug.cpu#17.ttwu_count
      2.17 ± 30%     +51.0%       3.27 ±  0%  perf-profile.cpu-cycles.flush_smp_call_function_queue.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.do_unit
      6181 ±  2%     -14.9%       5262 ±  8%  numa-vmstat.node0.nr_active_anon
    378032 ± 30%     +50.5%     568832 ±  2%  sched_debug.cpu#6.ttwu_count
      4.48 ± 29%     +50.2%       6.74 ±  0%  perf-profile.cpu-cycles.call_function_interrupt.do_unit.runtime_exceeded
     78723 ±  2%     -11.9%      69385 ±  2%  sched_debug.cpu#46.nr_load_updates
        19 ± 28%     +47.4%         28 ±  2%  sched_debug.cpu#7.cpu_load[4]
     24780 ±  2%     -14.8%      21123 ±  8%  numa-meminfo.node0.Active(anon)
     79208 ±  2%     -12.5%      69275 ±  1%  sched_debug.cpu#43.nr_load_updates
      1001 ±  0%     -12.8%        873 ±  2%  proc-vmstat.nr_isolated_file
    122398 ±  5%      -8.0%     112589 ±  1%  sched_debug.cpu#0.nr_load_updates
       838 ±  4%     -26.7%        614 ± 26%  sched_debug.cpu#32.curr->pid
     52.08 ±  1%     +16.7%      60.80 ±  0%  turbostat.%c1
     78330 ±  1%     -12.2%      68759 ±  2%  sched_debug.cpu#45.nr_load_updates
     78994 ±  1%     -12.4%      69228 ±  1%  sched_debug.cpu#44.nr_load_updates
     77859 ±  1%     -10.3%      69825 ±  3%  sched_debug.cpu#47.nr_load_updates
      9588 ±  3%     +17.7%      11289 ±  0%  uptime.idle
     77946 ±  1%     -11.6%      68910 ±  1%  sched_debug.cpu#42.nr_load_updates
        29 ±  1%     +22.0%         36 ± 14%  sched_debug.cfs_rq[8]:/.load
     79172 ±  1%     -10.3%      71045 ±  1%  sched_debug.cpu#38.nr_load_updates
     78525 ±  1%     -11.3%      69640 ±  2%  sched_debug.cpu#41.nr_load_updates
    552379 ±  3%      -7.4%     511740 ±  0%  meminfo.Committed_AS
     78896 ±  1%     -10.5%      70631 ±  2%  sched_debug.cpu#40.nr_load_updates
    659571 ±  6%     +18.5%     781765 ±  4%  sched_debug.cpu#44.avg_idle
      2200 ± 16%     -67.7%        710 ±  6%  time.system_time
     77502 ± 10%     -43.3%      43925 ±  5%  time.involuntary_context_switches
     42.57 ±  5%     -27.6%      30.82 ±  0%  turbostat.%c0
      1933 ±  5%     -25.6%       1437 ±  0%  time.percent_of_cpu_this_job_got
   1325078 ±  3%     -21.2%    1044202 ±  0%  vmstat.system.in
       138 ±  2%      -9.3%        125 ±  0%  turbostat.Cor_W
       171 ±  1%      -7.5%        159 ±  0%  turbostat.Pkg_W
  30073157 ±  3%      +4.7%   31478827 ±  0%  time.voluntary_context_switches
      3758 ±  0%      -1.1%       3717 ±  0%  time.user_time


ivb43: Ivytown Ivy Bridge-EP
Memory: 64G


                                   unixbench.score

  12000 ++------------------------------------------------------------------+
        |                                     .*      *..   .*..            |
  11800 *+*..*.*..*.*..*.*.*..     *.    .*.*.  +    :   *.*    *.*..*.*.. .*
        |                         +  *..*        *.. :                    * |
  11600 ++                    *. +                  *                       |
        |                       *                                           |
  11400 ++                    O O  O O  O O O  O                            |
        |                                                                   |
  11200 ++                                                                  |
        | O                                      O                          |
  11000 O+   O O  O    O O O                                                |
        |           O                               O    O O O              |
  10800 ++                                                                  |
        |                                             O                     |
  10600 ++------------------------------------------------------------------+


                            time.voluntary_context_switches

  3.5e+06 ++----------------------------------------------------------------+
          |                                                                 |
    3e+06 ++                                           O                    |
          O O  O O O  O      O                      O    O  O O             |
          |             O  O   O  O O O  O O O  O O                         |
  2.5e+06 ++                                                                |
          |                                                                 |
    2e+06 ++                                                                |
          |                                                                 |
  1.5e+06 ++                                                                |
          |                                                                 |
          |                                                                 |
    1e+06 ++                                                                |
          *.*..*.*.*..*.*..*.*.*.. .*.*..*.*.*..*.*.  .*.*..*.*.*..*.*.*..*.*
   500000 ++----------------------*-----------------*-----------------------+


                                  vmstat.system.cs

  105000 ++-----------------------------------------------------------------+
         O O       O        O      O  O O  O O      O O  O O  O             |
         |    O O    O O  O    O O             O  O                         |
  100000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   95000 ++                                                                 |
         |                                                                  |
   90000 ++                                                                 |
         |                                                                  |
         |                                              .*.  .*.            |
   85000 *+*..*.*..*.*.*..*.*..    *..*.*..*.*.*..*. .*.   *.   *.*..*.*..*.*
         |                     *. +                 *                       |
         |                       *                                          |
   80000 ++-----------------------------------------------------------------+



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


--=-qx4GqOMEEGEvpm1fVi4Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: unixbench
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
commit: b7392d2247cfe6771f95d256374f1a8e6a6f48d6
model: Grantley Haswell
nr_cpu: 16
memory: 16G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
unixbench:
  test:
  - execl
testbox: lituya
tbox_group: lituya
kconfig: x86_64-rhel
enqueue_time: 2014-12-18 17:52:11.459479684 +08:00
head_commit: d5d2fd7af896451b86227a0847b54976d87d13f3
base_commit: b7392d2247cfe6771f95d256374f1a8e6a6f48d6
branch: linux-devel/devel-hourly-2014123019
kernel: "/kernel/x86_64-rhel/b7392d2247cfe6771f95d256374f1a8e6a6f48d6/vmlinuz-3.19.0-rc2-gb7392d2"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lituya/unixbench/performance-execl/debian-x86_64.cgz/x86_64-rhel/b7392d2247cfe6771f95d256374f1a8e6a6f48d6/0"
job_file: "/lkp/scheduled/lituya/cyclic_unixbench-performance-execl-x86_64-rhel-BASE-b7392d2247cfe6771f95d256374f1a8e6a6f48d6-0.yaml"
dequeue_time: 2014-12-30 19:49:21.919663379 +08:00
job_state: finished
loadavg: 9.26 3.82 1.42 1/164 5138
start_time: '1419940190'
end_time: '1419940388'
version: "/lkp/lkp/.src-20141230-091833"

--=-qx4GqOMEEGEvpm1fVi4Z
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
./Run execl

--=-qx4GqOMEEGEvpm1fVi4Z
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-qx4GqOMEEGEvpm1fVi4Z--

