Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaLQISa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:18:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:5404 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaLQIS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:18:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="430041631"
Message-ID: <1418804307.5745.252.camel@intel.com>
Subject: [LKP] [mm] 1306a85aed3: +5.8% will-it-scale.per_thread_ops
From: Huang Ying <ying.huang@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Wed, 17 Dec 2014 16:18:27 +0800
Content-Type: multipart/mixed; boundary="=-cU5Y7/kwFUCfS2Rvc6AN"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cU5Y7/kwFUCfS2Rvc6AN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 1306a85aed3ec3db98945aafb7dfbe5648a1203c ("mm: embed the memcg pointer directly into struct page")


testbox/testcase/testparams: lkp-snb01/will-it-scale/performance-page_fault2

22811c6bc3c764d8  1306a85aed3ec3db98945aafb7  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
    185591 ±  0%      +5.8%     196339 ±  0%  will-it-scale.per_thread_ops
    268066 ±  0%      +4.2%     279258 ±  0%  will-it-scale.per_process_ops
     66204 ± 47%     -79.9%      13282 ±  6%  sched_debug.cpu#14.sched_count
       726 ± 12%    -100.0%          0 ±  0%  slabinfo.blkdev_requests.num_objs
       726 ± 12%    -100.0%          0 ±  0%  slabinfo.blkdev_requests.active_objs
       282 ± 11%     -86.2%         39 ±  0%  slabinfo.bdev_cache.num_objs
       282 ± 11%     -86.2%         39 ±  0%  slabinfo.bdev_cache.active_objs
       536 ± 10%     -92.7%         39 ±  0%  slabinfo.blkdev_ioc.num_objs
       536 ± 10%     -92.7%         39 ±  0%  slabinfo.blkdev_ioc.active_objs
       745 ± 13%     -93.0%         52 ± 34%  slabinfo.xfs_buf.num_objs
      1.35 ±  2%     -97.0%       0.04 ± 17%  perf-profile.cpu-cycles.mem_cgroup_page_lruvec.release_pages.free_pages_and_swap_cache.tlb_flush_mmu_free.unmap_page_range
     70832 ±  7%     -84.6%      10928 ±  0%  meminfo.DirectMap4k
       745 ± 13%     -93.0%         52 ± 34%  slabinfo.xfs_buf.active_objs
        20 ± 34%    +173.8%         54 ± 38%  sched_debug.cfs_rq[25]:/.runnable_load_avg
        21 ± 32%    +163.5%         56 ± 37%  sched_debug.cfs_rq[25]:/.load
        21 ± 32%    +163.5%         56 ± 37%  sched_debug.cpu#25.load
      6.68 ±  2%     -69.0%       2.07 ±  4%  perf-profile.cpu-cycles.lru_cache_add_active_or_unevictable.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault
     11481 ± 40%     -60.4%       4550 ± 24%  sched_debug.cpu#31.sched_count
     35880 ± 29%     -54.4%      16355 ± 20%  sched_debug.cpu#8.sched_count
        30 ± 44%     +90.8%         57 ± 34%  sched_debug.cpu#25.cpu_load[0]
       258 ± 42%     -58.4%        107 ± 21%  sched_debug.cfs_rq[20]:/.blocked_load_avg
       615 ± 47%     -55.8%        271 ± 18%  sched_debug.cpu#22.ttwu_local
        24 ± 36%     +81.6%         44 ± 26%  sched_debug.cpu#25.cpu_load[1]
     31132 ± 41%     -47.8%      16259 ± 47%  sched_debug.cpu#13.sched_count
       287 ± 37%     -53.0%        135 ± 18%  sched_debug.cfs_rq[20]:/.tg_load_contrib
      2755 ± 22%     +79.7%       4950 ± 36%  sched_debug.cpu#8.ttwu_local
         9 ± 22%     +69.2%         16 ± 31%  sched_debug.cpu#14.cpu_load[0]
      8626 ± 14%     -46.4%       4621 ± 32%  sched_debug.cpu#0.ttwu_local
        37 ± 44%     -43.6%         21 ± 22%  sched_debug.cpu#31.cpu_load[1]
       390 ± 13%     -45.3%        213 ± 16%  sched_debug.cfs_rq[25]:/.blocked_load_avg
        14 ± 24%     -40.4%          8 ± 25%  sched_debug.cpu#13.cpu_load[0]
    309688 ± 24%     -44.8%     170966 ± 34%  sched_debug.cfs_rq[18]:/.spread0
       410 ± 13%     -34.6%        268 ±  7%  sched_debug.cfs_rq[25]:/.tg_load_contrib
        20 ± 30%     +64.6%         33 ± 17%  sched_debug.cpu#25.cpu_load[2]
    370117 ±  6%     -43.0%     210857 ± 45%  sched_debug.cfs_rq[17]:/.spread0
        28 ± 29%     -34.2%         18 ± 10%  sched_debug.cpu#31.cpu_load[2]
     16558 ± 28%     -40.9%       9784 ± 11%  sched_debug.cfs_rq[8]:/.exec_clock
      8517 ± 15%     -32.9%       5715 ±  9%  sched_debug.cpu#20.sched_count
      2301 ± 29%     +68.2%       3871 ± 17%  sched_debug.cpu#29.ttwu_count
        13 ± 17%     -35.8%          8 ± 26%  sched_debug.cfs_rq[13]:/.runnable_load_avg
      2317 ±  6%     -26.5%       1703 ± 18%  sched_debug.cpu#13.curr->pid
      2470 ± 12%     -23.3%       1893 ± 12%  sched_debug.cpu#15.curr->pid
        12 ± 14%     -28.0%          9 ±  7%  sched_debug.cpu#13.cpu_load[3]
    330696 ± 22%     -35.6%     212829 ±  5%  sched_debug.cfs_rq[8]:/.min_vruntime
        42 ± 38%     -43.8%         23 ± 15%  sched_debug.cpu#24.cpu_load[0]
      2556 ±  6%     +42.8%       3649 ±  9%  sched_debug.cpu#25.curr->pid
        33 ± 33%     -34.6%         21 ±  3%  sched_debug.cfs_rq[5]:/.load
        33 ± 33%     -33.1%         22 ±  7%  sched_debug.cpu#5.load
      3595 ± 17%     -25.0%       2697 ±  5%  sched_debug.cpu#17.ttwu_count
     24718 ± 15%     -27.3%      17972 ± 13%  sched_debug.cpu#0.nr_switches
        18 ± 25%     +45.2%         26 ± 10%  sched_debug.cpu#25.cpu_load[3]
      7788 ± 16%     -24.8%       5857 ±  5%  sched_debug.cpu#17.nr_switches
        17 ± 12%     +31.4%         23 ± 17%  sched_debug.cpu#1.cpu_load[3]
        18 ± 10%     +33.3%         24 ± 16%  sched_debug.cpu#1.cpu_load[2]
      6091 ±  5%     -26.8%       4460 ± 25%  sched_debug.cpu#31.nr_switches
      3956 ± 15%     -28.8%       2816 ± 16%  sched_debug.cpu#31.ttwu_count
      4.82 ±  1%     -24.3%       3.65 ±  1%  perf-profile.cpu-cycles.release_pages.free_pages_and_swap_cache.tlb_flush_mmu_free.unmap_page_range.unmap_single_vma
        13 ±  9%     -26.9%          9 ± 11%  sched_debug.cpu#13.cpu_load[2]
      3327 ± 11%     -20.2%       2655 ± 11%  sched_debug.cpu#4.curr->pid
      4.91 ±  1%     -23.8%       3.74 ±  1%  perf-profile.cpu-cycles.tlb_flush_mmu_free.unmap_page_range.unmap_single_vma.unmap_vmas.unmap_region
      4.91 ±  1%     -23.7%       3.74 ±  1%  perf-profile.cpu-cycles.free_pages_and_swap_cache.tlb_flush_mmu_free.unmap_page_range.unmap_single_vma.unmap_vmas
        36 ±  8%     -22.9%         27 ±  7%  sched_debug.cpu#17.cpu_load[0]
      1.74 ±  2%     -22.8%       1.34 ±  2%  perf-profile.cpu-cycles.unlock_page.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault
        17 ± 21%     +33.8%         22 ±  7%  sched_debug.cpu#25.cpu_load[4]
    347045 ±  0%     -20.8%     274703 ±  0%  meminfo.Inactive(file)
     86761 ±  0%     -20.8%      68676 ±  0%  proc-vmstat.nr_inactive_file
     42941 ±  0%     -20.7%      34065 ±  1%  numa-vmstat.node0.nr_inactive_file
    171765 ±  0%     -20.7%     136260 ±  1%  numa-meminfo.node0.Inactive(file)
    175280 ±  0%     -21.0%     138443 ±  1%  numa-meminfo.node1.Inactive(file)
     43819 ±  0%     -21.0%      34611 ±  1%  numa-vmstat.node1.nr_inactive_file
     14245 ± 13%     -28.8%      10144 ± 18%  sched_debug.cpu#0.ttwu_count
     34770 ± 14%     +29.3%      44960 ± 18%  sched_debug.cfs_rq[1]:/.exec_clock
      1.23 ±  1%     +23.8%       1.52 ±  2%  perf-profile.cpu-cycles._raw_spin_lock.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_vma.do_cow_fault
        17 ± 21%     +23.5%         21 ±  7%  sched_debug.cpu#29.cpu_load[3]
        32 ±  5%     -12.2%         28 ±  8%  sched_debug.cpu#21.cpu_load[1]
        35 ±  9%     -19.1%         28 ±  8%  sched_debug.cpu#17.cpu_load[1]
     10608 ±  2%     -17.2%       8783 ±  4%  numa-vmstat.node0.nr_active_file
     42435 ±  2%     -17.2%      35136 ±  4%  numa-meminfo.node0.Active(file)
     63836 ±  0%     -16.9%      53045 ±  0%  numa-vmstat.node1.numa_interleave
     53212 ±  0%     -16.3%      44533 ±  0%  numa-vmstat.node0.numa_interleave
     84165 ±  0%     -16.2%      70563 ±  0%  meminfo.Active(file)
     21040 ±  0%     -16.2%      17640 ±  0%  proc-vmstat.nr_active_file
      6709 ±  0%     +18.4%       7944 ±  3%  sched_debug.cfs_rq[20]:/.tg_load_avg
      6711 ±  0%     +18.5%       7950 ±  3%  sched_debug.cfs_rq[21]:/.tg_load_avg
     35768 ±  9%     -15.0%      30418 ±  8%  sched_debug.cpu#8.nr_load_updates
      6714 ±  0%     +18.4%       7946 ±  3%  sched_debug.cfs_rq[22]:/.tg_load_avg
      6717 ±  0%     +18.0%       7924 ±  3%  sched_debug.cfs_rq[18]:/.tg_load_avg
      6712 ±  0%     +17.9%       7910 ±  3%  sched_debug.cfs_rq[19]:/.tg_load_avg
      6688 ±  1%     +17.9%       7883 ±  2%  sched_debug.cfs_rq[23]:/.tg_load_avg
        33 ±  5%     -16.5%         27 ±  2%  sched_debug.cpu#21.cpu_load[0]
      6893 ±  0%     +17.4%       8092 ±  3%  sched_debug.cfs_rq[7]:/.tg_load_avg
      6988 ±  1%     +15.6%       8078 ±  4%  sched_debug.cfs_rq[0]:/.tg_load_avg
      6577 ±  1%     +18.0%       7760 ±  3%  sched_debug.cfs_rq[30]:/.tg_load_avg
      6982 ±  1%     +16.1%       8105 ±  3%  sched_debug.cfs_rq[3]:/.tg_load_avg
      6875 ±  0%     +17.6%       8085 ±  3%  sched_debug.cfs_rq[8]:/.tg_load_avg
      6579 ±  1%     +17.8%       7748 ±  3%  sched_debug.cfs_rq[29]:/.tg_load_avg
      7016 ±  1%     +15.2%       8083 ±  4%  sched_debug.cfs_rq[1]:/.tg_load_avg
      6873 ±  0%     +17.0%       8042 ±  3%  sched_debug.cfs_rq[9]:/.tg_load_avg
      7005 ±  1%     +15.4%       8084 ±  3%  sched_debug.cfs_rq[2]:/.tg_load_avg
        34 ±  5%     -13.9%         29 ±  6%  sched_debug.cpu#20.cpu_load[0]
      6737 ±  1%     +17.6%       7922 ±  3%  sched_debug.cfs_rq[17]:/.tg_load_avg
      6742 ±  1%     +17.4%       7912 ±  3%  sched_debug.cfs_rq[16]:/.tg_load_avg
      6575 ±  1%     +17.4%       7720 ±  3%  sched_debug.cfs_rq[31]:/.tg_load_avg
      8.09 ±  1%     -13.8%       6.97 ±  0%  perf-profile.cpu-cycles.munmap
      8.08 ±  1%     -13.7%       6.97 ±  0%  perf-profile.cpu-cycles.system_call_fastpath.munmap
        27 ±  6%      -9.0%         25 ±  4%  sched_debug.cfs_rq[23]:/.runnable_load_avg
      8.07 ±  1%     -13.8%       6.96 ±  0%  perf-profile.cpu-cycles.do_munmap.vm_munmap.sys_munmap.system_call_fastpath.munmap
      8.07 ±  1%     -13.8%       6.95 ±  0%  perf-profile.cpu-cycles.unmap_region.do_munmap.vm_munmap.sys_munmap.system_call_fastpath
      8.08 ±  1%     -13.8%       6.97 ±  0%  perf-profile.cpu-cycles.vm_munmap.sys_munmap.system_call_fastpath.munmap
      8.08 ±  1%     -13.8%       6.97 ±  0%  perf-profile.cpu-cycles.sys_munmap.system_call_fastpath.munmap
      6939 ±  1%     +16.4%       8080 ±  3%  sched_debug.cfs_rq[6]:/.tg_load_avg
      6710 ±  1%     +16.4%       7812 ±  3%  sched_debug.cfs_rq[24]:/.tg_load_avg
      6653 ±  1%     +17.0%       7783 ±  3%  sched_debug.cfs_rq[26]:/.tg_load_avg
    622401 ±  4%     +15.2%     717037 ± 11%  sched_debug.cfs_rq[1]:/.min_vruntime
      1504 ±  1%     -13.6%       1300 ±  7%  slabinfo.sock_inode_cache.active_objs
        30 ±  8%     -15.4%         26 ±  5%  sched_debug.cpu#23.load
      1504 ±  1%     -13.6%       1300 ±  7%  slabinfo.sock_inode_cache.num_objs
        30 ±  8%     -15.4%         26 ±  5%  sched_debug.cfs_rq[23]:/.load
      7.46 ±  0%     -13.3%       6.47 ±  0%  perf-profile.cpu-cycles.unmap_vmas.unmap_region.do_munmap.vm_munmap.sys_munmap
      7.46 ±  0%     -13.3%       6.47 ±  0%  perf-profile.cpu-cycles.unmap_single_vma.unmap_vmas.unmap_region.do_munmap.vm_munmap
      5.11 ±  1%     +15.5%       5.90 ±  0%  perf-profile.cpu-cycles.__list_del_entry.list_del.__rmqueue.get_page_from_freelist.__alloc_pages_nodemask
      6887 ±  0%     +16.0%       7986 ±  3%  sched_debug.cfs_rq[10]:/.tg_load_avg
      6645 ±  2%     +17.1%       7783 ±  3%  sched_debug.cfs_rq[25]:/.tg_load_avg
      7.40 ±  0%     -13.4%       6.41 ±  0%  perf-profile.cpu-cycles.unmap_page_range.unmap_single_vma.unmap_vmas.unmap_region.do_munmap
      5.16 ±  1%     +15.7%       5.96 ±  0%  perf-profile.cpu-cycles.list_del.__rmqueue.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_vma
    687523 ±  2%     +11.9%     769461 ±  4%  sched_debug.cfs_rq[0]:/.min_vruntime
      6834 ±  0%     +16.8%       7979 ±  3%  sched_debug.cfs_rq[14]:/.tg_load_avg
      6885 ±  0%     +16.1%       7996 ±  3%  sched_debug.cfs_rq[12]:/.tg_load_avg
      6894 ±  0%     +16.1%       8005 ±  3%  sched_debug.cfs_rq[11]:/.tg_load_avg
      6803 ±  1%     +16.2%       7901 ±  3%  sched_debug.cfs_rq[15]:/.tg_load_avg
      6963 ±  1%     +16.1%       8087 ±  3%  sched_debug.cfs_rq[5]:/.tg_load_avg
      6841 ±  0%     +16.8%       7991 ±  3%  sched_debug.cfs_rq[13]:/.tg_load_avg
      5.64 ±  1%     +14.8%       6.48 ±  0%  perf-profile.cpu-cycles.__rmqueue.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_vma.do_cow_fault
       403 ±  7%     +13.6%        458 ±  6%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
      6967 ±  1%     +15.9%       8078 ±  3%  sched_debug.cfs_rq[4]:/.tg_load_avg
     18553 ±  7%     +13.6%      21084 ±  6%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
      6645 ±  1%     +16.7%       7755 ±  3%  sched_debug.cfs_rq[27]:/.tg_load_avg
      8.77 ±  0%     +14.1%      10.00 ±  0%  perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_vma.do_cow_fault.handle_mm_fault
     37777 ± 12%     +20.6%      45541 ±  2%  sched_debug.cfs_rq[24]:/.exec_clock
     67160 ±  8%     -12.5%      58785 ±  8%  sched_debug.cfs_rq[18]:/.exec_clock
      6641 ±  2%     +16.6%       7742 ±  3%  sched_debug.cfs_rq[28]:/.tg_load_avg
        35 ±  9%     -17.0%         29 ± 10%  sched_debug.cpu#17.cpu_load[2]
        34 ±  9%     -13.7%         30 ±  9%  sched_debug.cpu#17.cpu_load[3]
      9.53 ±  0%     +12.7%      10.74 ±  0%  perf-profile.cpu-cycles.__alloc_pages_nodemask.alloc_pages_vma.do_cow_fault.handle_mm_fault.__do_page_fault
     10.08 ±  0%     +12.5%      11.34 ±  0%  perf-profile.cpu-cycles.alloc_pages_vma.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault
     41728 ±  2%     -15.1%      35425 ±  4%  numa-meminfo.node1.Active(file)
     10431 ±  2%     -15.1%       8856 ±  4%  numa-vmstat.node1.nr_active_file
     19883 ±  0%     -10.0%      17893 ±  1%  slabinfo.radix_tree_node.num_objs
      7.52 ±  1%     +11.3%       8.37 ±  1%  perf-profile.cpu-cycles._raw_spin_lock.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault
     14873 ±  5%     -11.0%      13243 ±  6%  sched_debug.cpu#14.nr_switches
        56 ±  3%      -7.1%         52 ±  6%  sched_debug.cpu#16.cpu_load[2]
     19817 ±  0%      -9.9%      17856 ±  0%  slabinfo.radix_tree_node.active_objs
     49459 ± 10%     +14.7%      56743 ±  2%  sched_debug.cpu#25.nr_load_updates
    741856 ± 10%     +16.5%     864387 ±  2%  sched_debug.cfs_rq[24]:/.min_vruntime
     31.79 ±  0%      -9.3%      28.84 ±  0%  perf-profile.cpu-cycles.do_cow_fault.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
     47.90 ±  1%     +16.9%      55.99 ±  2%  time.user_time
    238256 ±  0%      +8.4%     258184 ±  0%  time.voluntary_context_switches
 2.015e+08 ±  0%      +8.4%  2.184e+08 ±  0%  time.minor_page_faults
       476 ±  0%      +5.9%        504 ±  0%  time.percent_of_cpu_this_job_got
      1441 ±  0%      +5.5%       1520 ±  0%  time.system_time
     40.26 ±  0%      +2.0%      41.04 ±  0%  turbostat.%c0

