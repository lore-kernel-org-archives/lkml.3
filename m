Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKJFy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:54:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:58464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaKJFy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:54:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,350,1413270000"; 
   d="yaml'?scan'208";a="634262726"
Date: Mon, 10 Nov 2014 13:54:53 +0800
From: lkp@01.org
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sched] 9597d64116d: -16.1% hackbench.throughput
Message-ID: <20141110055453.GE1705@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5oH/S/bF6lOfqCQb"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

https://git.linaro.org/people/mturquette/linux.git eas-next
commit 9597d64116d0d441dea32e7f5f05fa135d16f44b ("sched: replace capacity_factor by usage")


b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
    104249 ±  0%     -16.1%      87436 ±  0%  ivb42/hackbench/performance-50%-threads-socket
    104249           -16.1%      87436        GEO-MEAN hackbench.throughput

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      0.88 ± 25%    +209.7%       2.74 ±  5%  ivb42/hackbench/performance-50%-threads-socket
      0.88          +209.7%       2.74        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_activate.constprop.87.sched_ttwu_pending.scheduler_ipi.smp_reschedule_interrupt.reschedule_interrupt

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      0.76 ± 26%    +209.2%       2.36 ±  5%  ivb42/hackbench/performance-50%-threads-socket
      0.76          +209.2%       2.36        GEO-MEAN perf-profile.cpu-cycles.activate_task.ttwu_do_activate.sched_ttwu_pending.scheduler_ipi.smp_reschedule_interrupt

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      0.76 ± 26%    +210.6%       2.35 ±  5%  ivb42/hackbench/performance-50%-threads-socket
      0.76          +210.6%       2.35        GEO-MEAN perf-profile.cpu-cycles.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending.scheduler_ipi

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      0.70 ± 25%    +203.1%       2.13 ±  6%  ivb42/hackbench/performance-50%-threads-socket
      0.70          +203.1%       2.13        GEO-MEAN perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    243252 ± 46%    +242.5%     833240 ± 42%  ivb42/hackbench/performance-50%-threads-socket
    243252          +242.5%     833240        GEO-MEAN sched_debug.cfs_rq[2]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        98 ± 36%     -49.1%         50 ± 34%  ivb42/hackbench/performance-50%-threads-socket
        98           -49.1%         50        GEO-MEAN sched_debug.cfs_rq[18]:/.blocked_load_avg

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1067752 ± 25%     +65.3%    1764542 ± 11%  ivb42/hackbench/performance-50%-threads-socket
   1067752           +65.3%    1764542        GEO-MEAN sched_debug.cfs_rq[16]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    923375 ± 22%     +96.3%    1812750 ± 21%  ivb42/hackbench/performance-50%-threads-socket
    923375           +96.3%    1812750        GEO-MEAN sched_debug.cfs_rq[14]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1008818 ± 20%     +70.9%    1724167 ± 14%  ivb42/hackbench/performance-50%-threads-socket
   1008818           +70.9%    1724167        GEO-MEAN sched_debug.cfs_rq[6]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1109100 ± 25%     +53.9%    1707190 ± 16%  ivb42/hackbench/performance-50%-threads-socket
   1109100           +53.9%    1707190        GEO-MEAN sched_debug.cfs_rq[15]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1006499 ± 33%     +67.8%    1688436 ± 22%  ivb42/hackbench/performance-50%-threads-socket
   1006499           +67.8%    1688436        GEO-MEAN sched_debug.cfs_rq[13]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    915637 ± 16%     +93.4%    1771080 ± 18%  ivb42/hackbench/performance-50%-threads-socket
    915637           +93.4%    1771080        GEO-MEAN sched_debug.cfs_rq[7]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    783024 ± 10%     +67.2%    1309563 ± 22%  ivb42/hackbench/performance-50%-threads-socket
    783024           +67.2%    1309563        GEO-MEAN sched_debug.cfs_rq[5]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     16155 ±  3%     +66.8%      26952 ±  3%  ivb42/hackbench/performance-50%-threads-socket
     16155           +66.8%      26952        GEO-MEAN proc-vmstat.numa_pages_migrated

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     16155 ±  3%     +66.8%      26952 ±  3%  ivb42/hackbench/performance-50%-threads-socket
     16155           +66.8%      26952        GEO-MEAN proc-vmstat.pgmigrate_success

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1443204 ± 24%     +51.5%    2187058 ±  6%  ivb42/hackbench/performance-50%-threads-socket
   1443204           +51.5%    2187058        GEO-MEAN sched_debug.cfs_rq[23]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      2.26 ±  4%     -38.0%       1.40 ±  4%  ivb42/hackbench/performance-50%-threads-socket
      2.26           -38.0%       1.40        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1203841 ± 25%     +53.0%    1842451 ± 19%  ivb42/hackbench/performance-50%-threads-socket
   1203841           +53.0%    1842451        GEO-MEAN sched_debug.cfs_rq[17]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
       119 ± 32%     -41.7%         69 ± 23%  ivb42/hackbench/performance-50%-threads-socket
       119           -41.7%         69        GEO-MEAN sched_debug.cfs_rq[18]:/.tg_load_contrib

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1128380 ± 24%     +67.1%    1886076 ± 15%  ivb42/hackbench/performance-50%-threads-socket
   1128380           +67.1%    1886076        GEO-MEAN sched_debug.cfs_rq[8]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     35577 ± 20%     +42.9%      50840 ± 15%  ivb42/hackbench/performance-50%-threads-socket
     35577           +42.9%      50840        GEO-MEAN sched_debug.cpu#11.avg_idle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      4.45 ±  4%     -35.2%       2.88 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      4.45           -35.2%       2.88        GEO-MEAN perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1230679 ±  9%     +65.1%    2032295 ± 14%  ivb42/hackbench/performance-50%-threads-socket
   1230679           +65.1%    2032295        GEO-MEAN sched_debug.cfs_rq[10]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      6.42 ±  4%     -33.1%       4.30 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      6.42           -33.1%       4.30        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_activate.constprop.87.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      5.13 ±  4%     -33.8%       3.40 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      5.13           -33.8%       3.40        GEO-MEAN perf-profile.cpu-cycles.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up.default_wake_function

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      5.14 ±  4%     -33.8%       3.41 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      5.14           -33.8%       3.41        GEO-MEAN perf-profile.cpu-cycles.activate_task.ttwu_do_activate.try_to_wake_up.default_wake_function.autoremove_wake_function

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.11 ±  3%     -29.1%       0.78 ±  4%  ivb42/hackbench/performance-50%-threads-socket
      1.11           -29.1%       0.78        GEO-MEAN perf-profile.cpu-cycles.check_preempt_curr.ttwu_do_wakeup.ttwu_do_activate.try_to_wake_up.default_wake_function

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.22 ±  3%     -29.1%       0.87 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      1.22           -29.1%       0.87        GEO-MEAN perf-profile.cpu-cycles.ttwu_do_wakeup.ttwu_do_activate.try_to_wake_up.default_wake_function.autoremove_wake_function

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1357971 ± 14%     +41.3%    1918898 ±  9%  ivb42/hackbench/performance-50%-threads-socket
   1357971           +41.3%    1918898        GEO-MEAN sched_debug.cfs_rq[9]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1304331 ± 11%     +49.2%    1946271 ± 13%  ivb42/hackbench/performance-50%-threads-socket
   1304331           +49.2%    1946271        GEO-MEAN sched_debug.cfs_rq[11]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
       608 ±  3%     -28.7%        433 ±  4%  ivb42/hackbench/performance-50%-threads-socket
       608           -28.7%        433        GEO-MEAN cpuidle.POLL.usage

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    424656 ±  2%     +37.7%     584637 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    424656           +37.7%     584637        GEO-MEAN cpuidle.C6-IVT.usage

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1508175 ± 18%     +37.7%    2076043 ± 16%  ivb42/hackbench/performance-50%-threads-socket
   1508175           +37.7%    2076043        GEO-MEAN sched_debug.cfs_rq[21]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    287269 ±  4%     +32.4%     380327 ±  6%  ivb42/hackbench/performance-50%-threads-socket
    287268           +32.4%     380326        GEO-MEAN proc-vmstat.numa_hint_faults

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22221059 ±  1%     -25.7%   16516998 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  22221059           -25.7%   16516998        GEO-MEAN sched_debug.cpu#23.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1468667 ± 15%     +43.2%    2102926 ±  9%  ivb42/hackbench/performance-50%-threads-socket
   1468667           +43.2%    2102926        GEO-MEAN sched_debug.cfs_rq[22]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    291407 ±  4%     +31.7%     383859 ±  6%  ivb42/hackbench/performance-50%-threads-socket
    291407           +31.7%     383859        GEO-MEAN proc-vmstat.numa_pte_updates

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20399319 ±  1%     -24.9%   15320065 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20399319           -24.9%   15320065        GEO-MEAN sched_debug.cpu#47.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21955842 ±  1%     -25.2%   16425955 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21955842           -25.2%   16425955        GEO-MEAN sched_debug.cpu#19.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21384750 ±  0%     -24.7%   16103640 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  21384750           -24.7%   16103640        GEO-MEAN sched_debug.cpu#21.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19455420 ±  1%     -24.4%   14708872 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  19455420           -24.4%   14708872        GEO-MEAN sched_debug.cpu#44.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.48 ±  4%     -23.7%       1.13 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.48           -23.7%       1.13        GEO-MEAN perf-profile.cpu-cycles.__switch_to

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      2.70 ±  5%     +27.7%       3.45 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      2.70           +27.7%       3.45        GEO-MEAN perf-profile.cpu-cycles.idle_cpu.select_idle_sibling.select_task_rq_fair.try_to_wake_up.default_wake_function

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20991987 ±  0%     -24.1%   15929117 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  20991987           -24.1%   15929117        GEO-MEAN sched_debug.cpu#20.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20232670 ±  1%     -24.7%   15244668 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20232670           -24.7%   15244668        GEO-MEAN sched_debug.cpu#43.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21686213 ±  1%     -24.5%   16369380 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21686213           -24.5%   16369380        GEO-MEAN sched_debug.cpu#12.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21654231 ±  1%     -24.3%   16385202 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21654231           -24.3%   16385202        GEO-MEAN sched_debug.cpu#13.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19800323 ±  1%     -24.6%   14937832 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19800323           -24.6%   14937832        GEO-MEAN sched_debug.cpu#45.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20091416 ±  0%     -24.4%   15193784 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  20091416           -24.4%   15193784        GEO-MEAN sched_debug.cpu#38.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19904854 ±  1%     -24.2%   15083433 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19904854           -24.2%   15083433        GEO-MEAN sched_debug.cpu#36.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20172173 ±  0%     -24.0%   15328449 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20172173           -24.0%   15328448        GEO-MEAN sched_debug.cpu#39.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.25 ±  2%     -25.4%       0.93 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.25           -25.4%       0.93        GEO-MEAN perf-profile.cpu-cycles.update_cfs_shares.dequeue_entity.dequeue_task_fair.dequeue_task.deactivate_task

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21661306 ±  0%     -24.2%   16411873 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21661306           -24.2%   16411873        GEO-MEAN sched_debug.cpu#14.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21896234 ±  0%     -24.2%   16598293 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  21896234           -24.2%   16598293        GEO-MEAN sched_debug.cpu#15.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19221661 ±  1%     -23.7%   14665426 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  19221661           -23.7%   14665426        GEO-MEAN sched_debug.cpu#40.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21058318 ±  1%     -24.2%   15959916 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21058318           -24.2%   15959916        GEO-MEAN sched_debug.cpu#17.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21754207 ±  0%     -24.2%   16487812 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  21754207           -24.2%   16487812        GEO-MEAN sched_debug.cpu#22.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19963010 ±  1%     -24.1%   15143746 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19963009           -24.1%   15143746        GEO-MEAN sched_debug.cpu#37.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20748744 ±  1%     -23.7%   15832368 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  20748743           -23.7%   15832368        GEO-MEAN sched_debug.cpu#16.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19955834 ±  0%     -23.9%   15189591 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19955834           -23.9%   15189591        GEO-MEAN sched_debug.cpu#46.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26674784 ±  1%     -23.1%   20500535 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26674784           -23.1%   20500535        GEO-MEAN sched_debug.cpu#22.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26689071 ±  1%     -23.1%   20511407 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26689071           -23.1%   20511407        GEO-MEAN sched_debug.cpu#22.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21264995 ±  1%     -23.6%   16250715 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21264995           -23.6%   16250715        GEO-MEAN sched_debug.cpu#18.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19641786 ±  1%     -23.5%   15029146 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19641786           -23.5%   15029146        GEO-MEAN sched_debug.cpu#42.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     26923 ±  2%     +29.2%      34786 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     26923           +29.2%      34786        GEO-MEAN cpuidle.C3-IVT.usage

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19417423 ±  1%     -23.3%   14891714 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19417423           -23.3%   14891714        GEO-MEAN sched_debug.cpu#41.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26079901 ±  0%     -22.7%   20147877 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26079901           -22.7%   20147877        GEO-MEAN sched_debug.cpu#18.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26104071 ±  0%     -22.7%   20165898 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26104071           -22.7%   20165898        GEO-MEAN sched_debug.cpu#18.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25569796 ±  0%     -21.9%   19978756 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25569796           -21.9%   19978756        GEO-MEAN sched_debug.cpu#14.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25580176 ±  0%     -21.8%   19998098 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25580176           -21.8%   19998098        GEO-MEAN sched_debug.cpu#14.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1336731 ± 24%     +41.1%    1886101 ± 10%  ivb42/hackbench/performance-50%-threads-socket
   1336731           +41.1%    1886101        GEO-MEAN sched_debug.cfs_rq[18]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   7138831 ±  1%     -22.1%    5563134 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   7138831           -22.1%    5563134        GEO-MEAN proc-vmstat.pgfree

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   7160822 ±  1%     -22.0%    5584442 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   7160822           -22.0%    5584442        GEO-MEAN proc-vmstat.pgalloc_normal

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25705305 ±  0%     -22.1%   20026342 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25705305           -22.1%   20026342        GEO-MEAN sched_debug.cpu#15.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26577794 ±  0%     -22.0%   20738980 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26577794           -22.0%   20738980        GEO-MEAN sched_debug.cpu#23.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25887804 ±  0%     -21.3%   20372718 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25887804           -21.3%   20372718        GEO-MEAN sched_debug.cpu#19.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25686569 ±  1%     -21.6%   20148163 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25686569           -21.6%   20148163        GEO-MEAN sched_debug.cpu#13.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25905972 ±  0%     -21.3%   20386581 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25905972           -21.3%   20386581        GEO-MEAN sched_debug.cpu#19.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26595019 ±  0%     -21.8%   20795049 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26595019           -21.8%   20795049        GEO-MEAN sched_debug.cpu#23.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25682384 ±  0%     -22.1%   20009219 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25682384           -22.1%   20009218        GEO-MEAN sched_debug.cpu#15.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25625064 ±  1%     -21.6%   20086187 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25625064           -21.6%   20086187        GEO-MEAN sched_debug.cpu#13.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26289191 ±  1%     -21.5%   20639754 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26289191           -21.5%   20639754        GEO-MEAN sched_debug.cpu#20.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26272949 ±  1%     -21.5%   20616474 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26272949           -21.5%   20616474        GEO-MEAN sched_debug.cpu#20.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25785235 ±  0%     -21.6%   20221040 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25785235           -21.6%   20221040        GEO-MEAN sched_debug.cpu#12.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25525885 ±  0%     -21.5%   20037162 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25525885           -21.5%   20037162        GEO-MEAN sched_debug.cpu#17.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25575741 ±  0%     -21.4%   20104812 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25575741           -21.4%   20104812        GEO-MEAN sched_debug.cpu#17.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25842972 ±  0%     -21.5%   20284708 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25842972           -21.5%   20284708        GEO-MEAN sched_debug.cpu#12.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25395850 ±  0%     -21.3%   19996864 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25395850           -21.3%   19996864        GEO-MEAN sched_debug.cpu#16.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25385835 ±  0%     -21.3%   19979026 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25385835           -21.3%   19979026        GEO-MEAN sched_debug.cpu#16.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26295715 ±  1%     -21.6%   20610286 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26295715           -21.6%   20610286        GEO-MEAN sched_debug.cpu#21.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26311333 ±  1%     -21.6%   20632524 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26311333           -21.6%   20632524        GEO-MEAN sched_debug.cpu#21.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30824379 ±  1%     -20.1%   24621183 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30824379           -20.1%   24621183        GEO-MEAN sched_debug.cpu#42.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30849469 ±  1%     -20.1%   24636230 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30849469           -20.1%   24636230        GEO-MEAN sched_debug.cpu#42.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31513770 ±  0%     -20.1%   25180158 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31513770           -20.1%   25180158        GEO-MEAN sched_debug.cpu#46.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31530459 ±  0%     -20.1%   25191647 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31530459           -20.1%   25191647        GEO-MEAN sched_debug.cpu#46.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     31534 ± 13%     +41.8%      44720 ± 14%  ivb42/hackbench/performance-50%-threads-socket
     31534           +41.8%      44720        GEO-MEAN sched_debug.cpu#38.avg_idle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3311434 ±  8%     +19.3%    3950522 ± 12%  ivb42/hackbench/performance-50%-threads-socket
   3311434           +19.3%    3950522        GEO-MEAN sched_debug.cfs_rq[46]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25599960 ±  0%     -19.5%   20605928 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25599960           -19.5%   20605928        GEO-MEAN sched_debug.cpu#0.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25587783 ±  0%     -19.5%   20590387 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25587783           -19.5%   20590387        GEO-MEAN sched_debug.cpu#0.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30196745 ±  1%     -19.4%   24347741 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30196745           -19.4%   24347740        GEO-MEAN sched_debug.cpu#41.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   2845181 ± 10%     +25.9%    3581780 ±  9%  ivb42/hackbench/performance-50%-threads-socket
   2845181           +25.9%    3581780        GEO-MEAN sched_debug.cfs_rq[40]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30227050 ±  1%     -19.3%   24406165 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30227049           -19.3%   24406164        GEO-MEAN sched_debug.cpu#41.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30720180 ±  0%     -19.4%   24772598 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30720180           -19.4%   24772598        GEO-MEAN sched_debug.cpu#36.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30769646 ±  1%     -19.3%   24823365 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30769646           -19.3%   24823365        GEO-MEAN sched_debug.cpu#36.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30527777 ±  1%     -19.2%   24677022 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30527776           -19.2%   24677022        GEO-MEAN sched_debug.cpu#37.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     22044 ±  1%     +25.8%      27733 ±  3%  ivb42/hackbench/performance-50%-threads-socket
     22044           +25.8%      27733        GEO-MEAN cpuidle.C1E-IVT.usage

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3387494 ±  6%     +16.9%    3960647 ±  7%  ivb42/hackbench/performance-50%-threads-socket
   3387494           +16.9%    3960647        GEO-MEAN sched_debug.cfs_rq[33]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31508807 ±  0%     -19.2%   25447218 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31508807           -19.2%   25447218        GEO-MEAN sched_debug.cpu#47.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30884674 ±  0%     -18.7%   25097824 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30884674           -18.7%   25097824        GEO-MEAN sched_debug.cpu#24.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31529669 ±  0%     -19.1%   25504070 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31529669           -19.1%   25504070        GEO-MEAN sched_debug.cpu#47.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30891431 ±  0%     -18.7%   25116019 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30891431           -18.7%   25116019        GEO-MEAN sched_debug.cpu#24.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   2877453 ±  6%     +25.4%    3608032 ±  6%  ivb42/hackbench/performance-50%-threads-socket
   2877453           +25.4%    3608032        GEO-MEAN sched_debug.cfs_rq[26]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30686015 ±  0%     -19.0%   24852515 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30686015           -19.0%   24852515        GEO-MEAN sched_debug.cpu#43.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30567772 ±  1%     -19.1%   24719285 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30567772           -19.1%   24719285        GEO-MEAN sched_debug.cpu#37.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30700393 ±  0%     -19.0%   24871670 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30700393           -19.0%   24871669        GEO-MEAN sched_debug.cpu#43.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25429518 ±  0%     -19.0%   20597694 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25429518           -19.0%   20597693        GEO-MEAN sched_debug.cpu#1.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30426640 ±  0%     -18.9%   24661763 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30426640           -18.9%   24661762        GEO-MEAN sched_debug.cpu#38.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25437824 ±  0%     -19.0%   20602002 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25437824           -19.0%   20602002        GEO-MEAN sched_debug.cpu#1.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30443857 ±  0%     -18.9%   24679394 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30443857           -18.9%   24679394        GEO-MEAN sched_debug.cpu#38.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3170186 ± 12%     +20.8%    3830642 ±  8%  ivb42/hackbench/performance-50%-threads-socket
   3170186           +20.8%    3830642        GEO-MEAN sched_debug.cfs_rq[41]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30345040 ±  1%     -18.8%   24632965 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30345040           -18.8%   24632965        GEO-MEAN sched_debug.cpu#39.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30316596 ±  1%     -18.8%   24607293 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30316596           -18.8%   24607293        GEO-MEAN sched_debug.cpu#39.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  29982666 ±  0%     -18.4%   24458570 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  29982666           -18.4%   24458570        GEO-MEAN sched_debug.cpu#40.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  29960708 ±  0%     -18.4%   24438001 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  29960708           -18.4%   24438001        GEO-MEAN sched_debug.cpu#40.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31047087 ±  1%     -19.2%   25085514 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31047087           -19.2%   25085514        GEO-MEAN sched_debug.cpu#45.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31032942 ±  1%     -19.2%   25067720 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31032942           -19.2%   25067720        GEO-MEAN sched_debug.cpu#45.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25578650 ±  1%     -18.4%   20864649 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25578650           -18.4%   20864649        GEO-MEAN sched_debug.cpu#4.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.53 ±  3%     +23.0%       1.88 ±  7%  ivb42/hackbench/performance-50%-threads-socket
      1.53           +23.0%       1.88        GEO-MEAN perf-profile.cpu-cycles.fput.system_call_fastpath

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25532967 ±  1%     -18.3%   20857796 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25532967           -18.3%   20857796        GEO-MEAN sched_debug.cpu#4.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3155171 ±  2%     +19.0%    3753143 ±  4%  ivb42/hackbench/performance-50%-threads-socket
   3155171           +19.0%    3753143        GEO-MEAN sched_debug.cfs_rq[31]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26700103 ±  1%     -19.1%   21595767 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  26700103           -19.1%   21595767        GEO-MEAN sched_debug.cpu#9.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26710729 ±  1%     -19.1%   21602428 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  26710729           -19.1%   21602428        GEO-MEAN sched_debug.cpu#9.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31156436 ±  0%     -18.7%   25325830 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31156435           -18.7%   25325830        GEO-MEAN sched_debug.cpu#44.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31140524 ±  0%     -18.8%   25300128 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31140524           -18.8%   25300128        GEO-MEAN sched_debug.cpu#44.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26524961 ±  0%     -17.8%   21793394 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  26524961           -17.8%   21793394        GEO-MEAN sched_debug.cpu#10.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3335586 ±  3%     +22.0%    4070327 ±  8%  ivb42/hackbench/performance-50%-threads-socket
   3335586           +22.0%    4070327        GEO-MEAN sched_debug.cfs_rq[34]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25755165 ±  0%     -18.0%   21119793 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25755165           -18.0%   21119793        GEO-MEAN sched_debug.cpu#6.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25808917 ±  0%     -18.1%   21133286 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25808917           -18.1%   21133286        GEO-MEAN sched_debug.cpu#6.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31373706 ±  0%     -18.0%   25734789 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31373706           -18.0%   25734789        GEO-MEAN sched_debug.cpu#33.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31356060 ±  0%     -17.9%   25728656 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  31356060           -17.9%   25728656        GEO-MEAN sched_debug.cpu#33.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26544024 ±  0%     -17.7%   21833203 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  26544024           -17.7%   21833203        GEO-MEAN sched_debug.cpu#10.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26226903 ±  1%     -17.9%   21539753 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  26226903           -17.9%   21539753        GEO-MEAN sched_debug.cpu#8.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26216240 ±  1%     -17.9%   21529356 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  26216240           -17.9%   21529356        GEO-MEAN sched_debug.cpu#8.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26008985 ±  0%     -17.3%   21498163 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26008985           -17.3%   21498162        GEO-MEAN sched_debug.cpu#7.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25640553 ±  0%     -18.0%   21025853 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25640553           -18.0%   21025853        GEO-MEAN sched_debug.cpu#5.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25624862 ±  0%     -18.0%   21018684 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  25624862           -18.0%   21018684        GEO-MEAN sched_debug.cpu#5.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26021354 ±  0%     -17.3%   21510179 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26021354           -17.3%   21510179        GEO-MEAN sched_debug.cpu#7.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    254353 ±  4%     +18.7%     302028 ±  7%  ivb42/hackbench/performance-50%-threads-socket
    254353           +18.7%     302028        GEO-MEAN proc-vmstat.numa_hint_faults_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25398742 ±  1%     -18.1%   20807675 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25398742           -18.1%   20807675        GEO-MEAN sched_debug.cpu#3.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25405187 ±  1%     -18.1%   20818635 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25405187           -18.1%   20818635        GEO-MEAN sched_debug.cpu#3.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    881319 ±  1%     -16.5%     735645 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    881319           -16.5%     735645        GEO-MEAN sched_debug.cpu#19.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30533255 ±  0%     -17.4%   25208231 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30533255           -17.4%   25208231        GEO-MEAN sched_debug.cpu#25.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26692010 ±  0%     -17.7%   21973527 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26692010           -17.7%   21973527        GEO-MEAN sched_debug.cpu#11.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  26676971 ±  0%     -17.7%   21964784 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  26676971           -17.7%   21964784        GEO-MEAN sched_debug.cpu#11.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30548238 ±  0%     -17.4%   25222173 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30548238           -17.4%   25222173        GEO-MEAN sched_debug.cpu#25.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30313545 ±  1%     -17.1%   25125827 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30313545           -17.1%   25125827        GEO-MEAN sched_debug.cpu#26.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30325190 ±  1%     -17.1%   25139575 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30325190           -17.1%   25139575        GEO-MEAN sched_debug.cpu#26.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30298989 ±  0%     -17.1%   25132450 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30298989           -17.1%   25132450        GEO-MEAN sched_debug.cpu#28.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30364476 ±  0%     -17.2%   25142879 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30364476           -17.2%   25142879        GEO-MEAN sched_debug.cpu#28.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      3.63 ±  3%     +17.9%       4.29 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      3.63           +17.9%       4.29        GEO-MEAN perf-profile.cpu-cycles.select_idle_sibling.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    885971 ±  1%     -17.6%     730417 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    885971           -17.6%     730417        GEO-MEAN sched_debug.cpu#22.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.61 ±  1%     -14.9%       1.37 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.61           -14.9%       1.37        GEO-MEAN perf-profile.cpu-cycles.pick_next_task_fair.__sched_text_start.schedule.schedule_timeout.unix_stream_recvmsg

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1487383 ±  1%     -17.0%    1233892 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1487383           -17.0%    1233892        GEO-MEAN sched_debug.cpu#22.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    873433 ±  1%     -15.8%     735098 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    873433           -15.8%     735098        GEO-MEAN sched_debug.cpu#12.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25242747 ±  1%     -18.0%   20695565 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25242747           -18.0%   20695565        GEO-MEAN sched_debug.cpu#2.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  25252993 ±  1%     -18.0%   20700339 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  25252993           -18.0%   20700338        GEO-MEAN sched_debug.cpu#2.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    876946 ±  1%     -16.9%     728531 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    876946           -16.9%     728531        GEO-MEAN sched_debug.cpu#21.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30929790 ±  1%     -16.7%   25766295 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30929790           -16.7%   25766295        GEO-MEAN sched_debug.cpu#32.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30944860 ±  1%     -16.7%   25778928 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  30944860           -16.7%   25778928        GEO-MEAN sched_debug.cpu#32.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31340929 ±  0%     -16.7%   26094438 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  31340929           -16.7%   26094438        GEO-MEAN sched_debug.cpu#34.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31354076 ±  0%     -16.7%   26120882 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  31354075           -16.7%   26120882        GEO-MEAN sched_debug.cpu#34.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      3.01 ±  2%     -18.4%       2.46 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      3.01           -18.4%       2.46        GEO-MEAN perf-profile.cpu-cycles.dequeue_entity.dequeue_task_fair.dequeue_task.deactivate_task.__sched_text_start

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    884857 ±  0%     -16.3%     741031 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    884857           -16.3%     741031        GEO-MEAN sched_debug.cpu#23.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22693545 ±  0%     -16.6%   18915402 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  22693545           -16.6%   18915402        GEO-MEAN sched_debug.cpu#11.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30424082 ±  0%     -16.8%   25305405 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30424082           -16.8%   25305405        GEO-MEAN sched_debug.cpu#30.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30485250 ±  0%     -16.9%   25323543 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30485250           -16.9%   25323542        GEO-MEAN sched_debug.cpu#30.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30917867 ±  0%     -16.9%   25707653 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30917867           -16.9%   25707653        GEO-MEAN sched_debug.cpu#31.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30924268 ±  0%     -16.8%   25716265 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30924268           -16.8%   25716265        GEO-MEAN sched_debug.cpu#31.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30468014 ±  1%     -17.2%   25213426 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30468014           -17.2%   25213426        GEO-MEAN sched_debug.cpu#27.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30477512 ±  1%     -17.2%   25229055 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30477512           -17.2%   25229055        GEO-MEAN sched_debug.cpu#27.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30130205 ±  0%     -16.7%   25101385 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30130205           -16.7%   25101385        GEO-MEAN sched_debug.cpu#29.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22458882 ±  0%     -16.7%   18703491 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  22458882           -16.7%   18703491        GEO-MEAN sched_debug.cpu#10.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  30140313 ±  0%     -16.7%   25115800 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  30140313           -16.7%   25115800        GEO-MEAN sched_debug.cpu#29.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    868193 ±  1%     -15.6%     732542 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    868193           -15.6%     732542        GEO-MEAN sched_debug.cpu#13.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1374659 ± 25%     +37.8%    1894017 ±  8%  ivb42/hackbench/performance-50%-threads-socket
   1374659           +37.8%    1894017        GEO-MEAN sched_debug.cfs_rq[19]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20829936 ±  0%     -17.0%   17279112 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20829936           -17.0%   17279112        GEO-MEAN sched_debug.cpu#35.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1418996 ±  0%     -16.4%    1186744 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1418996           -16.4%    1186744        GEO-MEAN sched_debug.cpu#16.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31557915 ±  0%     -16.4%   26383001 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  31557915           -16.4%   26383001        GEO-MEAN sched_debug.cpu#35.nr_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  31570143 ±  0%     -16.4%   26389314 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  31570143           -16.4%   26389314        GEO-MEAN sched_debug.cpu#35.sched_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1420038 ±  1%     -16.0%    1193250 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1420038           -16.0%    1193250        GEO-MEAN sched_debug.cpu#13.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1450656 ±  1%     -17.1%    1202921 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1450656           -17.1%    1202921        GEO-MEAN sched_debug.cpu#18.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20626695 ±  0%     -16.6%   17207030 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20626695           -16.6%   17207030        GEO-MEAN sched_debug.cpu#31.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22476314 ±  1%     -16.3%   18802789 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  22476314           -16.3%   18802789        GEO-MEAN sched_debug.cpu#7.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20008939 ±  0%     -15.6%   16896437 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20008939           -15.6%   16896437        GEO-MEAN sched_debug.cpu#32.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1447302 ±  0%     -16.4%    1210584 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1447302           -16.4%    1210584        GEO-MEAN sched_debug.cpu#19.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1429701 ±  1%     -16.2%    1198182 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1429701           -16.2%    1198181        GEO-MEAN sched_debug.cpu#15.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    872462 ±  0%     -15.4%     737745 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    872462           -15.4%     737745        GEO-MEAN sched_debug.cpu#15.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.53 ±  3%     -16.4%       1.28 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      1.53           -16.4%       1.28        GEO-MEAN perf-profile.cpu-cycles.update_cfs_shares.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20534273 ±  1%     -15.8%   17284516 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  20534273           -15.8%   17284516        GEO-MEAN sched_debug.cpu#25.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20560704 ±  0%     -16.2%   17227893 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20560704           -16.2%   17227893        GEO-MEAN sched_debug.cpu#34.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    862442 ±  0%     -15.1%     732316 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    862442           -15.1%     732316        GEO-MEAN sched_debug.cpu#14.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1443239 ±  0%     -16.5%    1205709 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1443239           -16.5%    1205709        GEO-MEAN sched_debug.cpu#12.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      0.98 ±  3%     +20.0%       1.18 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      0.98           +20.0%       1.18        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.skb_queue_tail.unix_stream_sendmsg.sock_aio_write.do_sync_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1487380 ±  1%     -16.3%    1244520 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1487380           -16.3%    1244520        GEO-MEAN sched_debug.cpu#23.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
 1.356e+08 ±  0%     -15.5%  1.147e+08 ±  0%  ivb42/hackbench/performance-50%-threads-socket
 1.356e+08           -15.5%  1.147e+08        GEO-MEAN cpuidle.C1-IVT.usage

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20314951 ±  0%     -15.6%   17140944 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20314951           -15.6%   17140944        GEO-MEAN sched_debug.cpu#30.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1473950 ±  1%     -16.2%    1235367 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1473950           -16.2%    1235367        GEO-MEAN sched_debug.cpu#20.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    867410 ±  1%     -15.8%     730524 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    867410           -15.8%     730524        GEO-MEAN sched_debug.cpu#20.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.33 ±  2%     -16.4%       1.11 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.33           -16.4%       1.11        GEO-MEAN perf-profile.cpu-cycles.__sched_text_start.schedule_user.sysret_careful

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1472841 ±  1%     -15.7%    1241382 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1472841           -15.7%    1241382        GEO-MEAN sched_debug.cpu#21.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1423709 ±  0%     -15.8%    1198274 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1423709           -15.8%    1198274        GEO-MEAN sched_debug.cpu#17.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    851770 ±  0%     -15.3%     721480 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    851770           -15.3%     721480        GEO-MEAN sched_debug.cpu#17.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.40 ±  2%     -16.1%       1.17 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.40           -16.1%       1.17        GEO-MEAN perf-profile.cpu-cycles.sysret_careful

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21736276 ±  0%     -15.7%   18334370 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  21736276           -15.7%   18334370        GEO-MEAN sched_debug.cpu#8.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1417611 ±  1%     -16.1%    1189420 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1417611           -16.1%    1189420        GEO-MEAN sched_debug.cpu#14.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20609132 ±  0%     -15.8%   17362846 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  20609132           -15.8%   17362846        GEO-MEAN sched_debug.cpu#26.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22069167 ±  0%     -15.4%   18674407 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  22069167           -15.4%   18674407        GEO-MEAN sched_debug.cpu#6.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   2820456 ±  4%     +23.4%    3479484 ±  7%  ivb42/hackbench/performance-50%-threads-socket
   2820456           +23.4%    3479484        GEO-MEAN sched_debug.cfs_rq[27]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20618809 ±  0%     -15.7%   17385264 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20618809           -15.7%   17385264        GEO-MEAN sched_debug.cpu#27.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19897448 ±  1%     -15.2%   16867976 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  19897448           -15.2%   16867976        GEO-MEAN sched_debug.cpu#29.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22444826 ±  1%     -14.2%   19266125 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  22444826           -14.2%   19266125        GEO-MEAN sched_debug.cpu#0.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3341263 ± 11%     +20.3%    4019480 ±  4%  ivb42/hackbench/performance-50%-threads-socket
   3341263           +20.3%    4019480        GEO-MEAN sched_debug.cfs_rq[45]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22509799 ±  0%     -15.2%   19080882 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  22509799           -15.2%   19080882        GEO-MEAN sched_debug.cpu#2.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22483652 ±  1%     -15.0%   19119883 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  22483652           -15.0%   19119883        GEO-MEAN sched_debug.cpu#1.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20020943 ±  0%     -14.5%   17120192 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  20020943           -14.5%   17120192        GEO-MEAN sched_debug.cpu#33.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21609616 ±  0%     -14.6%   18459478 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  21609616           -14.6%   18459478        GEO-MEAN sched_debug.cpu#5.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  19520181 ±  0%     -14.6%   16662350 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  19520181           -14.6%   16662349        GEO-MEAN sched_debug.cpu#28.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.37 ±  3%     -15.6%       1.15 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.37           -15.6%       1.15        GEO-MEAN perf-profile.cpu-cycles.schedule_user.sysret_careful

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  22662241 ±  0%     -15.3%   19188484 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  22662241           -15.3%   19188484        GEO-MEAN sched_debug.cpu#3.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    866621 ±  1%     -15.9%     728734 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    866621           -15.9%     728734        GEO-MEAN sched_debug.cpu#18.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1039319 ±  1%     -14.8%     885271 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1039319           -14.8%     885271        GEO-MEAN numa-numastat.node0.local_node

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21798079 ±  1%     -14.6%   18621574 ±  1%  ivb42/hackbench/performance-50%-threads-socket
  21798079           -14.6%   18621574        GEO-MEAN sched_debug.cpu#9.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3043317 ±  9%     +25.3%    3814417 ± 13%  ivb42/hackbench/performance-50%-threads-socket
   3043317           +25.3%    3814417        GEO-MEAN sched_debug.cfs_rq[38]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  20231936 ±  0%     -13.8%   17436914 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  20231936           -13.8%   17436914        GEO-MEAN sched_debug.cpu#24.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        20 ±  4%     -10.7%         18 ±  5%  ivb42/hackbench/performance-50%-threads-socket
        20           -10.7%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[0]

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        20 ±  3%      -9.8%         18 ±  5%  ivb42/hackbench/performance-50%-threads-socket
        20            -9.8%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[1]

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      0.92 ±  3%     +16.1%       1.07 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      0.92           +16.1%       1.07        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
  21278578 ±  0%     -14.0%   18299464 ±  0%  ivb42/hackbench/performance-50%-threads-socket
  21278578           -14.0%   18299464        GEO-MEAN sched_debug.cpu#4.ttwu_count

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1043155 ±  1%     -14.6%     891335 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1043155           -14.6%     891335        GEO-MEAN numa-numastat.node0.numa_hit

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    860946 ±  1%     -13.4%     745561 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    860946           -13.4%     745561        GEO-MEAN sched_debug.cpu#45.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    846804 ±  1%     -14.7%     722316 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    846804           -14.7%     722316        GEO-MEAN sched_debug.cpu#16.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3100432 ± 12%     +22.4%    3793805 ±  6%  ivb42/hackbench/performance-50%-threads-socket
   3100432           +22.4%    3793805        GEO-MEAN sched_debug.cfs_rq[37]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    860253 ±  1%     -13.1%     747838 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    860253           -13.1%     747838        GEO-MEAN sched_debug.cpu#44.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   2896486 ±  7%     +19.6%    3463508 ±  5%  ivb42/hackbench/performance-50%-threads-socket
   2896486           +19.6%    3463508        GEO-MEAN sched_debug.cfs_rq[25]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    871677 ±  0%     -13.2%     756998 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    871677           -13.2%     756998        GEO-MEAN sched_debug.cpu#47.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3230592 ±  8%     +14.9%    3712705 ±  3%  ivb42/hackbench/performance-50%-threads-socket
   3230592           +14.9%    3712705        GEO-MEAN sched_debug.cfs_rq[30]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      3.91 ±  1%     -14.3%       3.35 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      3.91           -14.3%       3.35        GEO-MEAN perf-profile.cpu-cycles.dequeue_task_fair.dequeue_task.deactivate_task.__sched_text_start.schedule

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    860005 ±  1%     -12.9%     748893 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    860005           -12.9%     748893        GEO-MEAN sched_debug.cpu#42.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3321870 ±  7%     +14.8%    3811901 ±  7%  ivb42/hackbench/performance-50%-threads-socket
   3321870           +14.8%    3811901        GEO-MEAN sched_debug.cfs_rq[47]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14483 ±  2%     -11.5%      12813 ±  3%  ivb42/hackbench/performance-50%-threads-socket
     14483           -11.5%      12813        GEO-MEAN sched_debug.cpu#7.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14.50 ±  1%     -13.3%      12.57 ±  1%  ivb42/hackbench/performance-50%-threads-socket
     14.50           -13.3%      12.57        GEO-MEAN perf-profile.cpu-cycles.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.sock_def_readable

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3234028 ±  9%     +15.2%    3724307 ±  4%  ivb42/hackbench/performance-50%-threads-socket
   3234028           +15.2%    3724307        GEO-MEAN sched_debug.cfs_rq[39]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    863531 ±  1%     -12.4%     756423 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    863531           -12.4%     756423        GEO-MEAN sched_debug.cpu#46.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3276492 ±  5%     +15.5%    3784016 ±  8%  ivb42/hackbench/performance-50%-threads-socket
   3276492           +15.5%    3784016        GEO-MEAN sched_debug.cfs_rq[35]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    860124 ±  0%     -12.8%     750152 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    860124           -12.8%     750152        GEO-MEAN sched_debug.cpu#38.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      4.32 ±  2%     +13.3%       4.90 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      4.32           +13.3%       4.90        GEO-MEAN perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      4025 ±  6%      -8.3%       3691 ±  4%  ivb42/hackbench/performance-50%-threads-socket
      4025            -8.3%       3691        GEO-MEAN slabinfo.RAW.num_objs

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    859082 ±  1%     -12.0%     756012 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    859082           -12.0%     756012        GEO-MEAN sched_debug.cpu#37.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    870131 ±  1%     -13.0%     757186 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    870131           -13.0%     757185        GEO-MEAN sched_debug.cpu#43.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14.53 ±  1%     -12.9%      12.66 ±  1%  ivb42/hackbench/performance-50%-threads-socket
     14.53           -12.9%      12.66        GEO-MEAN perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14.75 ±  1%     -12.6%      12.89 ±  1%  ivb42/hackbench/performance-50%-threads-socket
     14.75           -12.6%      12.89        GEO-MEAN perf-profile.cpu-cycles.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    870275 ±  1%     -13.3%     754578 ±  3%  ivb42/hackbench/performance-50%-threads-socket
    870275           -13.3%     754578        GEO-MEAN sched_debug.cpu#36.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      3989 ±  5%      -8.8%       3639 ±  5%  ivb42/hackbench/performance-50%-threads-socket
      3989            -8.8%       3639        GEO-MEAN slabinfo.RAW.active_objs

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.03 ±  1%     -13.2%       0.89 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      1.03           -13.2%       0.89        GEO-MEAN perf-profile.cpu-cycles.skb_unlink.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    885844 ±  1%     -11.8%     780892 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    885844           -11.8%     780892        GEO-MEAN sched_debug.cpu#10.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    895578 ±  2%     -11.5%     792265 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    895578           -11.5%     792265        GEO-MEAN sched_debug.cpu#11.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    883237 ±  2%     -11.9%     777826 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    883237           -11.9%     777826        GEO-MEAN sched_debug.cpu#1.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   2115995 ±  0%     -11.9%    1863524 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   2115994           -11.9%    1863523        GEO-MEAN proc-vmstat.numa_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   2122348 ±  0%     -11.9%    1869613 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   2122348           -11.9%    1869613        GEO-MEAN proc-vmstat.numa_hit

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      2.57 ±  4%     +13.8%       2.92 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      2.57           +13.8%       2.92        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1406705 ±  1%     -10.8%    1254824 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1406705           -10.8%    1254824        GEO-MEAN sched_debug.cpu#0.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     15.05 ±  1%     -11.8%      13.27 ±  0%  ivb42/hackbench/performance-50%-threads-socket
     15.05           -11.8%      13.27        GEO-MEAN perf-profile.cpu-cycles.__wake_up_common.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    879602 ±  1%     -11.5%     778421 ±  0%  ivb42/hackbench/performance-50%-threads-socket
    879602           -11.5%     778421        GEO-MEAN sched_debug.cpu#8.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    884715 ±  2%     -11.6%     782521 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    884714           -11.6%     782521        GEO-MEAN sched_debug.cpu#9.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    869234 ±  1%     -10.1%     781750 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    869234           -10.1%     781749        GEO-MEAN sched_debug.cpu#3.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     13928 ±  3%     -10.0%      12532 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     13928           -10.0%      12531        GEO-MEAN sched_debug.cpu#34.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.65 ±  3%     -11.9%       1.45 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.65           -11.9%       1.45        GEO-MEAN perf-profile.cpu-cycles.__kmalloc_reserve.isra.26.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg.sock_aio_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    860847 ±  2%     -11.2%     764541 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    860847           -11.2%     764541        GEO-MEAN sched_debug.cpu#39.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    839076 ±  1%     -11.6%     741571 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    839076           -11.6%     741571        GEO-MEAN sched_debug.cpu#41.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    875043 ±  2%     -10.0%     787246 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    875042           -10.0%     787246        GEO-MEAN sched_debug.cpu#34.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     23.87 ±  1%     -10.7%      21.31 ±  1%  ivb42/hackbench/performance-50%-threads-socket
     23.87           -10.7%      21.31        GEO-MEAN perf-profile.cpu-cycles.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write.do_sync_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      4.45 ±  1%     -11.6%       3.93 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      4.45           -11.6%       3.93        GEO-MEAN perf-profile.cpu-cycles.deactivate_task.__sched_text_start.schedule.schedule_timeout.unix_stream_recvmsg

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    873852 ±  2%     -10.8%     779782 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    873852           -10.8%     779782        GEO-MEAN sched_debug.cpu#31.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    872491 ±  2%     -10.3%     782420 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    872491           -10.3%     782420        GEO-MEAN sched_debug.cpu#6.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.11 ±  7%     -12.5%       0.97 ±  3%  ivb42/hackbench/performance-50%-threads-socket
      1.11           -12.5%       0.97        GEO-MEAN perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_read.sys_read

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      8.05 ±  2%     -12.5%       7.04 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      8.05           -12.5%       7.04        GEO-MEAN perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.36 ±  3%     -11.6%       1.20 ±  2%  ivb42/hackbench/performance-50%-threads-socket
      1.36           -11.6%       1.20        GEO-MEAN perf-profile.cpu-cycles.__kmalloc_node_track_caller.__kmalloc_reserve.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    884511 ±  1%     -10.9%     788238 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    884511           -10.9%     788238        GEO-MEAN sched_debug.cpu#7.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1423158 ±  1%     -10.2%    1278070 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1423157           -10.2%    1278070        GEO-MEAN sched_debug.cpu#4.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.39 ±  2%     +11.9%       1.56 ±  0%  ivb42/hackbench/performance-50%-threads-socket
      1.39           +11.9%       1.56        GEO-MEAN perf-profile.cpu-cycles.skb_queue_tail.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      4.46 ±  1%     -11.2%       3.96 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      4.46           -11.2%       3.96        GEO-MEAN perf-profile.cpu-cycles.dequeue_task.deactivate_task.__sched_text_start.schedule.schedule_timeout

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    882994 ±  2%      -9.2%     801606 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    882994            -9.2%     801606        GEO-MEAN sched_debug.cpu#25.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14371 ±  1%     -10.2%      12907 ±  1%  ivb42/hackbench/performance-50%-threads-socket
     14371           -10.2%      12907        GEO-MEAN sched_debug.cpu#22.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14692 ±  1%     -10.8%      13111 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     14692           -10.8%      13111        GEO-MEAN sched_debug.cpu#10.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14093 ±  3%      -9.5%      12748 ±  5%  ivb42/hackbench/performance-50%-threads-socket
     14093            -9.5%      12748        GEO-MEAN sched_debug.cpu#25.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1495572 ±  0%     -10.9%    1333271 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1495571           -10.9%    1333271        GEO-MEAN sched_debug.cpu#9.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14153 ±  3%      -9.4%      12817 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     14153            -9.4%      12817        GEO-MEAN sched_debug.cpu#27.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14374 ±  1%      -9.7%      12976 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     14374            -9.7%      12976        GEO-MEAN sched_debug.cpu#32.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    860018 ±  2%     -10.0%     773781 ±  0%  ivb42/hackbench/performance-50%-threads-socket
    860018           -10.0%     773781        GEO-MEAN sched_debug.cpu#4.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    863792 ±  1%     -10.0%     777585 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    863792           -10.0%     777585        GEO-MEAN sched_debug.cpu#32.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14193 ±  2%     -10.5%      12697 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     14193           -10.5%      12697        GEO-MEAN sched_debug.cpu#46.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1394923 ±  0%      -9.3%    1265094 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1394922            -9.3%    1265094        GEO-MEAN sched_debug.cpu#3.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1427072 ±  1%      -9.9%    1285217 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1427072            -9.9%    1285217        GEO-MEAN sched_debug.cpu#5.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        20 ±  3%     -10.9%         18 ±  3%  ivb42/hackbench/performance-50%-threads-socket
        20           -10.9%         17        GEO-MEAN sched_debug.cpu#5.cpu_load[0]

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      1.30 ±  2%     -10.9%       1.16 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      1.30           -10.9%       1.16        GEO-MEAN perf-profile.cpu-cycles.skb_copy_datagram_from_iovec.unix_stream_sendmsg.sock_aio_write.do_sync_write.vfs_write

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1404122 ±  0%     -10.1%    1262026 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1404122           -10.1%    1262026        GEO-MEAN sched_debug.cpu#2.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    871725 ±  3%      -9.5%     788740 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    871725            -9.5%     788740        GEO-MEAN sched_debug.cpu#35.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      2.62 ±  1%     +10.8%       2.90 ±  1%  ivb42/hackbench/performance-50%-threads-socket
      2.62           +10.8%       2.90        GEO-MEAN perf-profile.cpu-cycles.skb_copy_datagram_iovec.unix_stream_recvmsg.sock_aio_read.sock_aio_read.do_sync_read

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1440886 ±  0%     -10.0%    1296355 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1440886           -10.0%    1296355        GEO-MEAN sched_debug.cpu#6.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14332 ±  2%      -9.0%      13045 ±  3%  ivb42/hackbench/performance-50%-threads-socket
     14332            -9.0%      13045        GEO-MEAN sched_debug.cpu#33.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    882824 ±  1%     -10.1%     793313 ±  0%  ivb42/hackbench/performance-50%-threads-socket
    882824           -10.1%     793312        GEO-MEAN sched_debug.cpu#0.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   3116277 ±  7%     +13.2%    3527174 ±  4%  ivb42/hackbench/performance-50%-threads-socket
   3116277           +13.2%    3527174        GEO-MEAN sched_debug.cfs_rq[29]:/.spread0

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      2.38 ±  1%     +12.1%       2.67 ±  4%  ivb42/hackbench/performance-50%-threads-socket
      2.38           +12.1%       2.67        GEO-MEAN perf-profile.cpu-cycles.__fdget_pos.sys_write.system_call_fastpath

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14095 ±  2%      -9.6%      12748 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     14095            -9.6%      12748        GEO-MEAN sched_debug.cpu#12.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1499703 ±  0%      -9.7%    1354350 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1499703            -9.7%    1354350        GEO-MEAN sched_debug.cpu#10.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14050 ±  2%      -9.9%      12664 ±  4%  ivb42/hackbench/performance-50%-threads-socket
     14050            -9.9%      12664        GEO-MEAN sched_debug.cpu#47.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1493710 ±  1%     -10.0%    1344628 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1493710           -10.0%    1344628        GEO-MEAN sched_debug.cpu#11.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    882178 ±  2%      -8.7%     805480 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    882178            -8.7%     805480        GEO-MEAN sched_debug.cpu#26.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1451847 ±  1%      -9.6%    1311874 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1451847            -9.6%    1311874        GEO-MEAN sched_debug.cpu#7.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    869997 ±  1%     -10.0%     782794 ±  0%  ivb42/hackbench/performance-50%-threads-socket
    869997           -10.0%     782794        GEO-MEAN sched_debug.cpu#2.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14168 ±  3%     -11.3%      12566 ±  4%  ivb42/hackbench/performance-50%-threads-socket
     14168           -11.3%      12565        GEO-MEAN sched_debug.cpu#44.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    863764 ±  1%      -9.4%     782356 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    863764            -9.4%     782356        GEO-MEAN sched_debug.cpu#5.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        20 ±  2%      -9.7%         18 ±  5%  ivb42/hackbench/performance-50%-threads-socket
        20            -9.7%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[3]

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        20 ±  2%      -8.7%         18 ±  3%  ivb42/hackbench/performance-50%-threads-socket
        20            -8.7%         18        GEO-MEAN sched_debug.cpu#16.cpu_load[4]

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
        20 ±  3%      -8.7%         19 ±  5%  ivb42/hackbench/performance-50%-threads-socket
        20            -8.7%         18        GEO-MEAN sched_debug.cfs_rq[5]:/.runnable_load_avg

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1471462 ±  1%      -9.5%    1331414 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1471462            -9.5%    1331414        GEO-MEAN sched_debug.cpu#8.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    877064 ±  0%      -8.9%     799209 ±  1%  ivb42/hackbench/performance-50%-threads-socket
    877064            -8.9%     799208        GEO-MEAN sched_debug.cpu#27.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1081809 ±  1%      -9.1%     983451 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1081809            -9.1%     983451        GEO-MEAN numa-numastat.node1.local_node

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14225 ±  2%      -7.6%      13149 ±  3%  ivb42/hackbench/performance-50%-threads-socket
     14225            -7.6%      13149        GEO-MEAN sched_debug.cpu#36.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1084327 ±  1%      -9.3%     983476 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1084327            -9.3%     983475        GEO-MEAN numa-numastat.node1.numa_hit

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      2.29 ±  1%     +11.9%       2.57 ±  4%  ivb42/hackbench/performance-50%-threads-socket
      2.29           +11.9%       2.57        GEO-MEAN perf-profile.cpu-cycles.__fget_light.__fdget_pos.sys_write.system_call_fastpath

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    847788 ±  3%     -12.0%     746038 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    847788           -12.0%     746038        GEO-MEAN sched_debug.cpu#40.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    865949 ±  2%      -8.8%     789915 ±  2%  ivb42/hackbench/performance-50%-threads-socket
    865949            -8.8%     789915        GEO-MEAN sched_debug.cpu#33.ttwu_local

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14384 ±  2%     -10.9%      12817 ±  2%  ivb42/hackbench/performance-50%-threads-socket
     14384           -10.9%      12816        GEO-MEAN sched_debug.cpu#23.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1395020 ±  0%     -10.0%    1255965 ±  1%  ivb42/hackbench/performance-50%-threads-socket
   1395020           -10.0%    1255965        GEO-MEAN sched_debug.cpu#1.sched_goidle

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
     14326 ±  3%      -7.6%      13231 ±  4%  ivb42/hackbench/performance-50%-threads-socket
     14326            -7.6%      13231        GEO-MEAN sched_debug.cpu#9.curr->pid

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
      9.40 ±  2%     +52.1%      14.30 ±  0%  ivb42/hackbench/performance-50%-threads-socket
      9.40           +52.1%      14.30        GEO-MEAN turbostat.RAM_W

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
    328603 ±  4%     +28.0%     420733 ±  6%  ivb42/hackbench/performance-50%-threads-socket
    328603           +28.0%     420732        GEO-MEAN time.minor_page_faults

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
 2.029e+09 ±  0%     -19.6%  1.632e+09 ±  0%  ivb42/hackbench/performance-50%-threads-socket
 2.029e+09           -19.6%  1.632e+09        GEO-MEAN time.voluntary_context_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
 5.504e+08 ±  0%     -18.7%  4.477e+08 ±  0%  ivb42/hackbench/performance-50%-threads-socket
 5.504e+08           -18.7%  4.477e+08        GEO-MEAN time.involuntary_context_switches

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   4221419 ±  0%     -18.2%    3451963 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   4221418           -18.2%    3451963        GEO-MEAN vmstat.system.cs

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
       808 ±  0%     -10.7%        721 ±  0%  ivb42/hackbench/performance-50%-threads-socket
       808           -10.7%        721        GEO-MEAN time.user_time

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
   1096082 ±  1%     +11.3%    1220347 ±  0%  ivb42/hackbench/performance-50%-threads-socket
   1096082           +11.3%    1220347        GEO-MEAN vmstat.system.in

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
       173 ±  0%      -3.0%        168 ±  0%  ivb42/hackbench/performance-50%-threads-socket
       173            -3.0%        168        GEO-MEAN turbostat.Cor_W

