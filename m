Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaJ0C2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:28:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:18239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaJ0C2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:28:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="yaml'?scan'208";a="611822285"
Date: Mon, 27 Oct 2014 10:28:22 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [ACPI / processor] f3ca4164529: -48.3%
 will-it-scale.per_process_ops
Message-ID: <20141027022822.GJ27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9/eUdp+dLtKXvemk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit f3ca4164529b875374c410193bbbac0ee960895f ("ACPI / processor: Rework processor throttling with work_on_cpu()")


       v3.14-rc4  f3ca4164529b875374c410193b  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
    624516 ±  0%     -48.3%     322914 ±  0%  brickland1/will-it-scale/powersave-pwrite1
    624516           -48.3%     322914        GEO-MEAN will-it-scale.per_process_ops

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    576025 ±  0%     -47.9%     299956 ±  0%  brickland1/will-it-scale/powersave-pwrite1
    576024           -47.9%     299955        GEO-MEAN will-it-scale.per_thread_ops

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      0.46 ±  0%      +6.5%       0.48 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      0.46            +6.5%       0.48        GEO-MEAN will-it-scale.scalability

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    176818 ±  3%     -84.7%      26974 ±  7%  brickland1/will-it-scale/powersave-pwrite1
    176818           -84.7%      26973        GEO-MEAN cpuidle.C6-IVB.usage

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
 7.139e+09 ±  1%     -78.5%  1.533e+09 ±  5%  brickland1/will-it-scale/powersave-pwrite1
 7.139e+09           -78.5%  1.533e+09        GEO-MEAN cpuidle.C6-IVB.time

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        32 ± 34%     -77.2%          7 ± 44%  brickland1/will-it-scale/powersave-pwrite1
        32           -77.2%          7        GEO-MEAN sched_debug.cfs_rq[33]:/.blocked_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        84 ± 27%     -71.6%         24 ± 39%  brickland1/will-it-scale/powersave-pwrite1
        84           -71.6%         24        GEO-MEAN proc-vmstat.nr_dirtied

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       976 ± 43%    +148.7%       2427 ± 37%  brickland1/will-it-scale/powersave-pwrite1
       976          +148.7%       2427        GEO-MEAN sched_debug.cpu#20.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        41 ± 28%    +185.6%        118 ± 19%  brickland1/will-it-scale/powersave-pwrite1
        41          +185.6%        118        GEO-MEAN sched_debug.cpu#76.nr_uninterruptible

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2144 ± 38%    +134.5%       5027 ± 36%  brickland1/will-it-scale/powersave-pwrite1
      2144          +134.5%       5027        GEO-MEAN sched_debug.cpu#20.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        37 ± 18%     -60.8%         14 ± 44%  brickland1/will-it-scale/powersave-pwrite1
        37           -60.8%         14        GEO-MEAN sched_debug.cfs_rq[91]:/.load

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        37 ± 18%     -60.8%         14 ± 44%  brickland1/will-it-scale/powersave-pwrite1
        37           -60.8%         14        GEO-MEAN sched_debug.cpu#91.load

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        35 ± 46%    +235.4%        117 ± 35%  brickland1/will-it-scale/powersave-pwrite1
        34          +235.4%        117        GEO-MEAN sched_debug.cfs_rq[92]:/.tg_load_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        54 ±  9%     -57.0%         23 ± 43%  brickland1/will-it-scale/powersave-pwrite1
        54           -57.0%         23        GEO-MEAN sched_debug.cpu#91.cpu_load[1]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        37 ± 29%     -64.5%         13 ± 16%  brickland1/will-it-scale/powersave-pwrite1
        37           -64.5%         13        GEO-MEAN sched_debug.cfs_rq[33]:/.tg_load_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1785 ± 46%     +75.8%       3139 ± 28%  brickland1/will-it-scale/powersave-pwrite1
      1785           +75.8%       3139        GEO-MEAN sched_debug.cpu#41.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1799 ± 23%     -38.6%       1104 ± 38%  brickland1/will-it-scale/powersave-pwrite1
      1799           -38.6%       1104        GEO-MEAN sched_debug.cpu#60.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        46 ±  9%     -54.9%         21 ± 24%  brickland1/will-it-scale/powersave-pwrite1
        46           -54.9%         21        GEO-MEAN sched_debug.cpu#91.cpu_load[2]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2138 ± 34%    +108.7%       4462 ± 33%  brickland1/will-it-scale/powersave-pwrite1
      2138          +108.7%       4462        GEO-MEAN sched_debug.cpu#43.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       344 ± 36%     +73.2%        596 ± 18%  brickland1/will-it-scale/powersave-pwrite1
       344           +73.2%        596        GEO-MEAN sched_debug.cfs_rq[91]:/.blocked_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       104 ± 26%     -47.6%         54 ±  1%  brickland1/will-it-scale/powersave-pwrite1
       104           -47.6%         54        GEO-MEAN sched_debug.cpu#0.cpu_load[4]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1803 ± 23%     -37.9%       1119 ± 37%  brickland1/will-it-scale/powersave-pwrite1
      1803           -37.9%       1119        GEO-MEAN sched_debug.cpu#60.sched_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       680 ± 38%    +104.0%       1387 ± 37%  brickland1/will-it-scale/powersave-pwrite1
       679          +104.0%       1387        GEO-MEAN sched_debug.cpu#40.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        96 ± 26%     -47.6%         50 ±  0%  brickland1/will-it-scale/powersave-pwrite1
        96           -47.6%         50        GEO-MEAN sched_debug.cpu#0.cpu_load[3]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       382 ± 34%     +60.2%        612 ± 16%  brickland1/will-it-scale/powersave-pwrite1
       382           +60.2%        612        GEO-MEAN sched_debug.cfs_rq[91]:/.tg_load_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       881 ± 38%    +135.9%       2079 ± 37%  brickland1/will-it-scale/powersave-pwrite1
       881          +135.9%       2079        GEO-MEAN sched_debug.cpu#43.ttwu_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        63 ± 24%     -40.5%         37 ±  5%  brickland1/will-it-scale/powersave-pwrite1
        63           -40.5%         37        GEO-MEAN sched_debug.cfs_rq[0]:/.runnable_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        69 ± 34%     -46.7%         37 ±  7%  brickland1/will-it-scale/powersave-pwrite1
        69           -46.7%         37        GEO-MEAN sched_debug.cfs_rq[0]:/.load

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        63 ± 24%     -40.5%         37 ±  5%  brickland1/will-it-scale/powersave-pwrite1
        63           -40.5%         37        GEO-MEAN sched_debug.cpu#0.load

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        85 ± 26%     -46.4%         45 ±  2%  brickland1/will-it-scale/powersave-pwrite1
        85           -46.4%         45        GEO-MEAN sched_debug.cpu#0.cpu_load[2]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        41 ± 12%     -50.2%         20 ± 15%  brickland1/will-it-scale/powersave-pwrite1
        41           -50.2%         20        GEO-MEAN sched_debug.cpu#91.cpu_load[3]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        63 ± 24%     -37.0%         40 ± 11%  brickland1/will-it-scale/powersave-pwrite1
        63           -37.0%         40        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_load_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       374 ± 28%     +81.1%        678 ± 45%  brickland1/will-it-scale/powersave-pwrite1
       374           +81.1%        678        GEO-MEAN sched_debug.cpu#12.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2.26 ±  7%     +96.5%       4.44 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      2.26           +96.5%       4.44        GEO-MEAN perf-profile.cpu-cycles.scheduler_tick.update_process_times.tick_sched_handle.tick_sched_timer.__run_hrtimer

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2.40 ±  8%     +95.7%       4.69 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      2.40           +95.7%       4.69        GEO-MEAN perf-profile.cpu-cycles.update_process_times.tick_sched_handle.tick_sched_timer.__run_hrtimer.hrtimer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2.41 ±  8%     +95.7%       4.71 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      2.41           +95.7%       4.71        GEO-MEAN perf-profile.cpu-cycles.tick_sched_handle.isra.17.tick_sched_timer.__run_hrtimer.hrtimer_interrupt.local_apic_timer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        25 ± 23%     -29.9%         17 ± 29%  brickland1/will-it-scale/powersave-pwrite1
        25           -29.9%         17        GEO-MEAN sched_debug.cfs_rq[17]:/.load

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        75 ± 28%     -41.9%         43 ±  5%  brickland1/will-it-scale/powersave-pwrite1
        74           -41.9%         43        GEO-MEAN sched_debug.cpu#0.cpu_load[1]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       130 ± 18%     -46.8%         69 ± 13%  brickland1/will-it-scale/powersave-pwrite1
       129           -46.8%         69        GEO-MEAN proc-vmstat.nr_written

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       898 ± 23%     +68.6%       1513 ± 40%  brickland1/will-it-scale/powersave-pwrite1
       898           +68.6%       1513        GEO-MEAN sched_debug.cpu#12.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2177 ± 25%    +102.9%       4418 ± 47%  brickland1/will-it-scale/powersave-pwrite1
      2177          +102.9%       4418        GEO-MEAN sched_debug.cpu#46.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        66 ± 29%     -35.3%         43 ± 13%  brickland1/will-it-scale/powersave-pwrite1
        66           -35.3%         43        GEO-MEAN sched_debug.cpu#0.cpu_load[0]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.12 ±  0%     -43.8%       0.63 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      1.12           -43.8%       0.63        GEO-MEAN turbostat.GHz

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       167 ± 28%     +67.5%        280 ±  3%  brickland1/will-it-scale/powersave-pwrite1
       167           +67.5%        279        GEO-MEAN slabinfo.nfs_write_data.num_objs

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       167 ± 28%     +67.5%        280 ±  3%  brickland1/will-it-scale/powersave-pwrite1
       167           +67.5%        279        GEO-MEAN slabinfo.nfs_write_data.active_objs

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2.00 ±  7%     +75.5%       3.52 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      2.00           +75.5%       3.52        GEO-MEAN perf-profile.cpu-cycles.sched_clock_tick.scheduler_tick.update_process_times.tick_sched_handle.tick_sched_timer

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        33 ± 13%     -39.4%         20 ± 13%  brickland1/will-it-scale/powersave-pwrite1
        33           -39.4%         19        GEO-MEAN sched_debug.cpu#91.cpu_load[4]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.98 ±  7%     +73.2%       3.44 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      1.98           +73.2%       3.44        GEO-MEAN perf-profile.cpu-cycles.ktime_get.sched_clock_tick.scheduler_tick.update_process_times.tick_sched_handle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.96 ±  7%     +71.8%       3.37 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      1.96           +71.8%       3.37        GEO-MEAN perf-profile.cpu-cycles.read_hpet.ktime_get.sched_clock_tick.scheduler_tick.update_process_times

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       474 ± 17%     +57.3%        746 ± 31%  brickland1/will-it-scale/powersave-pwrite1
       474           +57.3%        745        GEO-MEAN sched_debug.cpu#110.ttwu_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1585 ± 29%     -37.8%        985 ± 30%  brickland1/will-it-scale/powersave-pwrite1
      1584           -37.8%        985        GEO-MEAN sched_debug.cpu#108.ttwu_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        23 ±  7%     +81.0%         42 ± 22%  brickland1/will-it-scale/powersave-pwrite1
        23           +81.0%         42        GEO-MEAN sched_debug.cpu#106.cpu_load[4]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2741 ± 19%     +43.2%       3924 ± 18%  brickland1/will-it-scale/powersave-pwrite1
      2741           +43.2%       3924        GEO-MEAN sched_debug.cpu#35.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.32 ±  6%     +41.2%       1.86 ± 12%  brickland1/will-it-scale/powersave-pwrite1
      1.32           +41.2%       1.86        GEO-MEAN perf-profile.cpu-cycles.apic_timer_interrupt.shmem_write_end.generic_file_buffered_write.__generic_file_aio_write.generic_file_aio_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
         4 ±  0%     +45.0%          5 ± 12%  brickland1/will-it-scale/powersave-pwrite1
         4           +45.0%          5        GEO-MEAN sched_debug.cpu#92.cpu_load[2]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.29 ±  6%     +39.9%       1.80 ± 11%  brickland1/will-it-scale/powersave-pwrite1
      1.29           +39.9%       1.80        GEO-MEAN perf-profile.cpu-cycles.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.shmem_write_end.generic_file_buffered_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.29 ±  7%     +40.0%       1.80 ± 12%  brickland1/will-it-scale/powersave-pwrite1
      1.29           +40.0%       1.80        GEO-MEAN perf-profile.cpu-cycles.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.shmem_write_end

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.29 ±  6%     +39.9%       1.81 ± 11%  brickland1/will-it-scale/powersave-pwrite1
      1.29           +39.9%       1.81        GEO-MEAN perf-profile.cpu-cycles.smp_apic_timer_interrupt.apic_timer_interrupt.shmem_write_end.generic_file_buffered_write.__generic_file_aio_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       426 ± 39%     -43.1%        242 ± 10%  brickland1/will-it-scale/powersave-pwrite1
       426           -43.1%        242        GEO-MEAN sched_debug.cpu#60.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        28 ±  5%     +57.4%         44 ± 23%  brickland1/will-it-scale/powersave-pwrite1
        28           +57.4%         44        GEO-MEAN sched_debug.cpu#106.cpu_load[3]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
         5 ±  7%     +26.9%          6 ±  7%  brickland1/will-it-scale/powersave-pwrite1
         5           +26.9%          6        GEO-MEAN sched_debug.cpu#32.cpu_load[3]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      7.81 ±  7%     +39.6%      10.91 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      7.81           +39.6%      10.91        GEO-MEAN perf-profile.cpu-cycles.__run_hrtimer.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      7.78 ±  7%     +38.9%      10.80 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      7.78           +38.9%      10.80        GEO-MEAN perf-profile.cpu-cycles.tick_sched_timer.__run_hrtimer.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      2961 ±  9%     +30.2%       3856 ± 27%  brickland1/will-it-scale/powersave-pwrite1
      2960           +30.2%       3856        GEO-MEAN sched_debug.cpu#18.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3.87 ±  5%     +40.4%       5.44 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3.87           +40.4%       5.44        GEO-MEAN perf-profile.cpu-cycles.apic_timer_interrupt.generic_file_buffered_write.__generic_file_aio_write.generic_file_aio_write.do_sync_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       106 ±  7%     +58.7%        169 ± 31%  brickland1/will-it-scale/powersave-pwrite1
       106           +58.7%        169        GEO-MEAN sched_debug.cpu#86.ttwu_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3.76 ±  5%     +39.6%       5.24 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3.76           +39.6%       5.24        GEO-MEAN perf-profile.cpu-cycles.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.generic_file_buffered_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       803 ± 17%     +40.3%       1127 ± 19%  brickland1/will-it-scale/powersave-pwrite1
       803           +40.3%       1127        GEO-MEAN sched_debug.cpu#39.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3.78 ±  5%     +39.5%       5.27 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3.78           +39.5%       5.27        GEO-MEAN perf-profile.cpu-cycles.smp_apic_timer_interrupt.apic_timer_interrupt.generic_file_buffered_write.__generic_file_aio_write.generic_file_aio_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3.76 ±  5%     +39.4%       5.25 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3.76           +39.4%       5.25        GEO-MEAN perf-profile.cpu-cycles.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.generic_file_buffered_write.__generic_file_aio_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     19688 ± 19%     +35.1%      26591 ±  0%  brickland1/will-it-scale/powersave-pwrite1
     19688           +35.1%      26591        GEO-MEAN sched_debug.cfs_rq[118]:/.exec_clock

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1712 ± 17%     +44.7%       2477 ± 25%  brickland1/will-it-scale/powersave-pwrite1
      1712           +44.7%       2476        GEO-MEAN sched_debug.cpu#39.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        73 ±  1%     +63.7%        119 ± 47%  brickland1/will-it-scale/powersave-pwrite1
        73           +63.7%        119        GEO-MEAN sched_debug.cpu#86.ttwu_local

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       429 ± 23%     +46.7%        630 ± 29%  brickland1/will-it-scale/powersave-pwrite1
       429           +46.7%        630        GEO-MEAN sched_debug.cpu#26.ttwu_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        98 ± 15%     +65.9%        162 ± 36%  brickland1/will-it-scale/powersave-pwrite1
        98           +65.9%        162        GEO-MEAN sched_debug.cpu#86.sched_goidle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     71965 ± 14%     +17.5%      84574 ±  0%  brickland1/will-it-scale/powersave-pwrite1
     71965           +17.5%      84574        GEO-MEAN sched_debug.cfs_rq[60]:/.exec_clock

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       367 ± 17%     +43.8%        528 ± 24%  brickland1/will-it-scale/powersave-pwrite1
       367           +43.8%        528        GEO-MEAN sched_debug.cpu#82.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       371 ± 17%     +45.0%        538 ± 26%  brickland1/will-it-scale/powersave-pwrite1
       371           +45.0%        538        GEO-MEAN sched_debug.cpu#82.sched_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    196924 ± 13%     +17.8%     231931 ±  0%  brickland1/will-it-scale/powersave-pwrite1
    196924           +17.8%     231931        GEO-MEAN sched_debug.cfs_rq[60]:/.spread0

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       309 ± 10%     +65.1%        511 ± 40%  brickland1/will-it-scale/powersave-pwrite1
       309           +65.1%        511        GEO-MEAN sched_debug.cpu#86.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3844 ± 17%     +30.9%       5032 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      3844           +30.9%       5032        GEO-MEAN sched_debug.cpu#118.curr->pid

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       313 ± 10%     +64.4%        514 ± 39%  brickland1/will-it-scale/powersave-pwrite1
       313           +64.4%        514        GEO-MEAN sched_debug.cpu#86.sched_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       928 ± 32%     -28.0%        668 ± 14%  brickland1/will-it-scale/powersave-pwrite1
       928           -28.0%        668        GEO-MEAN sched_debug.cpu#63.nr_switches

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3080 ±  6%     +25.8%       3875 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3080           +25.8%       3875        GEO-MEAN sched_debug.cfs_rq[107]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3070 ±  6%     +25.4%       3849 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3070           +25.4%       3849        GEO-MEAN sched_debug.cfs_rq[109]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      6762 ± 12%     -18.8%       5493 ± 16%  brickland1/will-it-scale/powersave-pwrite1
      6762           -18.8%       5493        GEO-MEAN proc-vmstat.pgalloc_dma32

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3072 ±  6%     +25.5%       3854 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3072           +25.5%       3854        GEO-MEAN sched_debug.cfs_rq[108]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
         4 ±  0%     +35.0%          5 ± 14%  brickland1/will-it-scale/powersave-pwrite1
         4           +35.0%          5        GEO-MEAN sched_debug.cpu#92.cpu_load[4]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
         4 ±  0%     +45.0%          5 ± 20%  brickland1/will-it-scale/powersave-pwrite1
         4           +45.0%          5        GEO-MEAN sched_debug.cpu#92.cpu_load[3]

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
   1609011 ± 17%     +29.1%    2076675 ±  0%  brickland1/will-it-scale/powersave-pwrite1
   1609011           +29.1%    2076675        GEO-MEAN sched_debug.cfs_rq[118]:/.min_vruntime

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3209 ±  2%     +21.4%       3896 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3209           +21.4%       3896        GEO-MEAN sched_debug.cfs_rq[100]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3105 ±  5%     +25.1%       3885 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3105           +25.1%       3885        GEO-MEAN sched_debug.cfs_rq[106]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3197 ±  2%     +21.2%       3875 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3197           +21.2%       3875        GEO-MEAN sched_debug.cfs_rq[102]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3198 ±  2%     +22.1%       3906 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3198           +22.1%       3906        GEO-MEAN sched_debug.cfs_rq[95]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3195 ±  2%     +22.0%       3897 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3195           +22.0%       3897        GEO-MEAN sched_debug.cfs_rq[99]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3202 ±  2%     +22.4%       3919 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3202           +22.4%       3919        GEO-MEAN sched_debug.cfs_rq[97]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3211 ±  2%     +21.3%       3895 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3211           +21.3%       3895        GEO-MEAN sched_debug.cfs_rq[101]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3195 ±  2%     +22.3%       3908 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3195           +22.3%       3908        GEO-MEAN sched_debug.cfs_rq[98]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3045 ±  5%     +23.4%       3758 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3045           +23.4%       3758        GEO-MEAN sched_debug.cfs_rq[119]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3076 ±  5%     +23.9%       3811 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3075           +23.9%       3810        GEO-MEAN sched_debug.cfs_rq[113]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3060 ±  5%     +24.2%       3800 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3060           +24.2%       3800        GEO-MEAN sched_debug.cfs_rq[114]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3215 ±  3%     +21.2%       3897 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3215           +21.2%       3897        GEO-MEAN sched_debug.cfs_rq[94]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3229 ±  3%     +21.0%       3906 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3229           +21.0%       3906        GEO-MEAN sched_debug.cfs_rq[93]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3071 ±  6%     +24.9%       3834 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3070           +24.9%       3834        GEO-MEAN sched_debug.cfs_rq[111]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       336 ±  4%     +23.1%        413 ±  6%  brickland1/will-it-scale/powersave-pwrite1
       336           +23.1%        413        GEO-MEAN sched_debug.cfs_rq[106]:/.tg_runnable_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3081 ±  6%     +24.9%       3848 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3081           +24.9%       3848        GEO-MEAN sched_debug.cfs_rq[110]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3202 ±  2%     +21.9%       3904 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3202           +21.9%       3904        GEO-MEAN sched_debug.cfs_rq[96]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3102 ±  5%     +25.3%       3888 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3102           +25.3%       3888        GEO-MEAN sched_debug.cfs_rq[105]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     19954 ±  1%     +20.9%      24119 ±  2%  brickland1/will-it-scale/powersave-pwrite1
     19954           +20.9%      24119        GEO-MEAN sched_debug.cfs_rq[106]:/.exec_clock

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3056 ±  5%     +24.0%       3790 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3056           +24.0%       3790        GEO-MEAN sched_debug.cfs_rq[115]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3063 ±  5%     +23.7%       3791 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3063           +23.7%       3790        GEO-MEAN sched_debug.cfs_rq[116]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3204 ±  2%     +20.8%       3872 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3204           +20.8%       3872        GEO-MEAN sched_debug.cfs_rq[103]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3062 ±  5%     +23.4%       3778 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3062           +23.4%       3778        GEO-MEAN sched_debug.cfs_rq[117]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3072 ±  5%     +23.5%       3795 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3072           +23.5%       3795        GEO-MEAN sched_debug.cfs_rq[112]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3060 ±  5%     +23.1%       3768 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3060           +23.1%       3768        GEO-MEAN sched_debug.cfs_rq[118]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.23 ±  5%     +18.3%       1.46 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.23           +18.3%       1.46        GEO-MEAN perf-profile.cpu-cycles.apic_timer_interrupt.__generic_file_aio_write.generic_file_aio_write.do_sync_write.vfs_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     15533 ±  4%     +23.4%      19163 ±  6%  brickland1/will-it-scale/powersave-pwrite1
     15533           +23.4%      19162        GEO-MEAN sched_debug.cfs_rq[106]:/.avg->runnable_avg_sum

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3209 ±  2%     +21.7%       3907 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3209           +21.7%       3907        GEO-MEAN sched_debug.cfs_rq[104]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3235 ±  3%     +19.9%       3877 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3235           +19.9%       3877        GEO-MEAN sched_debug.cfs_rq[92]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.21 ±  6%     +17.1%       1.41 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.21           +17.1%       1.41        GEO-MEAN perf-profile.cpu-cycles.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.__generic_file_aio_write.generic_file_aio_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.21 ±  6%     +17.1%       1.41 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.21           +17.1%       1.41        GEO-MEAN perf-profile.cpu-cycles.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.__generic_file_aio_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.21 ±  6%     +17.2%       1.42 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.21           +17.2%       1.42        GEO-MEAN perf-profile.cpu-cycles.smp_apic_timer_interrupt.apic_timer_interrupt.__generic_file_aio_write.generic_file_aio_write.do_sync_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3230 ±  2%     +19.9%       3873 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3230           +19.9%       3873        GEO-MEAN sched_debug.cfs_rq[83]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3235 ±  2%     +20.3%       3891 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3235           +20.3%       3891        GEO-MEAN sched_debug.cfs_rq[85]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3239 ±  3%     +19.7%       3877 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3239           +19.7%       3877        GEO-MEAN sched_debug.cfs_rq[89]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3248 ±  3%     +19.7%       3889 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3248           +19.7%       3889        GEO-MEAN sched_debug.cfs_rq[91]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3230 ±  2%     +19.9%       3873 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3230           +19.9%       3873        GEO-MEAN sched_debug.cfs_rq[77]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.38 ±  2%     -14.6%       1.18 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      1.38           -14.6%       1.18        GEO-MEAN perf-profile.cpu-cycles.mutex_unlock.do_sync_write.vfs_write.sys_pwrite64.system_call_fastpath

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        49 ±  9%     +33.9%         66 ± 18%  brickland1/will-it-scale/powersave-pwrite1
        49           +33.9%         66        GEO-MEAN sched_debug.cpu#118.ttwu_local

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3235 ±  2%     +20.3%       3891 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3235           +20.3%       3891        GEO-MEAN sched_debug.cfs_rq[84]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3226 ±  2%     +19.7%       3862 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3226           +19.7%       3861        GEO-MEAN sched_debug.cfs_rq[87]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3227 ±  3%     +20.0%       3872 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3227           +20.0%       3872        GEO-MEAN sched_debug.cfs_rq[82]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3236 ±  2%     +20.0%       3882 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3235           +20.0%       3882        GEO-MEAN sched_debug.cfs_rq[86]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3239 ±  3%     +20.1%       3891 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3239           +20.1%       3891        GEO-MEAN sched_debug.cfs_rq[90]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3239 ±  3%     +19.5%       3870 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3239           +19.5%       3870        GEO-MEAN sched_debug.cfs_rq[81]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3242 ±  3%     +18.3%       3834 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3242           +18.3%       3834        GEO-MEAN sched_debug.cfs_rq[79]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3240 ±  2%     +18.9%       3851 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3240           +18.9%       3851        GEO-MEAN sched_debug.cfs_rq[78]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3241 ±  2%     +18.1%       3828 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3241           +18.1%       3828        GEO-MEAN sched_debug.cfs_rq[80]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3232 ±  2%     +18.9%       3842 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3232           +18.9%       3842        GEO-MEAN sched_debug.cfs_rq[88]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3245 ±  2%     +18.2%       3835 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3245           +18.2%       3835        GEO-MEAN sched_debug.cfs_rq[69]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3248 ±  2%     +17.9%       3828 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3247           +17.9%       3828        GEO-MEAN sched_debug.cfs_rq[70]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     25.35 ±  1%     -15.1%      21.52 ±  1%  brickland1/will-it-scale/powersave-pwrite1
     25.35           -15.1%      21.52        GEO-MEAN turbostat.%pc2

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3239 ±  2%     +18.6%       3841 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3239           +18.6%       3841        GEO-MEAN sched_debug.cfs_rq[76]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3254 ±  2%     +17.4%       3821 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      3254           +17.4%       3821        GEO-MEAN sched_debug.cfs_rq[71]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        78 ± 15%     +30.0%        101 ± 12%  brickland1/will-it-scale/powersave-pwrite1
        78           +30.0%        101        GEO-MEAN sched_debug.cpu#118.ttwu_count

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3247 ±  2%     +15.2%       3742 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3247           +15.2%       3742        GEO-MEAN sched_debug.cfs_rq[61]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3236 ±  2%     +17.9%       3814 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      3235           +17.9%       3814        GEO-MEAN sched_debug.cfs_rq[72]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       421 ±  5%     +11.4%        470 ±  4%  brickland1/will-it-scale/powersave-pwrite1
       421           +11.4%        470        GEO-MEAN sched_debug.cfs_rq[91]:/.tg_runnable_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3249 ±  2%     +15.0%       3735 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3249           +15.0%       3735        GEO-MEAN sched_debug.cfs_rq[62]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3246 ±  2%     +17.5%       3815 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3246           +17.5%       3815        GEO-MEAN sched_debug.cfs_rq[74]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3255 ±  2%     +16.7%       3799 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3254           +16.7%       3799        GEO-MEAN sched_debug.cfs_rq[68]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     19474 ±  5%     +11.2%      21665 ±  4%  brickland1/will-it-scale/powersave-pwrite1
     19474           +11.2%      21665        GEO-MEAN sched_debug.cfs_rq[91]:/.avg->runnable_avg_sum

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3239 ±  2%     +17.7%       3813 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3239           +17.7%       3813        GEO-MEAN sched_debug.cfs_rq[75]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3260 ±  3%     +14.6%       3735 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3260           +14.6%       3735        GEO-MEAN sched_debug.cfs_rq[59]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3244 ±  3%     +17.0%       3797 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3244           +17.0%       3796        GEO-MEAN sched_debug.cfs_rq[73]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      5.81 ±  5%     -10.1%       5.22 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      5.81           -10.1%       5.22        GEO-MEAN perf-profile.cpu-cycles.read_hpet.ktime_get_update_offsets.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3319 ±  2%     +13.7%       3773 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3318           +13.7%       3773        GEO-MEAN sched_debug.cfs_rq[46]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3978 ±  4%      +9.8%       4369 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      3978            +9.8%       4369        GEO-MEAN sched_debug.cpu#90.curr->pid

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3257 ±  2%     +14.8%       3740 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3257           +14.8%       3740        GEO-MEAN sched_debug.cfs_rq[60]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3321 ±  2%     +13.7%       3775 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3321           +13.7%       3774        GEO-MEAN sched_debug.cfs_rq[47]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3318 ±  3%     +13.4%       3764 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3318           +13.4%       3764        GEO-MEAN sched_debug.cfs_rq[44]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3272 ±  3%     +14.2%       3736 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3271           +14.2%       3736        GEO-MEAN sched_debug.cfs_rq[58]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3301 ±  3%     +13.9%       3759 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3301           +13.9%       3759        GEO-MEAN sched_debug.cfs_rq[50]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3294 ±  3%     +13.5%       3740 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3294           +13.5%       3740        GEO-MEAN sched_debug.cfs_rq[53]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.37 ±  5%     +14.1%       1.57 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.37           +14.1%       1.57        GEO-MEAN perf-profile.cpu-cycles.apic_timer_interrupt.fsnotify.vfs_write.sys_pwrite64.system_call_fastpath

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3241 ±  3%     +16.2%       3766 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3241           +16.2%       3765        GEO-MEAN sched_debug.cfs_rq[65]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3323 ±  2%     +13.3%       3763 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3323           +13.3%       3763        GEO-MEAN sched_debug.cfs_rq[49]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3290 ±  2%     +14.0%       3752 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3290           +14.0%       3751        GEO-MEAN sched_debug.cfs_rq[56]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3240 ±  2%     +15.9%       3755 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3240           +15.9%       3754        GEO-MEAN sched_debug.cfs_rq[66]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3242 ±  2%     +14.5%       3712 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3242           +14.5%       3712        GEO-MEAN sched_debug.cfs_rq[63]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3307 ±  3%     +13.9%       3768 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3307           +13.9%       3768        GEO-MEAN sched_debug.cfs_rq[51]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3255 ±  2%     +15.6%       3762 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3255           +15.6%       3762        GEO-MEAN sched_debug.cfs_rq[67]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3301 ±  3%     +13.4%       3744 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3301           +13.4%       3744        GEO-MEAN sched_debug.cfs_rq[55]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3315 ±  3%     +13.7%       3769 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3315           +13.7%       3769        GEO-MEAN sched_debug.cfs_rq[43]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3481 ±  4%     +10.4%       3842 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3481           +10.4%       3842        GEO-MEAN sched_debug.cfs_rq[35]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     14790 ±  1%     +17.6%      17396 ± 10%  brickland1/will-it-scale/powersave-pwrite1
     14790           +17.6%      17396        GEO-MEAN sched_debug.cfs_rq[47]:/.exec_clock

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      5.07 ±  8%     +13.7%       5.77 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      5.07           +13.7%       5.77        GEO-MEAN perf-profile.cpu-cycles.ktime_get.tick_sched_timer.__run_hrtimer.hrtimer_interrupt.local_apic_timer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3.90 ±  2%     -11.1%       3.47 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      3.90           -11.1%       3.47        GEO-MEAN perf-profile.cpu-cycles.__sb_start_write.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3295 ±  3%     +13.5%       3739 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3295           +13.5%       3739        GEO-MEAN sched_debug.cfs_rq[54]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3274 ±  2%     +14.1%       3737 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3274           +14.1%       3737        GEO-MEAN sched_debug.cfs_rq[57]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3449 ±  4%      +9.0%       3761 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3449            +9.0%       3761        GEO-MEAN sched_debug.cfs_rq[42]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
        73 ±  2%     +21.0%         88 ± 18%  brickland1/will-it-scale/powersave-pwrite1
        73           +21.0%         88        GEO-MEAN sched_debug.cpu#87.ttwu_local

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3447 ±  4%     +10.6%       3811 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3447           +10.6%       3811        GEO-MEAN sched_debug.cfs_rq[39]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3327 ±  2%     +13.4%       3772 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3327           +13.4%       3772        GEO-MEAN sched_debug.cfs_rq[48]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3493 ±  4%      +9.8%       3834 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3493            +9.8%       3834        GEO-MEAN sched_debug.cfs_rq[29]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3247 ±  3%     +15.5%       3752 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3247           +15.5%       3752        GEO-MEAN sched_debug.cfs_rq[64]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3498 ±  4%      +9.7%       3838 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3498            +9.7%       3838        GEO-MEAN sched_debug.cfs_rq[30]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3309 ±  3%     +13.3%       3749 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3309           +13.3%       3749        GEO-MEAN sched_debug.cfs_rq[52]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3465 ±  5%     +10.0%       3812 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3465           +10.0%       3812        GEO-MEAN sched_debug.cfs_rq[37]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.34 ±  4%     +12.6%       1.51 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.34           +12.6%       1.51        GEO-MEAN perf-profile.cpu-cycles.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.fsnotify.vfs_write

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3449 ±  5%     +10.4%       3806 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3449           +10.4%       3806        GEO-MEAN sched_debug.cfs_rq[38]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3492 ±  4%      +9.5%       3824 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3492            +9.5%       3824        GEO-MEAN sched_debug.cfs_rq[31]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3471 ±  5%     +10.1%       3820 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3471           +10.1%       3820        GEO-MEAN sched_debug.cfs_rq[36]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3498 ±  4%      +9.2%       3819 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3498            +9.2%       3819        GEO-MEAN sched_debug.cfs_rq[27]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3478 ±  5%     +10.0%       3827 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3478           +10.0%       3827        GEO-MEAN sched_debug.cfs_rq[34]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3474 ±  4%     +10.3%       3834 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3474           +10.3%       3834        GEO-MEAN sched_debug.cfs_rq[33]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      5.04 ±  8%     +12.8%       5.68 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      5.04           +12.8%       5.68        GEO-MEAN perf-profile.cpu-cycles.read_hpet.ktime_get.tick_sched_timer.__run_hrtimer.hrtimer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3452 ±  4%      +9.4%       3776 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3452            +9.4%       3776        GEO-MEAN sched_debug.cfs_rq[40]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3455 ±  4%      +9.2%       3772 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      3455            +9.2%       3771        GEO-MEAN sched_debug.cfs_rq[41]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3478 ±  5%      +9.6%       3811 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3478            +9.6%       3811        GEO-MEAN sched_debug.cfs_rq[32]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.83 ±  5%     -11.3%       1.62 ±  5%  brickland1/will-it-scale/powersave-pwrite1
      1.83           -11.3%       1.62        GEO-MEAN perf-profile.cpu-cycles.rw_verify_area.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3321 ±  3%     +12.8%       3747 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3321           +12.8%       3747        GEO-MEAN sched_debug.cfs_rq[45]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.34 ±  4%     +12.7%       1.51 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.34           +12.7%       1.51        GEO-MEAN perf-profile.cpu-cycles.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.fsnotify

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.35 ±  5%     +12.9%       1.52 ±  4%  brickland1/will-it-scale/powersave-pwrite1
      1.35           +12.9%       1.52        GEO-MEAN perf-profile.cpu-cycles.smp_apic_timer_interrupt.apic_timer_interrupt.fsnotify.vfs_write.sys_pwrite64

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3507 ±  4%      +9.0%       3822 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      3507            +9.0%       3822        GEO-MEAN sched_debug.cfs_rq[28]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3537 ±  4%      +9.1%       3858 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3537            +9.1%       3858        GEO-MEAN sched_debug.cfs_rq[21]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.18 ±  5%      -8.0%       1.09 ±  6%  brickland1/will-it-scale/powersave-pwrite1
      1.18            -8.0%       1.09        GEO-MEAN perf-profile.cpu-cycles.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.89 ±  1%     -10.3%       1.70 ±  1%  brickland1/will-it-scale/powersave-pwrite1
      1.89           -10.3%       1.70        GEO-MEAN perf-profile.cpu-cycles.system_call.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3519 ±  5%      +9.5%       3855 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3519            +9.5%       3855        GEO-MEAN sched_debug.cfs_rq[19]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      5.84 ±  4%      -7.7%       5.40 ±  2%  brickland1/will-it-scale/powersave-pwrite1
      5.84            -7.7%       5.40        GEO-MEAN perf-profile.cpu-cycles.ktime_get_update_offsets.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     16504 ±  0%      -9.7%      14896 ±  1%  brickland1/will-it-scale/powersave-pwrite1
     16504            -9.7%      14896        GEO-MEAN slabinfo.kmalloc-192.active_objs

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     16506 ±  0%      -9.8%      14897 ±  1%  brickland1/will-it-scale/powersave-pwrite1
     16506            -9.8%      14897        GEO-MEAN slabinfo.kmalloc-192.num_objs

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     32046 ±  0%     +11.3%      35673 ±  0%  brickland1/will-it-scale/powersave-pwrite1
     32046           +11.3%      35673        GEO-MEAN sched_debug.cfs_rq[91]:/.exec_clock

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3521 ±  5%      +9.4%       3853 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3521            +9.4%       3853        GEO-MEAN sched_debug.cfs_rq[20]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.18 ±  5%      -7.8%       1.09 ±  6%  brickland1/will-it-scale/powersave-pwrite1
      1.18            -7.8%       1.09        GEO-MEAN perf-profile.cpu-cycles.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    853455 ±  1%     +10.8%     945556 ±  1%  brickland1/will-it-scale/powersave-pwrite1
    853455           +10.8%     945556        GEO-MEAN sched_debug.cpu#76.avg_idle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3519 ±  4%      +8.2%       3807 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3519            +8.2%       3807        GEO-MEAN sched_debug.cfs_rq[26]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.19 ±  4%      -7.9%       1.09 ±  5%  brickland1/will-it-scale/powersave-pwrite1
      1.19            -7.9%       1.09        GEO-MEAN perf-profile.cpu-cycles.smp_apic_timer_interrupt.apic_timer_interrupt.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    842339 ±  2%     +11.3%     937538 ±  1%  brickland1/will-it-scale/powersave-pwrite1
    842339           +11.3%     937537        GEO-MEAN sched_debug.cpu#64.avg_idle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     15887 ±  4%      +8.0%      17162 ±  3%  brickland1/will-it-scale/powersave-pwrite1
     15887            +8.0%      17162        GEO-MEAN sched_debug.cfs_rq[90]:/.avg->runnable_avg_sum

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       344 ±  4%      +7.7%        370 ±  3%  brickland1/will-it-scale/powersave-pwrite1
       344            +7.7%        370        GEO-MEAN sched_debug.cfs_rq[90]:/.tg_runnable_contrib

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1.21 ±  4%      -7.4%       1.12 ±  6%  brickland1/will-it-scale/powersave-pwrite1
      1.21            -7.4%       1.12        GEO-MEAN perf-profile.cpu-cycles.apic_timer_interrupt.__libc_pwrite

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    835125 ±  2%     +11.7%     932608 ±  2%  brickland1/will-it-scale/powersave-pwrite1
    835125           +11.7%     932608        GEO-MEAN sched_debug.cpu#69.avg_idle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3547 ±  4%      +9.3%       3879 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3547            +9.3%       3878        GEO-MEAN sched_debug.cfs_rq[22]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    835405 ±  1%     +10.3%     921248 ±  2%  brickland1/will-it-scale/powersave-pwrite1
    835405           +10.3%     921247        GEO-MEAN sched_debug.cpu#73.avg_idle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    412312 ± 29%     +32.7%     547007 ±  1%  brickland1/will-it-scale/powersave-pwrite1
    412312           +32.7%     547007        GEO-MEAN softirqs.SCHED

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    844305 ±  1%     +10.6%     933588 ±  2%  brickland1/will-it-scale/powersave-pwrite1
    844305           +10.6%     933587        GEO-MEAN sched_debug.cpu#65.avg_idle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
    833909 ±  1%     +11.6%     931037 ±  2%  brickland1/will-it-scale/powersave-pwrite1
    833909           +11.6%     931037        GEO-MEAN sched_debug.cpu#68.avg_idle

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     12247 ±  2%      +6.3%      13016 ±  4%  brickland1/will-it-scale/powersave-pwrite1
     12247            +6.3%      13016        GEO-MEAN sched_debug.cfs_rq[105]:/.avg->runnable_avg_sum

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      3526 ±  4%      +8.0%       3810 ±  3%  brickland1/will-it-scale/powersave-pwrite1
      3526            +8.0%       3810        GEO-MEAN sched_debug.cfs_rq[25]:/.tg_load_avg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      0.00 ±  0%    -100.0%       0.00 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      0.00          -100.0%       0.00        GEO-MEAN energy.energy-pkg

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      0.00 ±  0%    -100.0%       0.00 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      0.00          -100.0%       0.00        GEO-MEAN energy.energy-cores

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1220 ±  0%     -56.2%        534 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      1220           -56.2%        534        GEO-MEAN turbostat.Cor_W

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1233 ±  0%     -55.6%        547 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      1233           -55.6%        547        GEO-MEAN turbostat.Pkg_W

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
     66125 ±  0%     -12.5%      57879 ±  0%  brickland1/will-it-scale/powersave-pwrite1
     66125           -12.5%      57878        GEO-MEAN vmstat.system.in

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       495 ±  1%      -6.0%        465 ±  2%  brickland1/will-it-scale/powersave-pwrite1
       495            -6.0%        465        GEO-MEAN time.user_time

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
      1649 ±  0%      +3.1%       1700 ±  0%  brickland1/will-it-scale/powersave-pwrite1
      1649            +3.1%       1699        GEO-MEAN vmstat.system.cs

       v3.14-rc4  f3ca4164529b875374c410193b  