lkp-snb01: Sandy Bridge-EP
Memory: 32G




                                time.minor_page_faults

  2.5e+08 ++----------------------------------------------------------------+
          |                                                                 |
          O O O O O O   O  O O O O O O O O O O O O O O O O  O O O O O O O O O
    2e+08 *+*.*.*.*.*.*.*..*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*..*.*.*.*.*.*.*.* |
          |                                                                 |
          |                                                                 |
  1.5e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
    5e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
        0 ++----------O-----------------------------------------------------+

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


--=-cU5Y7/kwFUCfS2Rvc6AN
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
commit: 0d8e01273cef9529f77af199b1b7de51a7a294c5
model: Sandy Bridge-EP
memory: 32G
hdd_partitions: "/dev/sda2"
swap_partitions: 
perf-profile:
  freq: 800
will-it-scale:
  test:
  - page_fault2
testbox: lkp-snb01
tbox_group: lkp-snb01
kconfig: x86_64-rhel
enqueue_time: 2014-12-13 19:19:16.931955151 +08:00
head_commit: 0d8e01273cef9529f77af199b1b7de51a7a294c5
base_commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
branch: linux-devel/devel-hourly-2014121307
kernel: "/kernel/x86_64-rhel/0d8e01273cef9529f77af199b1b7de51a7a294c5/vmlinuz-3.18.0-g0d8e012"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-snb01/will-it-scale/performance-page_fault2/debian-x86_64.cgz/x86_64-rhel/0d8e01273cef9529f77af199b1b7de51a7a294c5/0"
job_file: "/lkp/scheduled/lkp-snb01/cyclic_will-it-scale-performance-page_fault2-x86_64-rhel-HEAD-0d8e01273cef9529f77af199b1b7de51a7a294c5-0.yaml"
dequeue_time: 2014-12-14 03:40:23.689060918 +08:00
job_state: finished
loadavg: 23.53 12.15 4.88 1/302 10072
start_time: '1418499666'
end_time: '1418499978'
version: "/lkp/lkp/.src-20141213-150527"

--=-cU5Y7/kwFUCfS2Rvc6AN
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
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
./runtest.py page_fault2 25 1 8 16 24 32

--=-cU5Y7/kwFUCfS2Rvc6AN
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-cU5Y7/kwFUCfS2Rvc6AN--