b57a1e0afff2cbac  9597d64116d0d441dea32e7f5f  
----------------  --------------------------  
       204 ±  0%      -1.8%        200 ±  0%  ivb42/hackbench/performance-50%-threads-socket
       204            -1.8%        200        GEO-MEAN turbostat.Pkg_W


ivb42: Ivytown Ivy Bridge-EP
Memory: 64G


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

--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: hackbench
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
commit: 1e444803fa867d2fc4e30afe8d90574e5804c8ba
model: Ivytown Ivy Bridge-EP
nr_cpu: 48
memory: 64G
nr_threads:
- 50%
perf-profile:
  freq: 800
hackbench:
  mode:
  - threads
  ipc:
  - socket
enqueue_time: 2014-11-05 09:39:04.528108721 +08:00
testbox: ivb42
tbox_group: ivb42
kconfig: x86_64-rhel
head_commit: 1e444803fa867d2fc4e30afe8d90574e5804c8ba
base_commit: 0df1f2487d2f0d04703f142813d53615d62a1da4
branch: linux-devel/devel-hourly-2014110618
kernel: "/kernel/x86_64-rhel/1e444803fa867d2fc4e30afe8d90574e5804c8ba/vmlinuz-3.18.0-rc3-g1e44480"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/ivb42/hackbench/performance-50%-threads-socket/debian-x86_64.cgz/x86_64-rhel/1e444803fa867d2fc4e30afe8d90574e5804c8ba/0"
job_file: "/lkp/scheduled/ivb42/cyclic_hackbench-performance-50%-threads-socket-x86_64-rhel-HEAD-1e444803fa867d2fc4e30afe8d90574e5804c8ba-0.yaml"
dequeue_time: 2014-11-06 19:49:07.021643646 +08:00
job_state: finished
loadavg: 352.24 344.78 194.36 1/409 25623
start_time: '1415274589'
end_time: '1415275201'
version: "/lkp/lkp/.src-20141106-135136"

--5oH/S/bF6lOfqCQb
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
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000
/usr/bin/hackbench -g 24 --threads -l 60000

--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--5oH/S/bF6lOfqCQb--