----------------  --------------------------  
       311 ±  0%      +1.0%        314 ±  0%  brickland1/will-it-scale/powersave-pwrite1
       311            +1.0%        314        GEO-MEAN time.elapsed_time




brickland1: Brickland Ivy Bridge-EX
Memory: 128G

testbox: fake
Memory: 12G




                                  time.elapsed_time

  314.5 O+---------------O----------------O----------------O----------------O
        |                                                                   |
    314 ++                                                                  |
        |                                                                   |
  313.5 ++                                                                  |
        |                                                                   |
    313 ++                                                                  |
        |                                                                   |
  312.5 ++                                                                  |
        |                                                                   |
    312 ++                                                                  |
        |                                                                   |
  311.5 ++                                                                  |
        *................*................*................*................*
    311 ++------------------------------------------------------------------+


                            will-it-scale.per_process_ops

  650000 ++-----------------------------------------------------------------+
         *................*................*...............*................*
  600000 ++                                                                 |
         |                                                                  |
  550000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
         |                                                                  |
  450000 ++                                                                 |
         |                                                                  |
  400000 ++                                                                 |
         |                                                                  |
  350000 ++                                                                 |
         O                O                O               O                O
  300000 ++-----------------------------------------------------------------+


                            will-it-scale.per_thread_ops

  600000 ++-----------------------------------------------------------------+
         *................*................*...............*................*
  550000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
         |                                                                  |
  450000 ++                                                                 |
         |                                                                  |
  400000 ++                                                                 |
         |                                                                  |
  350000 ++                                                                 |
         |                                                                  |
  300000 O+               O                O               O                O
         |                                                                  |
  250000 ++-----------------------------------------------------------------+



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

