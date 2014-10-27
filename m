Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaJ0CQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:16:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:24884 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaJ0CQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="yaml'?scan'208";a="621098700"
Date: Mon, 27 Oct 2014 10:16:51 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: LKP <lkp@linux.intel.com>, Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [AHCI] 18dcf433f3d: -3.3% fileio.requests_per_sec
Message-ID: <20141027021651.GF27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 18dcf433f3ded61eb140a55e7048ec2fef79e723 ("AHCI: Optimize single IRQ interrupt processing")


227dfb4dbf109596  18dcf433f3ded61eb140a55e70  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
     61.60 ±  1%      -3.3%      59.56 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     61.60            -3.3%      59.56        GEO-MEAN fileio.requests_per_sec

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    436798 ± 28%     -73.4%     116066 ± 33%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    436798           -73.4%     116066        GEO-MEAN sched_debug.cpu#2.ttwu_local

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     29791 ±  4%     -72.7%       8123 ±  6%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     29791           -72.7%       8123        GEO-MEAN sched_debug.cfs_rq[2]:/.exec_clock

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     26505 ±  3%     -71.1%       7657 ±  6%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     26505           -71.1%       7657        GEO-MEAN sched_debug.cfs_rq[3]:/.exec_clock

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    211746 ± 47%    +122.7%     471499 ± 23%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    211746          +122.7%     471499        GEO-MEAN sched_debug.cpu#3.ttwu_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
        25 ± 38%    +206.3%         77 ± 12%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
        25          +206.3%         77        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_runnable_contrib

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    395023 ± 21%    +179.3%    1103475 ±  9%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    395023          +179.3%    1103475        GEO-MEAN sched_debug.cpu#0.sched_goidle

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     26678 ±  6%    +185.9%      76281 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     26678          +185.9%      76281        GEO-MEAN sched_debug.cfs_rq[0]:/.exec_clock

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    206903 ± 45%    +105.1%     424444 ± 26%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    206903          +105.1%     424444        GEO-MEAN sched_debug.cpu#3.sched_goidle

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    814594 ± 21%    +173.2%    2225796 ±  9%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    814594          +173.2%    2225795        GEO-MEAN sched_debug.cpu#0.nr_switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    815199 ± 21%    +173.2%    2227078 ±  9%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    815198          +173.2%    2227078        GEO-MEAN sched_debug.cpu#0.sched_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1213 ± 36%    +195.3%       3583 ± 12%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      1213          +195.3%       3583        GEO-MEAN sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     29624 ±  6%    +176.5%      81923 ±  1%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     29624          +176.5%      81923        GEO-MEAN sched_debug.cfs_rq[0]:/.min_vruntime

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    193739 ± 46%     +99.9%     387345 ± 15%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    193739           +99.9%     387345        GEO-MEAN sched_debug.cpu#1.sched_goidle

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    482611 ± 24%     -60.5%     190666 ± 19%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    482611           -60.5%     190666        GEO-MEAN sched_debug.cpu#2.sched_goidle

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     31073 ±  4%     -63.6%      11312 ±  2%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     31073           -63.6%      11312        GEO-MEAN sched_debug.cfs_rq[3]:/.min_vruntime

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
        12 ± 33%     -68.3%          4 ± 27%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
        12           -68.3%          4        GEO-MEAN sched_debug.cpu#3.cpu_load[4]

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    440281 ± 42%     +97.4%     869268 ± 25%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    440281           +97.4%     869268        GEO-MEAN sched_debug.cpu#3.nr_switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    440898 ± 42%     +97.2%     869665 ± 25%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    440898           +97.2%     869665        GEO-MEAN sched_debug.cpu#3.sched_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     33967 ±  4%     -63.3%      12450 ±  3%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     33967           -63.3%      12450        GEO-MEAN sched_debug.cfs_rq[2]:/.min_vruntime

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    413955 ± 43%     +93.7%     801767 ± 14%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    413955           +93.7%     801767        GEO-MEAN sched_debug.cpu#1.nr_switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    414509 ± 43%     +93.5%     802162 ± 14%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    414509           +93.5%     802162        GEO-MEAN sched_debug.cpu#1.sched_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    991210 ± 24%     -57.1%     425186 ± 17%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    991210           -57.1%     425186        GEO-MEAN sched_debug.cpu#2.nr_switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    991832 ± 24%     -57.1%     425587 ± 17%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    991831           -57.1%     425587        GEO-MEAN sched_debug.cpu#2.sched_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       437 ± 14%     -59.6%        176 ± 27%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
       539 ±  7%     -50.6%        266 ±  7%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       485           -55.3%        217        GEO-MEAN slabinfo.xfs_buf.active_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       446 ± 14%     -57.7%        188 ± 30%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
       548 ±  6%     -43.9%        307 ±  4%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       494           -51.3%        240        GEO-MEAN slabinfo.xfs_buf.num_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    216837 ± 39%     +85.6%     402550 ± 14%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    216837           +85.6%     402550        GEO-MEAN sched_debug.cpu#1.ttwu_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    496141 ± 24%    +117.8%    1080683 ±  2%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    496141          +117.8%    1080683        GEO-MEAN sched_debug.cpu#2.ttwu_count

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     23697 ±  7%     -51.9%      11404 ±  2%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     23697           -51.9%      11404        GEO-MEAN sched_debug.cfs_rq[1]:/.min_vruntime

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     88762 ±  5%     +94.9%     173015 ±  2%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     88762           +94.9%     173015        GEO-MEAN sched_debug.cpu#0.nr_load_updates

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     21233 ±  8%     -49.3%      10767 ±  5%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     21233           -49.3%      10767        GEO-MEAN sched_debug.cfs_rq[1]:/.exec_clock

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
        14 ± 29%     -51.4%          7 ± 15%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
        14           -51.4%          6        GEO-MEAN sched_debug.cpu#3.cpu_load[3]

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
        44 ± 13%     -45.2%         24 ±  7%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
        44           -45.2%         24        GEO-MEAN sched_debug.cfs_rq[3]:/.tg_runnable_contrib

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      5.00 ± 16%     -31.1%       3.45 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      5.00           -31.1%       3.45        GEO-MEAN perf-profile.cpu-cycles.__writeback_inodes_wb.wb_writeback.bdi_writeback_workfn.process_one_work.worker_thread

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      5.00 ± 16%     -31.6%       3.42 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      5.00           -31.6%       3.42        GEO-MEAN perf-profile.cpu-cycles.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.bdi_writeback_workfn.process_one_work

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.99 ± 16%     -31.6%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.99           -31.6%       3.41        GEO-MEAN perf-profile.cpu-cycles.write_cache_pages.generic_writepages.xfs_vm_writepages.do_writepages.__writeback_single_inode

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.99 ± 16%     -31.6%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.99           -31.6%       3.41        GEO-MEAN perf-profile.cpu-cycles.xfs_vm_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      5.00 ± 16%     -31.1%       3.45 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      5.00           -31.1%       3.45        GEO-MEAN perf-profile.cpu-cycles.wb_writeback.bdi_writeback_workfn.process_one_work.worker_thread.kthread

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.99 ± 16%     -31.6%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.99           -31.6%       3.41        GEO-MEAN perf-profile.cpu-cycles.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.98 ± 16%     -31.4%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.98           -31.4%       3.41        GEO-MEAN perf-profile.cpu-cycles.__writepage.write_cache_pages.generic_writepages.xfs_vm_writepages.do_writepages

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      5.00 ± 16%     -31.7%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      5.00           -31.7%       3.41        GEO-MEAN perf-profile.cpu-cycles.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.bdi_writeback_workfn

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.98 ± 16%     -31.4%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.98           -31.4%       3.41        GEO-MEAN perf-profile.cpu-cycles.xfs_vm_writepage.__writepage.write_cache_pages.generic_writepages.xfs_vm_writepages

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.99 ± 16%     -31.6%       3.41 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.99           -31.6%       3.41        GEO-MEAN perf-profile.cpu-cycles.generic_writepages.xfs_vm_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      5.00 ± 16%     -31.1%       3.45 ± 28%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      5.00           -31.1%       3.45        GEO-MEAN perf-profile.cpu-cycles.bdi_writeback_workfn.process_one_work.worker_thread.kthread.ret_from_fork

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4.02 ± 17%     -37.3%       2.52 ± 32%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      4.02           -37.3%       2.52        GEO-MEAN perf-profile.cpu-cycles.xfs_cluster_write.xfs_vm_writepage.__writepage.write_cache_pages.generic_writepages

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      2071 ± 12%     -43.9%       1162 ±  6%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      2071           -43.9%       1162        GEO-MEAN sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
        13 ± 48%     -42.6%          7 ± 18%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
        13           -42.6%          7        GEO-MEAN sched_debug.cpu#2.cpu_load[3]

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      3.20 ± 19%     -37.6%       1.99 ± 25%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      3.20           -37.6%       1.99        GEO-MEAN perf-profile.cpu-cycles.xfs_convert_page.isra.11.xfs_cluster_write.xfs_vm_writepage.__writepage.write_cache_pages

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
         9 ± 16%     -43.7%          5 ± 49%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
         9           -43.8%          5        GEO-MEAN sched_debug.cfs_rq[0]:/.runnable_load_avg

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       627 ± 12%     +55.9%        978 ±  8%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       627           +55.9%        978        GEO-MEAN slabinfo.btrfs_delayed_tree_ref.num_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       627 ± 12%     +54.9%        972 ±  8%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       627           +54.9%        972        GEO-MEAN slabinfo.btrfs_delayed_tree_ref.active_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      2552 ±  8%     -35.9%       1635 ± 10%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      2552           -35.9%       1635        GEO-MEAN slabinfo.kmalloc-96.active_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      2577 ±  7%     -35.0%       1676 ±  9%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      2577           -35.0%       1676        GEO-MEAN slabinfo.kmalloc-96.num_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       650 ±  5%     -29.7%        457 ±  7%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       649           -29.7%        457        GEO-MEAN slabinfo.blkdev_requests.active_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.17 ± 13%     +24.6%       1.46 ±  8%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.17           +24.6%       1.46        GEO-MEAN perf-profile.cpu-cycles.try_to_release_page.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       664 ±  4%     -26.8%        486 ±  7%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       664           -26.8%        486        GEO-MEAN slabinfo.blkdev_requests.num_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.40 ±  4%     -23.4%       1.07 ±  9%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.40           -23.4%       1.07        GEO-MEAN perf-profile.cpu-cycles.default_idle.arch_cpu_idle.cpu_startup_entry.rest_init.start_kernel

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.40 ±  4%     -22.8%       1.08 ± 10%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.40           -22.8%       1.08        GEO-MEAN perf-profile.cpu-cycles.arch_cpu_idle.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    100710 ±  5%     +28.7%     129619 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    100710           +28.7%     129619        GEO-MEAN sched_debug.cpu#2.nr_load_updates

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      2671 ± 10%     +19.1%       3181 ±  6%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      2671           +19.1%       3181        GEO-MEAN slabinfo.anon_vma.num_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     86107 ±  5%     -21.2%      67836 ±  8%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     86107           -21.2%      67835        GEO-MEAN sched_debug.cpu#3.nr_load_updates

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.57 ±  5%     -15.2%       1.33 ±  9%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.57           -15.2%       1.33        GEO-MEAN perf-profile.cpu-cycles.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.56 ±  5%     -14.5%       1.33 ±  9%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.56           -14.5%       1.33        GEO-MEAN perf-profile.cpu-cycles.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.57 ±  5%     -15.2%       1.33 ±  9%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.57           -15.2%       1.33        GEO-MEAN perf-profile.cpu-cycles.x86_64_start_reservations.x86_64_start_kernel

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.57 ±  5%     -15.2%       1.33 ±  9%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.57           -15.2%       1.33        GEO-MEAN perf-profile.cpu-cycles.x86_64_start_kernel

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1.57 ±  5%     -15.2%       1.33 ±  9%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      1.57           -15.2%       1.33        GEO-MEAN perf-profile.cpu-cycles.start_kernel.x86_64_start_reservations.x86_64_start_kernel

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
        50 ± 32%     -34.0%         33 ±  5%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
        49           -34.0%         33        GEO-MEAN sched_debug.cfs_rq[2]:/.tg_runnable_contrib

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    815734 ±  1%     -16.3%     682841 ±  2%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    815734           -16.3%     682841        GEO-MEAN sched_debug.cpu#0.avg_idle

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      2341 ± 31%     -33.3%       1560 ±  4%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      2340           -33.3%       1560        GEO-MEAN sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     77032 ±  7%     -15.7%      64945 ±  4%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     77032           -15.7%      64945        GEO-MEAN sched_debug.cpu#1.nr_load_updates

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       718 ±  5%     +18.6%        852 ±  3%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       718           +18.6%        852        GEO-MEAN slabinfo.btrfs_trans_handle.active_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       723 ±  5%     +18.8%        859 ±  3%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
       723           +18.8%        859        GEO-MEAN slabinfo.btrfs_trans_handle.num_objs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4889 ±  5%     -13.4%       4233 ±  5%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      4889           -13.4%       4233        GEO-MEAN sched_debug.cpu#3.curr->pid

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      4606 ±  2%     +14.4%       5268 ±  3%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      4606           +14.4%       5268        GEO-MEAN sched_debug.cpu#2.curr->pid

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     63213 ±  0%     +13.2%      71544 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     63213           +13.2%      71544        GEO-MEAN softirqs.SCHED

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
       166 ±  4%     +10.1%        183 ±  4%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
       166           +10.1%        183        GEO-MEAN uptime.idle

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    418402 ±  6%    +250.9%    1468345 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    418402          +250.9%    1468345        GEO-MEAN time.voluntary_context_switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      1434 ±  0%     +56.3%       2241 ±  1%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      1433           +56.3%       2241        GEO-MEAN vmstat.system.in

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
      5144 ±  0%      +6.8%       5493 ±  0%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
      2610 ±  0%     +65.1%       4310 ±  1%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
      3664           +32.8%       4865        GEO-MEAN vmstat.system.cs

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
     10375 ±  3%      -7.7%       9576 ±  3%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
     10374            -7.7%       9576        GEO-MEAN time.involuntary_context_switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
   3210548 ±  0%      +6.7%    3426526 ±  0%  bay/dd-write/performance-1HDD-cfq-xfs-10dd
   3210548            +6.7%    3426526        GEO-MEAN perf-stat.context-switches