--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: will-it-scale
default_monitors:
  watch-oom: 
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
- powersave
model: Brickland Ivy Bridge-EX
nr_cpu: 120
memory: 128G
hdd_partitions: "/dev/sda2"
swap_partitions: 
perf-profile:
  freq: 800
will-it-scale:
  test:
  - pwrite1
branch: linus/master
commit: f3ca4164529b875374c410193bbbac0ee960895f
repeat_to: 2
enqueue_time: 2014-10-22 11:31:46.498477817 +08:00
testbox: brickland1
kconfig: x86_64-rhel
tbox_group: brickland1
user: lkp
queue: bisect
result_root: "/result/brickland1/will-it-scale/powersave-pwrite1/debian-x86_64.cgz/x86_64-rhel/f3ca4164529b875374c410193bbbac0ee960895f/0"
job_file: "/lkp/scheduled/brickland1/bisect_will-it-scale-powersave-pwrite1-x86_64-rhel-f3ca4164529b875374c410193bbbac0ee960895f-1.yaml"
history_time: 300
kernel: "/kernel/x86_64-rhel/f3ca4164529b875374c410193bbbac0ee960895f/vmlinuz-3.14.0-rc4-gf3ca416"
dequeue_time: 2014-10-22 11:43:21.520077865 +08:00
job_state: finished
loadavg: 81.71 39.71 15.71 1/964 14794
start_time: '1413949494'
end_time: '1413949808'
version: "/lkp/lkp/.src-20141021-224210"

--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu100/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu101/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu102/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu103/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu104/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu105/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu106/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu107/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu108/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu109/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu110/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu111/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu112/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu113/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu114/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu115/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu116/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu117/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu118/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu119/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu64/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu65/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu66/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu67/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu68/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu69/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu70/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu71/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu72/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu73/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu74/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu75/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu76/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu77/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu78/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu79/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu80/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu81/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu82/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu83/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu84/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu85/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu86/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu87/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu88/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu89/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu90/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu91/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu92/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu93/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu94/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu95/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu96/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu97/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu98/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu99/cpufreq/scaling_governor
./runtest.py pwrite1 16 1 15 30 45 60 90 120

--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--9/eUdp+dLtKXvemk--