227dfb4dbf109596  18dcf433f3ded61eb140a55e70  
----------------  --------------------------  
    706310 ±  1%      -3.2%     683678 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
    706310            -3.2%     683678        GEO-MEAN time.file_system_inputs

bay: Pentium D
Memory: 2G




                            time.voluntary_context_switches

  1.6e+06 ++----------------------------------------------------------------+
          |        O O O O O  O O O O OO O O O O                            |
  1.4e+06 O+O O OO          O                                               |
          |                                                                 |
  1.2e+06 ++                                                                |
          |                                                                 |
    1e+06 ++                                                                |
          |                                                                 |
   800000 ++                                                                |
          |                                                                 |
   600000 ++                                                                |
          |                                                         .*.     |
   400000 *+*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*   **.*.*
          |                                                                 |
   200000 ++----------------------------------------------------------------+


                                   softirqs.SCHED

  78000 ++------------------------------------------------------------------+
        |              O                                                    |
  76000 ++      O                                                           |
  74000 ++                                                                  |
        |     O  O O       O     O  O       *                               |
  72000 ++O O        O   O   O O  O   O O   O O                             |
  70000 O+                                O ::                              |
        |                                  : :                              |
  68000 ++                                 : :                              |
  66000 ++                                 : :                              |
        |                                  :  :                             |
  64000 *+                                :   :.*.**.       .*.*.   *.*. .*.|
  62000 ++  *.*.* .*.*.*. .*.*.*. *.   .*.*   *      *.*.*.*     *.*    *   *
        |: +     *       *       *  *.*                                     |
  60000 ++*-----------------------------------------------------------------+


                                 vmstat.system.in

  2600 ++-------------------------------------------------------------------+
  2400 ++           O                                                       |
       |       O   O  O O O O O   O   O      O                              |
  2200 O+O O O   O              O   O   O OO                                |
  2000 ++                                                                   |
       |                                                                    |
  1800 ++                                                                   |
  1600 ++                                                                   |
  1400 *+  *.*.*.*.**.*.*.*.*.*.*.*.*.*.*.**.*.*.*.*.*.*.*.*.*.*.**.*.*.*.*.*
       |   :                                                                |
  1200 ++ :                                                                 |
  1000 ++ :                                                                 |
       | :                                                                  |
   800 ++*                                                                  |
   600 ++-------------------------------------------------------------------+


                                 vmstat.system.cs

  5000 ++-------------------------------------------------------------------+
       |                                                                    |
  4500 ++    O O O OO O O   O   O   O     OO O                              |
  4000 O+O O              O   O   O   O O                                   |
       |                                                                    |
  3500 ++                                                                   |
       |                                                                    |
  3000 ++                                                                   |
       |   *.*.*.    .*. .*.*.*.*.*. .*.   *.*.*.*. .*. .*.*.*.*.**.*.*.*.*.*
  2500 *+  :     *.**   *           *   *.*        *   *                    |
  2000 ++ :                                                                 |
       |: :                                                                 |
  1500 ++:                                                                  |
       | *                                                                  |
  1000 ++-------------------------------------------------------------------+


                         sched_debug.cfs_rq[3]:/.exec_clock

  35000 ++------------------------------------------------------------------+
        |                                                                   |
  30000 ++                            *                                     |
        |      .*   .*.*     *. .*   : +       .*. *.*.*.   .*         .*   |
        |.*.*.*  :.*    +   +  *  *. :  *   *.*   *      *.*  + .*.**.*  + .*
  25000 *+       *       *.*        *    + +                   *          * |
        |                                 *                                 |
  20000 ++                                                                  |
        |                                                                   |
  15000 ++                                                                  |
        O O O                                                               |
        |                O                                                  |
  10000 ++             O   O O O  O     O                                   |
        |     O OO O O           O  O O   O O O                             |
   5000 ++------------------------------------------------------------------+


                        sched_debug.cfs_rq[3]:/.min_vruntime

  40000 ++------------------------------------------------------------------+
        |                             *                                     |
  35000 ++                            ::           *                        |
        |           .*.*        .*   : :       .*. :+       .*              |
        |      .*  *    +   .*.*  *. :  :   *.*   *  *.*. .*  + .*.**.*.*. .*
  30000 ++*.*.*  :+      *.*        *   *. +             *     *          * |
        *        *                        *                                 |
  25000 ++                                                                  |
        |                                                                   |
  20000 ++                                                                  |
        |                                                                   |
        O                                                                   |
  15000 ++O O            O   O                                              |
        |          O O O   O   O OO O O O O                                 |
  10000 ++----O-OO--------------------------O-O-----------------------------+

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

--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: fileio
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
  energy: 
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
commit: f114040e3ea6e07372334ade75d1ee0775c355e1
model: Pentium D
nr_cpu: 4
memory: 2G
hdd_partitions: "/dev/disk/by-id/ata-ST3750528AS_6VP2TCZN-part1"
swap_partitions: "/dev/disk/by-id/ata-ST3750528AS_9VP5LPHN-part5"
rootfs_partition: "/dev/disk/by-id/ata-ST3750528AS_6VP2TCZN-part2"
period: 600s
nr_threads: 100%
disk: 1HDD
fs:
- btrfs
size: 64G
fileio:
  filenum: 1024f
  rwmode:
  - rndrw
  iomode:
  - sync
enqueue_time: 2014-10-20 10:09:35.766127772 +08:00
testbox: bay
tbox_group: bay
kconfig: x86_64-rhel
head_commit: e0911a5d8b56753716bd15de3d2fb1d5fa39ced2
base_commit: f114040e3ea6e07372334ade75d1ee0775c355e1
branch: linux-devel/devel-hourly-2014102016
kernel: "/kernel/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/vmlinuz-3.18.0-rc1-gf114040"
user: lkp
queue: cyclic
result_root: "/result/bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync/debian-x86_64.cgz/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/0"
job_file: "/lkp/scheduled/bay/cyclic_fileio-performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync-x86_64-rhel-BASE-f114040e3ea6e07372334ade75d1ee0775c355e1-0.yaml"
dequeue_time: 2014-10-20 17:41:06.590446117 +08:00
job_state: finished
loadavg: 3.12 3.41 2.18 1/131 16764
start_time: '1413798109'
end_time: '1413799493'
version: "/lkp/lkp/.src-20141020-171003"

--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
mkfs -t btrfs /dev/sda1
mount -t btrfs /dev/sda1 /fs/sda1
cd /fs/sda1
sysbench --test=fileio --max-requests=0 --num-threads=4 --max-time=600 --file-test-mode=rndrw --file-total-size=68719476736 --file-io-mode=sync --file-num=1024 prepare
sysbench --test=fileio --max-requests=0 --num-threads=4 --max-time=600 --file-test-mode=rndrw --file-total-size=68719476736 --file-io-mode=sync --file-num=1024 run

--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--LTeJQqWS0MN7I/qa--
