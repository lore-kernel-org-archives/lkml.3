Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaLOI0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:26:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:28192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaLOI0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:26:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="yaml'?scan'208";a="498788118"
Message-ID: <1418631955.5745.193.camel@linux.intel.com>
Subject: [LKP] [vfs] 75cbe701a42: +40.5% vmstat.system.in
From: Huang Ying <ying.huang@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Mon, 15 Dec 2014 16:25:55 +0800
Content-Type: multipart/mixed; boundary="=-FEeEQE1InGJZTw+5o9sH"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FEeEQE1InGJZTw+5o9sH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 75cbe701a4251fcd8b846d52ae42f88c9a8e5e93 ("vfs: Remove i_dquot field from inode")


testbox/testcase/testparams: lkp-nex05/will-it-scale/performance-pwrite3

507e1fa697097b48  75cbe701a4251fcd8b846d52ae  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
    157162 ± 12%    +420.1%     817388 ± 41%  sched_debug.cfs_rq[0]:/.min_vruntime
         6 ±  7%    +533.8%         41 ± 42%  sched_debug.cfs_rq[22]:/.tg_load_contrib
         1 ±  0%    +440.0%          5 ± 43%  sched_debug.cpu#26.cpu_load[1]
         0 ±  0%      +Inf%          5 ± 45%  sched_debug.cfs_rq[26]:/.runnable_load_avg
         0 ±  0%      +Inf%          5 ± 36%  sched_debug.cpu#30.cpu_load[0]
   8431.40 ± 30%    -100.0%       0.00 ±  0%  sched_debug.cfs_rq[34]:/.MIN_vruntime
   8431.40 ± 30%    -100.0%       0.00 ±  0%  sched_debug.cfs_rq[34]:/.max_vruntime
         0 ±  0%      +Inf%          3 ± 19%  sched_debug.cpu#57.cpu_load[4]
    145948 ± 31%     -65.3%      50659 ± 47%  sched_debug.cpu#3.sched_count
         2 ± 20%    +388.0%         12 ± 44%  sched_debug.cfs_rq[33]:/.runnable_load_avg
    102647 ± 42%     -65.2%      35676 ± 24%  sched_debug.cpu#11.sched_count
    185980 ± 17%     -59.1%      76091 ± 43%  sched_debug.cpu#10.sched_count
     92451 ± 16%     -65.8%      31628 ± 13%  sched_debug.cpu#10.sched_goidle
    185092 ± 16%     -65.7%      63435 ± 13%  sched_debug.cpu#10.nr_switches
    191359 ±  6%    +227.3%     626233 ± 42%  sched_debug.cfs_rq[34]:/.min_vruntime
     87689 ± 15%     -64.2%      31375 ± 13%  sched_debug.cpu#10.ttwu_count
    205303 ± 10%    +195.9%     607409 ± 43%  sched_debug.cfs_rq[38]:/.min_vruntime
     40762 ± 27%     -45.8%      22112 ± 37%  sched_debug.cpu#25.ttwu_count
     41187 ± 23%     -45.7%      22347 ± 37%  sched_debug.cpu#25.sched_goidle
     82643 ± 23%     -45.4%      45095 ± 37%  sched_debug.cpu#25.nr_switches
      2702 ±  9%    +155.2%       6896 ± 45%  sched_debug.cfs_rq[43]:/.avg->runnable_avg_sum
        58 ± 10%    +158.3%        149 ± 46%  sched_debug.cfs_rq[43]:/.tg_runnable_contrib
     83542 ± 22%     -43.9%      46893 ± 36%  sched_debug.cpu#25.sched_count
        51 ±  8%    +187.4%        148 ± 42%  sched_debug.cfs_rq[49]:/.tg_runnable_contrib
      2394 ±  9%    +184.2%       6805 ± 42%  sched_debug.cfs_rq[49]:/.avg->runnable_avg_sum
    292617 ± 23%     -41.0%     172597 ± 42%  sched_debug.cpu#6.sched_count
    145348 ± 23%     -41.6%      84899 ± 41%  sched_debug.cpu#6.sched_goidle
    290925 ± 23%     -41.6%     169994 ± 41%  sched_debug.cpu#6.nr_switches
     34916 ± 10%     -45.2%      19148 ± 31%  sched_debug.cpu#17.sched_goidle
     70132 ± 10%     -44.8%      38690 ± 31%  sched_debug.cpu#17.nr_switches
      3371 ± 20%    +542.7%      21665 ± 42%  sched_debug.cfs_rq[13]:/.exec_clock
     33857 ± 13%     -43.0%      19297 ± 29%  sched_debug.cpu#17.ttwu_count
       464 ±  0%    +288.4%       1804 ± 47%  sched_debug.cpu#7.curr->pid
        93 ± 11%    +128.0%        212 ± 34%  sched_debug.cfs_rq[42]:/.tg_runnable_contrib
      4288 ± 11%    +126.8%       9724 ± 33%  sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum
     70149 ± 10%     -43.6%      39548 ± 29%  sched_debug.cpu#17.sched_count
       310 ±  6%    +432.2%       1652 ± 45%  sched_debug.cpu#18.curr->pid
      2155 ±  7%    +329.7%       9262 ± 45%  sched_debug.cfs_rq[23]:/.exec_clock
    166703 ± 21%     -49.1%      84791 ± 30%  sched_debug.cpu#2.sched_goidle
    333623 ± 21%     -49.1%     169785 ± 30%  sched_debug.cpu#2.nr_switches
    333958 ± 21%     -44.4%     185671 ± 35%  sched_debug.cpu#2.sched_count
      9362 ±  9%    +118.8%      20488 ± 37%  sched_debug.cfs_rq[42]:/.exec_clock
         0 ±  0%      +Inf%          2 ± 41%  sched_debug.cpu#11.cpu_load[4]
     72346 ± 28%     -40.5%      43020 ± 23%  sched_debug.cpu#19.sched_count
     22735 ±  9%     -35.8%      14591 ± 29%  sched_debug.cpu#29.ttwu_count
     88509 ± 10%     -42.9%      50561 ± 32%  sched_debug.cpu#5.sched_goidle
    177345 ± 10%     -42.8%     101466 ± 31%  sched_debug.cpu#5.nr_switches
         0 ±  0%      +Inf%          3 ± 36%  sched_debug.cpu#11.cpu_load[3]
    178372 ± 10%     -39.4%     108021 ± 19%  sched_debug.cpu#5.sched_count
       176 ± 46%    +778.8%       1551 ± 42%  sched_debug.cpu#14.curr->pid
         1 ±  0%    +500.0%          6 ± 34%  sched_debug.cpu#20.cpu_load[0]
     22743 ± 12%     -32.4%      15363 ± 29%  sched_debug.cpu#29.sched_goidle
     68316 ± 13%     -27.5%      49497 ± 33%  sched_debug.cpu#4.ttwu_count
     26811 ± 16%     -36.8%      16949 ± 30%  sched_debug.cpu#11.ttwu_count
     45868 ± 12%     -31.6%      31356 ± 29%  sched_debug.cpu#29.nr_switches
     96945 ± 12%     -40.3%      57836 ± 34%  sched_debug.cpu#5.ttwu_count
     25741 ± 14%     -33.3%      17166 ± 26%  sched_debug.cpu#11.sched_goidle
     51764 ± 13%     -33.0%      34703 ± 25%  sched_debug.cpu#11.nr_switches
     63300 ± 13%     -20.0%      50621 ± 18%  sched_debug.cpu#26.sched_goidle
    126782 ± 13%     -20.0%     101443 ± 18%  sched_debug.cpu#26.nr_switches
         5 ± 40%    +116.0%         10 ± 15%  sched_debug.cpu#48.cpu_load[4]
         0 ±  0%      +Inf%          5 ± 36%  sched_debug.cfs_rq[20]:/.runnable_load_avg
     59777 ± 12%     -19.2%      48285 ± 17%  sched_debug.cpu#26.ttwu_count
         7 ±  6%     +52.0%         11 ± 10%  sched_debug.cpu#40.cpu_load[4]
         1 ± 33%    +220.0%          4 ± 24%  sched_debug.cpu#57.cpu_load[3]
       483 ± 19%    +378.2%       2312 ± 36%  sched_debug.cpu#0.curr->pid
       172 ±  4%     +71.5%        295 ± 22%  sched_debug.cfs_rq[40]:/.tg_runnable_contrib
     55388 ± 24%     -24.6%      41749 ± 39%  sched_debug.cpu#57.sched_goidle
      7887 ±  4%     +71.3%      13512 ± 23%  sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum
         5 ± 40%    +120.0%         11 ± 16%  sched_debug.cpu#48.cpu_load[3]
     46362 ± 11%     -25.4%      34597 ± 24%  sched_debug.cpu#29.sched_count
        43 ± 13%    +309.8%        176 ± 35%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
        75 ± 14%    +158.7%        194 ± 39%  sched_debug.cfs_rq[37]:/.tg_runnable_contrib
      3468 ± 14%    +157.2%       8919 ± 39%  sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum
      2015 ± 13%    +302.0%       8102 ± 35%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
        32 ±  9%    +297.5%        127 ± 42%  sched_debug.cfs_rq[15]:/.tg_runnable_contrib
      1507 ±  7%    +290.1%       5878 ± 42%  sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
      3998 ±  8%     -14.1%       3433 ±  9%  cpuidle.C1E-NHM.usage
    111142 ± 24%     -24.5%      83920 ± 39%  sched_debug.cpu#57.nr_switches
    111162 ± 24%     -24.3%      84203 ± 39%  sched_debug.cpu#57.sched_count
        63 ± 19%    +187.6%        181 ± 36%  sched_debug.cfs_rq[35]:/.tg_runnable_contrib
        71 ±  4%    +145.6%        174 ± 26%  sched_debug.cfs_rq[61]:/.tg_runnable_contrib
      2927 ± 18%    +185.8%       8365 ± 36%  sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum
      3276 ±  3%    +144.9%       8022 ± 26%  sched_debug.cfs_rq[61]:/.avg->runnable_avg_sum
       459 ± 10%     -25.0%        344 ± 12%  sched_debug.cpu#40.ttwu_local
       196 ±  3%     -14.0%        169 ± 10%  sched_debug.cpu#46.ttwu_local
    178384 ±  0%     -32.1%     121086 ± 29%  sched_debug.cpu#62.ttwu_count
       252 ± 24%    +336.6%       1100 ± 37%  sched_debug.cpu#15.curr->pid
      2364 ±  5%    +257.1%       8441 ± 38%  sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum
         6 ±  0%    +103.3%         12 ± 24%  sched_debug.cpu#48.cpu_load[0]
         4 ± 33%    +148.9%         11 ± 19%  sched_debug.cpu#48.cpu_load[2]
         8 ± 12%     +45.0%         11 ± 11%  sched_debug.cpu#40.cpu_load[3]
         5 ± 20%    +128.0%         11 ± 21%  sched_debug.cpu#48.cpu_load[1]
      8886 ±  8%    +114.1%      19030 ± 35%  sched_debug.cfs_rq[37]:/.exec_clock
        51 ± 11%    +253.7%        180 ± 36%  sched_debug.cfs_rq[22]:/.tg_runnable_contrib
      2358 ± 11%    +251.6%       8293 ± 36%  sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum
       331 ±  0%     -16.1%        278 ±  4%  sched_debug.cpu#49.ttwu_local
     26574 ±  8%     +47.3%      39151 ± 16%  sched_debug.cfs_rq[34]:/.exec_clock
      8204 ±  3%     +65.0%      13540 ± 24%  sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum
       179 ±  3%     +65.3%        295 ± 24%  sched_debug.cfs_rq[36]:/.tg_runnable_contrib
       330 ± 17%    +325.6%       1404 ± 37%  sched_debug.cpu#20.curr->pid
         2 ±  0%    +180.0%          5 ± 40%  sched_debug.cfs_rq[62]:/.runnable_load_avg
       597 ±  5%    +155.0%       1523 ± 27%  sched_debug.cpu#42.curr->pid
       555 ± 23%    +115.5%       1197 ± 43%  sched_debug.cpu#41.curr->pid
      8581 ±  0%     +56.5%      13426 ± 25%  sched_debug.cfs_rq[60]:/.avg->runnable_avg_sum
       187 ±  0%     +56.2%        292 ± 25%  sched_debug.cfs_rq[60]:/.tg_runnable_contrib
         2 ± 50%    +210.0%          6 ± 27%  sched_debug.cpu#57.cpu_load[2]
     71489 ±  4%     -49.9%      35802 ± 30%  sched_debug.cpu#55.sched_goidle
      7457 ± 17%     +63.9%      12222 ± 19%  sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum
       163 ± 17%     +63.4%        266 ± 19%  sched_debug.cfs_rq[38]:/.tg_runnable_contrib
       923 ±  9%    +105.2%       1894 ± 28%  sched_debug.cpu#60.curr->pid
         4 ±  0%    +185.0%         11 ± 48%  sched_debug.cpu#41.cpu_load[0]
        43 ±  9%    +202.8%        130 ± 43%  sched_debug.cfs_rq[31]:/.blocked_load_avg
    143344 ±  4%     -49.7%      72109 ± 30%  sched_debug.cpu#55.nr_switches
    154157 ± 16%     -41.3%      90499 ± 24%  sched_debug.cpu#33.sched_goidle
      7157 ± 13%     +80.3%      12902 ± 24%  sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum
    143368 ±  4%     -49.6%      72207 ± 30%  sched_debug.cpu#55.sched_count
    398727 ±  7%     -25.0%     299212 ± 33%  sched_debug.cpu#56.ttwu_count
       331 ± 38%     -53.2%        154 ± 38%  sched_debug.cfs_rq[45]:/.blocked_load_avg
       155 ± 14%     +81.0%        281 ± 24%  sched_debug.cfs_rq[34]:/.tg_runnable_contrib
        17 ± 14%     -30.3%         12 ± 34%  sched_debug.cfs_rq[59]:/.runnable_load_avg
        37 ±  4%    +202.4%        113 ± 39%  sched_debug.cfs_rq[23]:/.tg_runnable_contrib
    173012 ± 19%     -42.7%      99216 ± 27%  sched_debug.cpu#33.ttwu_count
     75987 ±  4%     -50.1%      37929 ± 31%  sched_debug.cpu#55.ttwu_count
    308942 ± 16%     -41.3%     181404 ± 24%  sched_debug.cpu#33.nr_switches
         3 ± 14%    +180.0%          9 ± 35%  sched_debug.cpu#41.cpu_load[1]
      1780 ±  4%    +194.9%       5248 ± 39%  sched_debug.cfs_rq[23]:/.avg->runnable_avg_sum
         3 ± 14%    +128.6%          8 ± 28%  sched_debug.cpu#41.cpu_load[2]
        29 ± 10%    +263.4%        105 ± 46%  sched_debug.cfs_rq[21]:/.tg_runnable_contrib
    308995 ± 16%     -41.2%     181562 ± 24%  sched_debug.cpu#33.sched_count
        74 ± 14%     -53.5%         34 ± 45%  sched_debug.cfs_rq[12]:/.tg_load_contrib
      1388 ±  9%    +250.5%       4865 ± 45%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
         2 ± 20%    +180.0%          7 ± 40%  sched_debug.cfs_rq[41]:/.runnable_load_avg
    191260 ± 12%     -43.1%     108749 ± 25%  sched_debug.cpu#45.ttwu_count
     68784 ±  0%     -36.6%      43633 ± 40%  sched_debug.cpu#53.ttwu_count
    173314 ±  9%     -45.9%      93834 ± 26%  sched_debug.cpu#45.sched_goidle
        40 ± 17%     -40.0%         24 ± 21%  sched_debug.cfs_rq[32]:/.runnable_load_avg
     55810 ± 12%     -26.3%      41131 ± 30%  sched_debug.cpu#39.sched_goidle
    179862 ±  1%     -35.8%     115446 ± 38%  sched_debug.cpu#50.ttwu_count
        23 ± 17%     -43.5%         13 ± 40%  sched_debug.cpu#59.load
        23 ± 17%     -43.5%         13 ± 40%  sched_debug.cfs_rq[59]:/.load
       211 ± 21%     -47.3%        111 ± 36%  sched_debug.cfs_rq[5]:/.blocked_load_avg
        39 ± 18%     -37.7%         24 ± 24%  sched_debug.cpu#32.cpu_load[1]
    347042 ±  9%     -45.8%     188111 ± 25%  sched_debug.cpu#45.nr_switches
        89 ± 10%     -52.6%         42 ± 40%  sched_debug.cfs_rq[2]:/.tg_load_contrib
    111996 ± 12%     -26.2%      82661 ± 29%  sched_debug.cpu#39.nr_switches
    347092 ±  9%     -45.8%     188225 ± 25%  sched_debug.cpu#45.sched_count
         9 ± 26%     -43.2%          5 ± 44%  sched_debug.cpu#47.cpu_load[1]
       337 ± 37%     -51.7%        162 ± 37%  sched_debug.cfs_rq[45]:/.tg_load_contrib
      6701 ± 12%    +137.1%      15886 ± 29%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
    171660 ±  8%     -33.6%     114067 ± 27%  sched_debug.cpu#54.ttwu_count
       146 ± 12%    +135.8%        345 ± 29%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
     60240 ± 12%     -27.1%      43911 ± 29%  sched_debug.cpu#39.ttwu_count
    180017 ±  5%     -34.2%     118414 ± 26%  sched_debug.cpu#54.sched_goidle
         6 ±  7%     +96.9%         12 ± 18%  sched_debug.cpu#34.cpu_load[4]
        48 ± 19%    +180.0%        135 ± 44%  sched_debug.cfs_rq[31]:/.tg_load_contrib
      5564 ± 25%    +196.0%      16471 ± 49%  sched_debug.cfs_rq[1]:/.exec_clock
    164454 ± 22%     -39.4%      99729 ± 29%  sched_debug.cpu#41.sched_goidle
    113012 ± 11%     -26.8%      82773 ± 29%  sched_debug.cpu#39.sched_count
    184124 ±  1%     -36.6%     116679 ± 38%  sched_debug.cpu#50.sched_goidle
    360271 ±  5%     -34.2%     237049 ± 26%  sched_debug.cpu#54.nr_switches
        39 ± 18%     -34.7%         25 ± 23%  sched_debug.cpu#32.cpu_load[0]
    360327 ±  5%     -34.2%     237201 ± 26%  sched_debug.cpu#54.sched_count
       339 ±  5%     -16.4%        283 ± 13%  sched_debug.cpu#51.ttwu_local
    329307 ± 22%     -39.3%     199906 ± 29%  sched_debug.cpu#41.nr_switches
    329356 ± 22%     -39.3%     200070 ± 29%  sched_debug.cpu#41.sched_count
    368489 ±  1%     -36.6%     233598 ± 37%  sched_debug.cpu#50.nr_switches
        37 ± 13%     -30.3%         25 ± 23%  sched_debug.cpu#32.cpu_load[2]
         6 ± 16%     -26.7%          4 ± 23%  sched_debug.cpu#55.cpu_load[3]
    368543 ±  1%     -36.3%     234920 ± 38%  sched_debug.cpu#50.sched_count
        60 ± 26%     -24.0%         45 ± 41%  sched_debug.cfs_rq[38]:/.blocked_load_avg
         1 ± 33%    +233.3%          5 ± 35%  sched_debug.cpu#18.cpu_load[1]
       176 ± 25%     -29.0%        125 ± 41%  sched_debug.cfs_rq[37]:/.blocked_load_avg
         9 ± 11%     -37.8%          5 ± 24%  sched_debug.cpu#55.cpu_load[2]
    183394 ± 27%     -36.5%     116428 ± 29%  sched_debug.cpu#41.ttwu_count
       188 ± 26%     -28.1%        135 ± 40%  sched_debug.cfs_rq[37]:/.tg_load_contrib
     30994 ± 21%    +103.6%      63115 ± 24%  sched_debug.cfs_rq[0]:/.exec_clock
        17 ± 35%    +103.5%         34 ± 15%  sched_debug.cfs_rq[0]:/.load
         6 ±  7%    +100.0%         13 ± 20%  sched_debug.cpu#34.cpu_load[3]
       130 ± 17%     -40.2%         78 ± 20%  sched_debug.cfs_rq[7]:/.tg_load_contrib
        12 ±  4%     -42.4%          7 ± 28%  sched_debug.cpu#55.cpu_load[0]
     71751 ±  4%     -40.6%      42585 ± 38%  sched_debug.cpu#47.ttwu_count
       216 ± 20%     -44.6%        120 ± 34%  sched_debug.cfs_rq[5]:/.tg_load_contrib
       436 ± 22%     -31.8%        297 ± 15%  sched_debug.cpu#33.ttwu_local
        14 ± 17%    +159.3%         37 ± 39%  sched_debug.cfs_rq[28]:/.tg_load_contrib
        11 ±  4%     -42.6%          6 ± 22%  sched_debug.cpu#55.cpu_load[1]
     68501 ±  3%     -41.2%      40278 ± 38%  sched_debug.cpu#47.sched_goidle
    137399 ±  3%     -41.0%      81095 ± 38%  sched_debug.cpu#47.nr_switches
       118 ± 15%     -40.6%         70 ± 25%  sched_debug.cfs_rq[7]:/.blocked_load_avg
         7 ±  0%     +88.6%         13 ± 18%  sched_debug.cpu#34.cpu_load[2]
    139101 ±  2%     -41.6%      81205 ± 37%  sched_debug.cpu#47.sched_count
        24 ± 25%     -24.2%         18 ± 48%  sched_debug.cfs_rq[60]:/.load
 1.571e+10 ±  1%      -9.5%  1.421e+10 ±  5%  cpuidle.C3-NHM.time
        66 ± 24%     -14.3%         57 ± 26%  sched_debug.cfs_rq[38]:/.tg_load_contrib
     40806 ±  6%     +72.3%      70294 ± 20%  sched_debug.cpu#0.nr_load_updates
        58 ± 28%    +160.2%        152 ± 37%  sched_debug.cfs_rq[11]:/.tg_load_contrib
   3310987 ±  1%     -30.0%    2316926 ± 21%  cpuidle.C3-NHM.usage
        67 ±  0%     +90.5%        128 ± 28%  sched_debug.cfs_rq[9]:/.blocked_load_avg
        80 ± 27%    +109.2%        168 ± 22%  sched_debug.cfs_rq[47]:/.blocked_load_avg
    186538 ±  0%     -37.4%     116738 ± 33%  sched_debug.cpu#46.ttwu_count
         8 ±  0%     +65.0%         13 ± 18%  sched_debug.cpu#34.cpu_load[1]
    194298 ±  1%     -38.6%     119356 ± 33%  sched_debug.cpu#46.sched_goidle
        71 ±  4%     +89.1%        135 ± 25%  sched_debug.cfs_rq[9]:/.tg_load_contrib
       188 ± 15%     +97.7%        372 ± 33%  sched_debug.cfs_rq[59]:/.blocked_load_avg
    388833 ±  1%     -38.6%     238921 ± 33%  sched_debug.cpu#46.nr_switches
    358921 ±  1%     -13.8%     309431 ±  6%  softirqs.SCHED
      2.34 ±  2%     -37.8%       1.46 ± 41%  perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_pwrite64.system_call_fastpath
        53 ±  3%     -34.0%         35 ± 13%  sched_debug.cfs_rq[32]:/.load
        50 ±  8%     -31.1%         34 ± 13%  sched_debug.cpu#32.load
       206 ± 12%     +86.8%        385 ± 31%  sched_debug.cfs_rq[59]:/.tg_load_contrib
    388897 ±  1%     -38.5%     239075 ± 33%  sched_debug.cpu#46.sched_count
        34 ± 23%    +163.5%         89 ± 47%  sched_debug.cfs_rq[0]:/.tg_load_contrib
     62.72 ±  2%     -15.4%      53.04 ± 10%  turbostat.%c3
        82 ± 10%     -29.0%         58 ± 15%  sched_debug.cfs_rq[32]:/.tg_load_contrib
    780606 ±  7%      -7.6%     721141 ±  5%  sched_debug.cpu#43.avg_idle
    111634 ±  4%     -12.2%      97988 ± 10%  sched_debug.cpu#32.nr_load_updates
      0.93 ±  8%     -20.4%       0.74 ± 27%  perf-profile.cpu-cycles.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter.new_sync_write
    774084 ±  8%      -8.3%     710179 ±  4%  sched_debug.cpu#39.avg_idle
       200 ±  9%     -16.7%        166 ±  8%  numa-vmstat.node3.nr_unevictable
       200 ±  9%     -16.7%        166 ±  8%  numa-vmstat.node3.nr_mlock
       672 ± 12%     -12.5%        588 ± 18%  slabinfo.xfs_buf.active_objs
       672 ± 12%     -12.5%        588 ± 18%  slabinfo.xfs_buf.num_objs
    711853 ±  1%     -12.6%     622436 ±  7%  sched_debug.cpu#37.avg_idle
     42208 ±  2%     +26.6%      53451 ±  9%  sched_debug.cpu#14.nr_load_updates
     43074 ±  5%     +31.3%      56552 ±  8%  sched_debug.cpu#13.nr_load_updates
    774013 ±  6%     -10.1%     696106 ±  9%  sched_debug.cpu#20.avg_idle
    742537 ±  4%     -12.4%     650469 ±  9%  sched_debug.cpu#8.avg_idle
    657723 ±  5%     -10.2%     590877 ±  8%  sched_debug.cpu#6.avg_idle
    779627 ±  1%     -15.0%     662459 ± 14%  sched_debug.cpu#24.avg_idle
     43298 ±  2%     +25.2%      54214 ± 12%  sched_debug.cpu#18.nr_load_updates
     40657 ±  1%     +11.9%      45515 ±  8%  sched_debug.cpu#15.nr_load_updates
    652300 ±  5%      -8.3%     598417 ±  2%  sched_debug.cpu#58.avg_idle
    870884 ±  4%     -12.9%     758163 ±  5%  sched_debug.cpu#31.avg_idle
     44351 ±  2%     +31.7%      58432 ± 19%  sched_debug.cpu#24.nr_load_updates
    763225 ±  4%     -15.6%     644390 ± 11%  sched_debug.cpu#12.avg_idle
    776029 ±  0%     -13.1%     674169 ±  8%  sched_debug.cpu#18.avg_idle
    838004 ±  2%     -15.9%     704595 ±  6%  sched_debug.cpu#30.avg_idle
       193 ±  3%     -14.3%        165 ± 11%  sched_debug.cpu#58.ttwu_local
     54047 ±  1%      -8.8%      49303 ±  5%  numa-meminfo.node0.Slab
      1.24 ±  2%     -19.2%       1.00 ±  9%  perf-profile.cpu-cycles.osq_unlock.mutex_optimistic_spin.__mutex_lock_slowpath.mutex_lock.generic_file_write_iter
     40061 ±  0%     +12.7%      45154 ±  5%  sched_debug.cpu#23.nr_load_updates
    795000 ±  0%     -14.5%     679866 ±  9%  sched_debug.cpu#13.avg_idle
    752969 ±  1%     -11.2%     668306 ±  5%  sched_debug.cpu#14.avg_idle
    148074 ±  4%      -9.5%     133968 ±  5%  numa-numastat.node0.local_node
    298993 ±  1%      -9.6%     270299 ±  7%  softirqs.RCU
    835755 ±  0%     -11.4%     740167 ±  8%  sched_debug.cpu#23.avg_idle
    156339 ±  4%      -9.0%     142236 ±  5%  numa-numastat.node0.numa_hit
      1785 ±  5%      -8.0%       1642 ±  3%  slabinfo.sock_inode_cache.active_objs
      1785 ±  5%      -8.0%       1642 ±  3%  slabinfo.sock_inode_cache.num_objs
    238242 ±  3%      -9.7%     215107 ±  2%  numa-vmstat.node0.numa_local
    826398 ±  5%      -7.2%     766511 ±  9%  sched_debug.cpu#19.avg_idle
    245728 ±  3%      -9.4%     222564 ±  2%  numa-vmstat.node0.numa_hit
      1022 ±  2%      -8.7%        932 ±  5%  slabinfo.RAW.num_objs
      1022 ±  2%      -8.7%        932 ±  5%  slabinfo.RAW.active_objs
    904008 ±  2%     -16.3%     756394 ± 18%  sched_debug.cpu#29.avg_idle
    850180 ±  0%     -10.3%     762690 ±  5%  sched_debug.cpu#25.avg_idle
     15949 ±  1%      -7.4%      14765 ±  3%  slabinfo.anon_vma.active_objs
     15949 ±  1%      -7.4%      14765 ±  3%  slabinfo.anon_vma.num_objs
        38 ± 24%     +46.5%         56 ± 13%  sched_debug.cfs_rq[48]:/.blocked_load_avg
      1179 ±  3%      -5.1%       1118 ±  5%  numa-vmstat.node0.nr_alloc_batch
     14112 ±  3%     +40.5%      19822 ± 11%  vmstat.system.in

testbox/testcase/testparams: lkp-nex06/vm-scalability/performance-300s-small-allocs

507e1fa697097b48  75cbe701a4251fcd8b846d52ae  
----------------  --------------------------  
      1.35 ± 17%     -56.0%       0.59 ± 10%  vm-scalability.stddev
   8850363 ±  0%     -19.9%    7092322 ±  0%  vm-scalability.throughput
       136 ± 11%    +429.6%        720 ±  5%  sched_debug.cfs_rq[41]:/.tg_runnable_contrib
         2 ± 35%    +575.0%         13 ± 12%  sched_debug.cpu#41.cpu_load[4]
      6253 ± 11%    +429.4%      33102 ±  5%  sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
    407488 ± 11%   +1302.5%    5714993 ±  1%  sched_debug.cfs_rq[40]:/.min_vruntime
     20998 ±  4%    +487.3%     123327 ±  2%  sched_debug.cfs_rq[40]:/.exec_clock
    548704 ± 13%    +945.3%    5735835 ±  1%  sched_debug.cfs_rq[39]:/.min_vruntime
   1121563 ±  6%    +439.2%    6047753 ±  2%  sched_debug.cfs_rq[0]:/.min_vruntime
    757728 ± 12%    +716.5%    6186567 ±  1%  sched_debug.cfs_rq[63]:/.min_vruntime
         2 ± 19%    +422.2%         11 ±  9%  sched_debug.cpu#42.cpu_load[4]
   1112970 ±  8%    +446.4%    6081015 ±  0%  sched_debug.cfs_rq[1]:/.min_vruntime
         2 ± 35%    +500.0%         12 ±  5%  sched_debug.cpu#37.cpu_load[4]
    555081 ± 11%    +934.1%    5740165 ±  1%  sched_debug.cfs_rq[36]:/.min_vruntime
    566546 ±  9%    +919.3%    5774630 ±  0%  sched_debug.cfs_rq[35]:/.min_vruntime
     21140 ± 15%    +476.2%     121799 ±  1%  sched_debug.cfs_rq[43]:/.exec_clock
   1113551 ±  7%    +440.8%    6022454 ±  1%  sched_debug.cfs_rq[4]:/.min_vruntime
    409522 ± 17%   +1278.1%    5643706 ±  1%  sched_debug.cfs_rq[43]:/.min_vruntime
    564685 ± 11%    +912.5%    5717371 ±  1%  sched_debug.cfs_rq[33]:/.min_vruntime
    588577 ± 12%    +879.1%    5762530 ±  2%  sched_debug.cfs_rq[32]:/.min_vruntime
    510891 ±  2%     -86.1%      70759 ±  1%  sched_debug.cpu#31.ttwu_count
    467778 ±  4%     -87.5%      58637 ±  4%  sched_debug.cpu#31.sched_goidle
    936797 ±  4%     -87.0%     121998 ±  4%  sched_debug.cpu#31.nr_switches
    519499 ±  2%     -86.5%      70274 ±  1%  sched_debug.cpu#30.ttwu_count
    506902 ±  4%     -87.5%      63322 ±  1%  sched_debug.cpu#30.sched_goidle
   1031191 ±  3%     -87.1%     133375 ±  1%  sched_debug.cpu#30.sched_count
     20787 ± 20%    +493.7%     123415 ±  2%  sched_debug.cfs_rq[44]:/.exec_clock
    409766 ± 21%   +1295.5%    5718172 ±  3%  sched_debug.cfs_rq[44]:/.min_vruntime
   1015080 ±  4%     -87.0%     131581 ±  1%  sched_debug.cpu#30.nr_switches
       127 ± 25%    +455.2%        709 ±  2%  sched_debug.cfs_rq[44]:/.tg_runnable_contrib
   1057283 ±  7%    +462.5%    5947320 ±  3%  sched_debug.cfs_rq[8]:/.min_vruntime
      5880 ± 25%    +453.7%      32564 ±  2%  sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum
    507560 ±  3%     -85.8%      71967 ±  1%  sched_debug.cpu#28.ttwu_count
    529976 ±  2%     -88.3%      61987 ±  2%  sched_debug.cpu#28.sched_goidle
   1081294 ±  1%     -87.9%     130386 ±  2%  sched_debug.cpu#28.sched_count
   1061187 ±  2%     -87.8%     129262 ±  2%  sched_debug.cpu#28.nr_switches
    450376 ± 19%   +1167.0%    5706353 ±  2%  sched_debug.cfs_rq[45]:/.min_vruntime
         1 ± 34%    +240.0%          4 ± 30%  sched_debug.cfs_rq[45]:/.nr_spread_over
    516365 ±  2%     -86.1%      71689 ±  1%  sched_debug.cpu#27.ttwu_count
    467103 ±  4%     -87.1%      60129 ±  5%  sched_debug.cpu#27.sched_goidle
    935433 ±  4%     -86.6%     125428 ±  5%  sched_debug.cpu#27.nr_switches
   1054821 ±  2%     -87.2%     134954 ±  6%  sched_debug.cpu#26.sched_count
   1283469 ±  7%    +411.7%    6568077 ±  0%  sched_debug.cfs_rq[25]:/.min_vruntime
     19517 ± 19%    +522.5%     121491 ±  1%  sched_debug.cfs_rq[46]:/.exec_clock
    387725 ± 23%   +1349.9%    5621538 ±  1%  sched_debug.cfs_rq[46]:/.min_vruntime
       130 ± 16%    +463.8%        735 ±  6%  sched_debug.cfs_rq[46]:/.tg_runnable_contrib
   1296121 ±  7%    +412.8%    6646523 ±  0%  sched_debug.cfs_rq[24]:/.min_vruntime
    521743 ±  4%     -85.6%      75227 ±  0%  sched_debug.cpu#24.ttwu_count
    523738 ±  1%     -87.9%      63237 ±  4%  sched_debug.cpu#24.sched_goidle
   1060028 ±  0%     -87.3%     134602 ±  5%  sched_debug.cpu#24.sched_count
      6007 ± 16%    +463.6%      33854 ±  6%  sched_debug.cfs_rq[46]:/.avg->runnable_avg_sum
   1048862 ±  1%     -87.4%     132535 ±  5%  sched_debug.cpu#24.nr_switches
    415579 ±  1%     -84.0%      66558 ±  1%  sched_debug.cpu#23.ttwu_count
    399591 ±  3%     -83.8%      64773 ±  1%  sched_debug.cpu#23.sched_goidle
    802364 ±  3%     -82.0%     144403 ±  6%  sched_debug.cpu#23.sched_count
    800051 ±  3%     -83.2%     134420 ±  0%  sched_debug.cpu#23.nr_switches
   1088620 ±  9%    +445.7%    5940679 ±  1%  sched_debug.cfs_rq[22]:/.min_vruntime
   1034659 ±  8%    +474.7%    5946605 ±  0%  sched_debug.cfs_rq[13]:/.min_vruntime
    417590 ±  1%     -83.8%      67501 ±  2%  sched_debug.cpu#22.ttwu_count
    430636 ±  4%     -83.5%      70888 ±  3%  sched_debug.cpu#22.sched_goidle
    865193 ±  4%     -81.4%     160862 ±  9%  sched_debug.cpu#22.sched_count
   1052369 ±  8%    +466.8%    5965329 ±  1%  sched_debug.cfs_rq[14]:/.min_vruntime
    862183 ±  4%     -83.0%     146429 ±  3%  sched_debug.cpu#22.nr_switches
    750218 ± 13%    +733.4%    6252541 ±  1%  sched_debug.cfs_rq[62]:/.min_vruntime
     19311 ± 11%    +527.4%     121159 ±  0%  sched_debug.cfs_rq[47]:/.exec_clock
    387976 ± 13%   +1346.7%    5612772 ±  1%  sched_debug.cfs_rq[47]:/.min_vruntime
    409721 ±  3%     -83.7%      66715 ±  1%  sched_debug.cpu#21.ttwu_count
    407184 ±  2%     -83.2%      68502 ± 11%  sched_debug.cpu#21.sched_goidle
        20 ± 40%    +379.3%         98 ± 30%  sched_debug.cpu#21.nr_uninterruptible
    815235 ±  2%     -82.5%     142411 ± 11%  sched_debug.cpu#21.nr_switches
   1080091 ±  9%    +455.0%    5994880 ±  1%  sched_debug.cfs_rq[20]:/.min_vruntime
    415446 ±  1%     -83.8%      67443 ±  2%  sched_debug.cpu#20.ttwu_count
    442408 ±  1%     -84.4%      68875 ±  1%  sched_debug.cpu#20.sched_goidle
    888757 ±  1%     -82.5%     155372 ±  7%  sched_debug.cpu#20.sched_count
    885847 ±  1%     -83.9%     142506 ±  1%  sched_debug.cpu#20.nr_switches
   1091055 ±  9%    +453.4%    6038436 ±  1%  sched_debug.cfs_rq[19]:/.min_vruntime
    417773 ±  1%     -83.9%      67398 ±  1%  sched_debug.cpu#19.ttwu_count
    398066 ±  3%     -83.9%      63958 ±  2%  sched_debug.cpu#19.sched_goidle
    500150 ± 16%   +1041.3%    5708010 ±  1%  sched_debug.cfs_rq[48]:/.min_vruntime
        17 ± 33%    +360.6%         81 ± 16%  sched_debug.cpu#19.nr_uninterruptible
    797029 ±  3%     -83.4%     132566 ±  2%  sched_debug.cpu#19.nr_switches
       133 ± 25%    +446.0%        727 ±  3%  sched_debug.cfs_rq[48]:/.tg_runnable_contrib
   1093025 ±  9%    +448.3%    5993418 ±  1%  sched_debug.cfs_rq[18]:/.min_vruntime
    417854 ±  1%     -84.0%      66789 ±  2%  sched_debug.cpu#18.ttwu_count
    428863 ±  3%     -84.3%      67425 ±  3%  sched_debug.cpu#18.sched_goidle
    860091 ±  2%     -79.7%     174594 ± 28%  sched_debug.cpu#18.sched_count
    858626 ±  3%     -83.7%     139729 ±  3%  sched_debug.cpu#18.nr_switches
      6134 ± 25%    +445.2%      33448 ±  3%  sched_debug.cfs_rq[48]:/.avg->runnable_avg_sum
   1069314 ±  8%    +465.0%    6041367 ±  0%  sched_debug.cfs_rq[17]:/.min_vruntime
   1084018 ±  8%    +455.3%    6020039 ±  1%  sched_debug.cfs_rq[16]:/.min_vruntime
    415085 ±  3%     -83.5%      68307 ±  2%  sched_debug.cpu#16.ttwu_count
   1073942 ±  8%    +447.6%    5881393 ±  2%  sched_debug.cfs_rq[21]:/.min_vruntime
    435899 ±  1%     -83.8%      70769 ±  2%  sched_debug.cpu#16.sched_goidle
    876150 ±  1%     -78.0%     193078 ± 38%  sched_debug.cpu#16.sched_count
    872710 ±  1%     -83.2%     146906 ±  2%  sched_debug.cpu#16.nr_switches
   1042616 ± 10%    +470.0%    5943066 ±  0%  sched_debug.cfs_rq[15]:/.min_vruntime
    392967 ±  3%     -81.6%      72239 ±  3%  sched_debug.cpu#15.ttwu_count
    380826 ±  2%     -81.3%      71372 ±  2%  sched_debug.cpu#15.sched_goidle
    762638 ±  2%     -80.4%     149503 ±  2%  sched_debug.cpu#15.nr_switches
    395697 ±  3%     -81.9%      71526 ±  3%  sched_debug.cpu#14.ttwu_count
    411944 ±  3%     -82.5%      72082 ±  1%  sched_debug.cpu#14.sched_goidle
    834606 ±  2%     -80.6%     162017 ±  5%  sched_debug.cpu#14.sched_count
        13 ± 26%    +463.0%         76 ± 34%  sched_debug.cpu#23.nr_uninterruptible
    824706 ±  3%     -81.8%     150178 ±  2%  sched_debug.cpu#14.nr_switches
    390571 ±  3%     -81.8%      71105 ±  2%  sched_debug.cpu#13.ttwu_count
    384103 ±  2%     -81.6%      70579 ±  1%  sched_debug.cpu#13.sched_goidle
    785013 ±  2%     -80.3%     155000 ±  3%  sched_debug.cpu#13.sched_count
   1090952 ±  9%    +444.6%    5941241 ±  1%  sched_debug.cfs_rq[23]:/.min_vruntime
    512564 ± 14%   +1013.4%    5706910 ±  1%  sched_debug.cfs_rq[50]:/.min_vruntime
    769118 ±  2%     -80.8%     147440 ±  2%  sched_debug.cpu#13.nr_switches
         1 ± 34%    +280.0%          4 ± 31%  sched_debug.cfs_rq[12]:/.nr_spread_over
   1044080 ±  7%    +462.3%    5871045 ±  2%  sched_debug.cfs_rq[12]:/.min_vruntime
    391582 ±  3%     -81.7%      71718 ±  3%  sched_debug.cpu#12.ttwu_count
    421874 ±  2%     -81.5%      77886 ±  9%  sched_debug.cpu#12.sched_goidle
    862416 ±  2%     -79.9%     172919 ± 13%  sched_debug.cpu#12.sched_count
    844625 ±  2%     -80.7%     162752 ±  9%  sched_debug.cpu#12.nr_switches
   1058728 ±  8%    +465.3%    5985054 ±  0%  sched_debug.cfs_rq[11]:/.min_vruntime
        16 ± 33%    +662.7%        127 ± 22%  sched_debug.cpu#11.nr_uninterruptible
   1062298 ±  8%    +464.6%    5997504 ±  1%  sched_debug.cfs_rq[10]:/.min_vruntime
    517857 ± 19%   +1001.2%    5702462 ±  1%  sched_debug.cfs_rq[51]:/.min_vruntime
   1048051 ±  7%    +471.3%    5987193 ±  1%  sched_debug.cfs_rq[9]:/.min_vruntime
    392612 ±  3%     -81.3%      73222 ±  2%  sched_debug.cpu#9.ttwu_count
    384344 ±  1%     -81.0%      73003 ±  6%  sched_debug.cpu#9.sched_goidle
    740882 ± 11%    +736.6%    6197903 ±  1%  sched_debug.cfs_rq[61]:/.min_vruntime
    957109 ±  3%     -86.7%     127218 ±  5%  sched_debug.cpu#27.sched_count
        18 ± 47%    +529.7%        116 ± 23%  sched_debug.cpu#9.nr_uninterruptible
    769524 ±  1%     -80.3%     151526 ±  6%  sched_debug.cpu#9.nr_switches
    399029 ±  3%     -82.0%      71669 ±  0%  sched_debug.cpu#8.ttwu_count
    420425 ±  1%     -81.0%      79992 ± 10%  sched_debug.cpu#8.sched_goidle
    843535 ±  1%     -80.3%     166159 ± 10%  sched_debug.cpu#8.nr_switches
   1117965 ±  8%    +435.3%    5984125 ±  0%  sched_debug.cfs_rq[7]:/.min_vruntime
    511997 ±  9%   +1015.9%    5713356 ±  0%  sched_debug.cfs_rq[52]:/.min_vruntime
   1119452 ±  8%    +438.3%    6025524 ±  1%  sched_debug.cfs_rq[6]:/.min_vruntime
   1107077 ±  7%    +438.6%    5963136 ±  1%  sched_debug.cfs_rq[5]:/.min_vruntime
         2 ± 35%    +550.0%         13 ±  5%  sched_debug.cpu#53.cpu_load[4]
    507924 ± 15%   +1034.2%    5760828 ±  1%  sched_debug.cfs_rq[53]:/.min_vruntime
    462841 ±  3%     -85.0%      69313 ±  4%  sched_debug.cpu#4.sched_goidle
    978113 ±  7%     -84.5%     151685 ±  7%  sched_debug.cpu#4.sched_count
    926708 ±  3%     -84.5%     143697 ±  5%  sched_debug.cpu#4.nr_switches
   1122648 ±  9%    +435.9%    6016455 ±  1%  sched_debug.cfs_rq[3]:/.min_vruntime
    941488 ±  4%     -86.9%     123539 ±  3%  sched_debug.cpu#31.sched_count
    430229 ±  2%     -83.3%      71773 ±  1%  sched_debug.cpu#3.ttwu_count
    415077 ±  4%     -83.8%      67085 ±  4%  sched_debug.cpu#3.sched_goidle
         2 ± 50%    +575.0%         13 ± 12%  sched_debug.cpu#54.cpu_load[4]
    514866 ± 15%   +1015.3%    5742085 ±  1%  sched_debug.cfs_rq[54]:/.min_vruntime
    831241 ±  4%     -83.2%     139398 ±  4%  sched_debug.cpu#3.nr_switches
   1132874 ±  9%    +434.5%    6055152 ±  1%  sched_debug.cfs_rq[2]:/.min_vruntime
    396510 ± 13%   +1326.7%    5656886 ±  1%  sched_debug.cfs_rq[41]:/.min_vruntime
    510648 ± 17%   +1017.0%    5703966 ±  0%  sched_debug.cfs_rq[55]:/.min_vruntime
    432018 ±  2%     -82.4%      76046 ±  1%  sched_debug.cpu#1.ttwu_count
    435032 ±  3%     -84.2%      68773 ±  5%  sched_debug.cpu#1.sched_goidle
    898167 ±  6%     -82.8%     154598 ±  9%  sched_debug.cpu#1.sched_count
    871402 ±  3%     -83.6%     143032 ±  5%  sched_debug.cpu#1.nr_switches
    439884 ±  3%     -81.6%      81117 ±  0%  sched_debug.cpu#0.ttwu_count
    467463 ±  4%     -83.4%      77658 ± 11%  sched_debug.cpu#0.sched_goidle
    968052 ±  5%     -79.3%     200488 ± 26%  sched_debug.cpu#0.sched_count
    939022 ±  4%     -82.6%     163789 ± 11%  sched_debug.cpu#0.nr_switches
    728509 ±  9%    +763.8%    6292757 ±  0%  sched_debug.cfs_rq[56]:/.min_vruntime
    733898 ± 12%    +758.7%    6302006 ±  1%  sched_debug.cfs_rq[57]:/.min_vruntime
    752642 ± 12%    +739.9%    6321565 ±  1%  sched_debug.cfs_rq[58]:/.min_vruntime
  34452061 ±  0%     -82.4%    6069487 ±  0%  cpuidle.C1-NHM.usage
    563860 ± 14%    +920.1%    5751802 ±  0%  sched_debug.cfs_rq[37]:/.min_vruntime
    753969 ± 10%    +729.8%    6256638 ±  0%  sched_debug.cfs_rq[59]:/.min_vruntime
         3 ±  0%    +416.7%         15 ±  3%  sched_debug.cpu#57.cpu_load[4]
    522652 ± 15%    +986.5%    5678738 ±  1%  sched_debug.cfs_rq[49]:/.min_vruntime
         3 ± 23%    +375.0%         14 ± 10%  sched_debug.cpu#60.cpu_load[4]
    735034 ± 12%    +746.0%    6218721 ±  1%  sched_debug.cfs_rq[60]:/.min_vruntime
    419503 ± 25%   +1238.4%    5614621 ±  0%  sched_debug.cfs_rq[42]:/.min_vruntime
     20513 ± 10%    +496.7%     122398 ±  0%  sched_debug.cfs_rq[41]:/.exec_clock
   1278013 ±  7%    +402.3%    6419733 ±  0%  sched_debug.cfs_rq[29]:/.min_vruntime
   1288072 ±  8%    +401.4%    6458783 ±  1%  sched_debug.cfs_rq[27]:/.min_vruntime
   1289452 ±  8%    +402.9%    6484674 ±  0%  sched_debug.cfs_rq[26]:/.min_vruntime
   1273611 ±  8%    +405.4%    6436316 ±  0%  sched_debug.cfs_rq[28]:/.min_vruntime
    883280 ±  6%     -80.0%     176592 ±  8%  sched_debug.cpu#8.sched_count
       143 ± 25%    +392.9%        708 ±  2%  sched_debug.cfs_rq[50]:/.tg_runnable_contrib
      6628 ± 25%    +391.8%      32593 ±  2%  sched_debug.cfs_rq[50]:/.avg->runnable_avg_sum
   1273326 ±  8%    +402.6%    6399707 ±  1%  sched_debug.cfs_rq[31]:/.min_vruntime
    819313 ±  1%     -80.6%     159234 ± 14%  sched_debug.cpu#21.sched_count
   1288398 ±  8%    +394.4%    6370426 ±  0%  sched_debug.cfs_rq[30]:/.min_vruntime
    798719 ±  4%     -79.7%     162260 ± 11%  sched_debug.cpu#9.sched_count
       426 ± 14%    +391.4%       2093 ± 14%  sched_debug.cpu#47.ttwu_local
       502 ± 43%    +296.1%       1991 ± 10%  sched_debug.cpu#33.curr->pid
       151 ± 12%    +375.9%        721 ±  7%  sched_debug.cfs_rq[54]:/.tg_runnable_contrib
      6970 ± 12%    +375.1%      33114 ±  6%  sched_debug.cfs_rq[54]:/.avg->runnable_avg_sum
       394 ± 33%    +379.3%       1890 ±  6%  sched_debug.cpu#48.curr->pid
         2 ± 36%    +477.8%         13 ± 19%  sched_debug.cpu#49.cpu_load[4]
         2 ± 20%    +420.0%         13 ±  9%  sched_debug.cpu#51.cpu_load[4]
         3 ± 33%    +323.1%         13 ± 10%  sched_debug.cpu#38.cpu_load[4]
         2 ± 39%    +390.9%         13 ±  3%  sched_debug.cfs_rq[48]:/.runnable_load_avg
         2 ± 39%    +372.7%         13 ± 19%  sched_debug.cpu#49.cpu_load[3]
    251433 ±  3%     -78.1%      55111 ±  4%  sched_debug.cpu#61.sched_goidle
    251186 ±  2%     -78.1%      54906 ±  4%  sched_debug.cpu#63.sched_goidle
    269668 ±  4%     -78.0%      59278 ±  2%  sched_debug.cpu#60.sched_goidle
     27195 ± 12%    +352.0%     122916 ±  0%  sched_debug.cfs_rq[55]:/.exec_clock
      5673 ± 19%    +423.4%      29691 ±  5%  sched_debug.cfs_rq[47]:/.avg->runnable_avg_sum
       123 ± 19%    +425.0%        645 ±  5%  sched_debug.cfs_rq[47]:/.tg_runnable_contrib
    861367 ±  8%     -82.7%     148638 ± 10%  sched_debug.cpu#7.sched_count
     27168 ± 11%    +355.5%     123756 ±  0%  sched_debug.cfs_rq[54]:/.exec_clock
     27600 ± 15%    +345.5%     122946 ±  1%  sched_debug.cfs_rq[51]:/.exec_clock
     23537 ± 15%    +422.8%     123064 ±  1%  sched_debug.cfs_rq[45]:/.exec_clock
    862841 ±  7%     -82.4%     151999 ±  8%  sched_debug.cpu#3.sched_count
    504662 ±  4%     -77.1%     115592 ±  4%  sched_debug.cpu#61.sched_count
    503667 ±  3%     -77.3%     114372 ±  4%  sched_debug.cpu#61.nr_switches
    264568 ±  1%     -77.6%      59369 ±  0%  sched_debug.cpu#62.sched_goidle
    503203 ±  2%     -77.3%     113986 ±  4%  sched_debug.cpu#63.nr_switches
    503461 ±  2%     -77.2%     114736 ±  4%  sched_debug.cpu#63.sched_count
    540170 ±  4%     -77.3%     122790 ±  2%  sched_debug.cpu#60.nr_switches
    540222 ±  4%     -77.2%     122950 ±  3%  sched_debug.cpu#60.sched_count
     26706 ± 12%    +364.5%     124058 ±  1%  sched_debug.cfs_rq[53]:/.exec_clock
    264009 ±  3%     -77.6%      59237 ±  5%  sched_debug.cpu#58.sched_goidle
     27131 ±  6%    +353.8%     123122 ±  0%  sched_debug.cfs_rq[52]:/.exec_clock
    253780 ±  3%     -77.5%      57202 ±  7%  sched_debug.cpu#59.sched_goidle
    769924 ±  2%     -75.5%     188277 ± 32%  sched_debug.cpu#15.sched_count
      7048 ± 14%    +357.6%      32254 ±  1%  sched_debug.cfs_rq[53]:/.avg->runnable_avg_sum
       153 ± 14%    +358.2%        702 ±  1%  sched_debug.cfs_rq[53]:/.tg_runnable_contrib
    529978 ±  1%     -76.8%     122764 ±  0%  sched_debug.cpu#62.nr_switches
         2 ± 30%    +372.7%         13 ±  5%  sched_debug.cpu#52.cpu_load[4]
         3 ± 23%    +325.0%         12 ±  6%  sched_debug.cpu#53.cpu_load[3]
         2 ± 36%    +477.8%         13 ±  5%  sched_debug.cpu#33.cpu_load[4]
         2 ± 20%    +410.0%         12 ±  6%  sched_debug.cpu#59.cpu_load[4]
         3 ± 40%    +316.7%         12 ± 14%  sched_debug.cfs_rq[49]:/.runnable_load_avg
         3 ± 23%    +300.0%         12 ± 21%  sched_debug.cfs_rq[36]:/.runnable_load_avg
    264953 ±  3%     -76.9%      61283 ±  3%  sched_debug.cpu#56.sched_goidle
     26622 ± 12%    +361.8%     122941 ±  1%  sched_debug.cfs_rq[48]:/.exec_clock
       457 ± 12%    +337.7%       2003 ± 20%  sched_debug.cpu#36.curr->pid
    765141 ±  1%     -79.3%     158075 ±  7%  sched_debug.cpu#11.sched_count
    530129 ±  1%     -76.6%     123998 ±  1%  sched_debug.cpu#62.sched_count
       516 ± 41%    +282.1%       1972 ± 10%  sched_debug.cpu#54.curr->pid
     27223 ± 11%    +351.4%     122887 ±  1%  sched_debug.cfs_rq[50]:/.exec_clock
    529094 ±  3%     -76.8%     122624 ±  5%  sched_debug.cpu#58.nr_switches
    530320 ±  3%     -76.6%     123934 ±  5%  sched_debug.cpu#58.sched_count
    855966 ±  5%     -80.6%     166023 ±  9%  sched_debug.cpu#10.sched_count
    413120 ±  2%     -82.1%      73890 ±  2%  sched_debug.cpu#10.sched_goidle
    828115 ±  2%     -81.4%     154252 ±  3%  sched_debug.cpu#10.nr_switches
       158 ± 18%    +360.1%        727 ±  2%  sched_debug.cfs_rq[51]:/.tg_runnable_contrib
      7287 ± 18%    +358.8%      33434 ±  2%  sched_debug.cfs_rq[51]:/.avg->runnable_avg_sum
     29543 ± 13%    +317.6%     123370 ±  1%  sched_debug.cfs_rq[38]:/.exec_clock
    555797 ±  9%    +929.8%    5723364 ±  1%  sched_debug.cfs_rq[34]:/.min_vruntime
    508378 ±  3%     -76.6%     118881 ±  7%  sched_debug.cpu#59.nr_switches
    508565 ±  3%     -76.5%     119331 ±  7%  sched_debug.cpu#59.sched_count
    275963 ±  5%     -75.9%      66628 ±  1%  sched_debug.cpu#63.ttwu_count
    279203 ±  2%     -76.0%      67079 ±  0%  sched_debug.cpu#59.ttwu_count
    530676 ±  3%     -76.1%     127010 ±  3%  sched_debug.cpu#56.nr_switches
    531314 ±  4%     -75.8%     128404 ±  4%  sched_debug.cpu#56.sched_count
     27764 ± 12%    +342.0%     122721 ±  1%  sched_debug.cfs_rq[49]:/.exec_clock
      1327 ± 12%    +196.1%       3930 ± 49%  sched_debug.cpu#13.ttwu_local
    399237 ±  2%     -81.9%      72338 ±  3%  sched_debug.cpu#10.ttwu_count
         4 ± 25%    +287.5%         15 ±  5%  sched_debug.cfs_rq[57]:/.runnable_load_avg
    274076 ±  6%     -75.4%      67499 ±  0%  sched_debug.cpu#58.ttwu_count
       158 ± 19%    +349.8%        714 ±  3%  sched_debug.cfs_rq[52]:/.tg_runnable_contrib
      7300 ± 19%    +349.4%      32806 ±  3%  sched_debug.cfs_rq[52]:/.avg->runnable_avg_sum
     28800 ±  9%    +329.2%     123619 ±  0%  sched_debug.cfs_rq[39]:/.exec_clock
    267405 ±  3%     -75.0%      66863 ±  0%  sched_debug.cpu#61.ttwu_count
    264134 ±  4%     -74.7%      66769 ±  0%  sched_debug.cpu#60.ttwu_count
     29402 ±  6%    +320.8%     123727 ±  1%  sched_debug.cfs_rq[36]:/.exec_clock
     30362 ±  4%    +309.9%     124471 ±  0%  sched_debug.cfs_rq[35]:/.exec_clock
    560496 ± 16%    +922.0%    5728023 ±  1%  sched_debug.cfs_rq[38]:/.min_vruntime
         3 ± 40%    +308.3%         12 ± 14%  sched_debug.cpu#39.cpu_load[4]
         2 ± 44%    +390.0%         12 ±  3%  sched_debug.cpu#44.cpu_load[4]
         2 ± 36%    +444.4%         12 ± 20%  sched_debug.cpu#36.cpu_load[4]
         3 ± 24%    +228.6%         11 ± 13%  sched_debug.cpu#42.cpu_load[3]
         5 ± 34%    +200.0%         15 ± 12%  sched_debug.cfs_rq[61]:/.runnable_load_avg
         3 ± 40%    +300.0%         12 ±  5%  sched_debug.cpu#37.cpu_load[3]
         4 ± 17%    +293.8%         15 ±  6%  sched_debug.cpu#57.cpu_load[0]
         3 ± 42%    +228.6%         11 ±  4%  sched_debug.cfs_rq[37]:/.runnable_load_avg
         4 ± 43%    +206.2%         12 ±  8%  sched_debug.cpu#37.cpu_load[1]
         1 ± 34%    +160.0%          3 ± 39%  sched_debug.cfs_rq[47]:/.nr_spread_over
         3 ± 23%    +291.7%         11 ± 21%  sched_debug.cpu#36.cpu_load[3]
    426620 ±  2%     -83.6%      69920 ±  1%  sched_debug.cpu#6.ttwu_count
     30042 ±  8%    +310.5%     123314 ±  0%  sched_debug.cfs_rq[33]:/.exec_clock
    264870 ±  4%     -74.4%      67820 ±  0%  sched_debug.cpu#57.ttwu_count
       177 ± 12%    +299.6%        707 ±  3%  sched_debug.cfs_rq[33]:/.tg_runnable_contrib
    514194 ±  3%     -85.5%      74348 ±  1%  sched_debug.cpu#25.ttwu_count
         3 ± 45%    +307.7%         13 ±  6%  sched_debug.cpu#33.cpu_load[2]
      7350 ± 11%    +320.9%      30942 ±  4%  sched_debug.cfs_rq[55]:/.avg->runnable_avg_sum
      8172 ± 12%    +297.8%      32506 ±  3%  sched_debug.cfs_rq[33]:/.avg->runnable_avg_sum
    488344 ±  1%     -88.0%      58541 ±  5%  sched_debug.cpu#25.sched_goidle
       159 ± 11%    +321.4%        673 ±  3%  sched_debug.cfs_rq[55]:/.tg_runnable_contrib
    978040 ±  1%     -87.4%     122822 ±  5%  sched_debug.cpu#25.nr_switches
         3 ± 39%    +293.3%         14 ±  7%  sched_debug.cpu#61.cpu_load[4]
       510 ±  8%    +261.4%       1843 ±  7%  sched_debug.cpu#41.ttwu_local
     31508 ±  8%    +294.5%     124313 ±  2%  sched_debug.cfs_rq[32]:/.exec_clock
      6215 ± 20%    +420.7%      32363 ±  4%  sched_debug.cfs_rq[43]:/.avg->runnable_avg_sum
       134 ± 20%    +423.0%        703 ±  4%  sched_debug.cfs_rq[43]:/.tg_runnable_contrib
    423696 ±  1%     -83.7%      69089 ±  1%  sched_debug.cpu#7.ttwu_count
    985152 ±  1%     -87.3%     125087 ±  4%  sched_debug.cpu#25.sched_count
       176 ±  7%    +293.3%        693 ±  7%  sched_debug.cfs_rq[39]:/.tg_runnable_contrib
      8113 ±  7%    +293.2%      31898 ±  7%  sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum
       158 ± 14%    +346.4%        706 ± 11%  sched_debug.cfs_rq[49]:/.tg_runnable_contrib
       588 ± 43%    +204.5%       1791 ±  5%  sched_debug.cpu#42.ttwu_local
      7280 ± 14%    +346.0%      32470 ± 11%  sched_debug.cfs_rq[49]:/.avg->runnable_avg_sum
       189 ± 11%    +276.3%        711 ±  2%  sched_debug.cfs_rq[32]:/.tg_runnable_contrib
         3 ± 22%    +273.3%         14 ±  8%  sched_debug.cpu#62.cpu_load[4]
         3 ± 29%    +266.7%         13 ±  9%  sched_debug.cfs_rq[60]:/.runnable_load_avg
         4 ± 38%    +223.5%         13 ± 11%  sched_debug.cpu#46.cpu_load[3]
         4 ± 17%    +250.0%         14 ± 11%  sched_debug.cpu#60.cpu_load[3]
         5 ± 46%    +175.0%         13 ± 11%  sched_debug.cpu#46.cpu_load[2]
         6 ± 19%    +103.7%         13 ± 13%  sched_debug.cpu#11.cpu_load[0]
         3 ± 22%    +286.7%         14 ±  7%  sched_debug.cpu#58.cpu_load[4]
         3 ± 39%    +330.8%         14 ± 12%  sched_debug.cpu#46.cpu_load[4]
         3 ± 33%    +350.0%         13 ± 15%  sched_debug.cpu#54.cpu_load[3]
      8706 ± 11%    +275.5%      32690 ±  2%  sched_debug.cfs_rq[32]:/.avg->runnable_avg_sum
    415474 ±  5%     -84.4%      64948 ±  2%  sched_debug.cpu#7.sched_goidle
    161883 ± 18%    +221.3%     520122 ± 28%  sched_debug.cfs_rq[25]:/.spread0
    831974 ±  5%     -83.8%     135081 ±  2%  sched_debug.cpu#7.nr_switches
    932620 ±  9%     -83.7%     151771 ±  4%  sched_debug.cpu#6.sched_count
    448439 ±  5%     -84.1%      71489 ±  4%  sched_debug.cpu#6.sched_goidle
    897830 ±  5%     -83.5%     148047 ±  4%  sched_debug.cpu#6.nr_switches
       474 ± 19%    +304.2%       1916 ±  4%  sched_debug.cpu#44.ttwu_local
    408625 ±  3%     -84.3%      64169 ±  5%  sched_debug.cpu#17.sched_goidle
    818333 ±  3%     -83.7%     133510 ±  5%  sched_debug.cpu#17.nr_switches
     57425 ±  2%    +124.8%     129088 ±  0%  sched_debug.cfs_rq[13]:/.exec_clock
      9922 ±  7%    +278.2%      37525 ±  2%  sched_debug.cfs_rq[57]:/.avg->runnable_avg_sum
       216 ±  7%    +276.9%        814 ±  2%  sched_debug.cfs_rq[57]:/.tg_runnable_contrib
     57426 ±  6%    +127.5%     130639 ±  2%  sched_debug.cfs_rq[15]:/.exec_clock
    409805 ±  3%     -83.5%      67449 ±  2%  sched_debug.cpu#17.ttwu_count
       646 ± 25%    +207.4%       1987 ± 10%  sched_debug.cpu#7.curr->pid
       553 ±  8%    +280.4%       2104 ± 12%  sched_debug.cpu#38.curr->pid
         7 ± 17%     +92.9%         13 ± 15%  sched_debug.cpu#11.cpu_load[1]
         6 ± 20%    +128.0%         14 ±  5%  sched_debug.cpu#18.cpu_load[4]
       124 ±  9%    +434.9%        663 ±  7%  sched_debug.cfs_rq[42]:/.tg_runnable_contrib
      5723 ±  9%    +432.6%      30482 ±  7%  sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum
    820458 ±  3%     -82.6%     142803 ±  5%  sched_debug.cpu#17.sched_count
       907 ±  6%    +109.9%       1905 ±  7%  sched_debug.cpu#18.curr->pid
      7596 ± 27%    +317.1%      31685 ±  5%  sched_debug.cfs_rq[45]:/.avg->runnable_avg_sum
         3 ± 43%    +246.7%         13 ±  5%  sched_debug.cpu#33.cpu_load[1]
     60531 ±  4%    +113.4%     129160 ±  0%  sched_debug.cfs_rq[23]:/.exec_clock
        48 ± 39%    +205.2%        147 ± 34%  sched_debug.cfs_rq[33]:/.tg_load_contrib
    453444 ±  4%     -84.1%      72012 ±  4%  sched_debug.cpu#2.sched_goidle
    907983 ±  4%     -83.5%     149609 ±  4%  sched_debug.cpu#2.nr_switches
    974782 ± 10%     -83.9%     157156 ±  2%  sched_debug.cpu#2.sched_count
       165 ± 27%    +317.1%        688 ±  5%  sched_debug.cfs_rq[45]:/.tg_runnable_contrib
       522 ± 12%    +239.3%       1771 ± 12%  sched_debug.cpu#39.ttwu_local
     22377 ± 19%    +441.3%     121128 ±  0%  sched_debug.cfs_rq[42]:/.exec_clock
    167866 ± 22%    +160.2%     436709 ± 34%  sched_debug.cfs_rq[26]:/.spread0
         3 ± 29%    +226.7%         12 ± 21%  sched_debug.cpu#36.cpu_load[1]
         4 ± 17%    +231.2%         13 ±  6%  sched_debug.cpu#59.cpu_load[0]
         3 ± 42%    +278.6%         13 ±  9%  sched_debug.cfs_rq[54]:/.runnable_load_avg
         3 ± 31%    +285.7%         13 ± 12%  sched_debug.cpu#41.cpu_load[3]
         3 ± 47%    +246.7%         13 ±  9%  sched_debug.cpu#63.cpu_load[4]
         6 ± 20%    +112.5%         12 ± 14%  sched_debug.cpu#11.cpu_load[4]
         3 ± 11%    +226.7%         12 ± 21%  sched_debug.cpu#36.cpu_load[0]
         4 ± 35%    +225.0%         13 ±  7%  sched_debug.cpu#53.cpu_load[1]
         5 ± 47%    +140.9%         13 ±  9%  sched_debug.cpu#46.cpu_load[1]
         4 ± 25%    +205.9%         13 ± 12%  sched_debug.cpu#53.cpu_load[0]
       500 ± 18%    +262.1%       1810 ± 15%  sched_debug.cpu#45.ttwu_local
       451 ±  8%    +230.7%       1493 ± 19%  sched_debug.cpu#54.ttwu_local
 1.156e+10 ±  0%     -71.2%  3.326e+09 ±  1%  cpuidle.C1-NHM.time
    799819 ±  2%     -82.4%     140789 ±  6%  sched_debug.cpu#19.sched_count
        50 ± 16%     +93.0%         97 ± 15%  sched_debug.cpu#31.nr_uninterruptible
       228 ±  4%    +239.6%        776 ±  4%  sched_debug.cfs_rq[58]:/.tg_runnable_contrib
     10517 ±  4%    +239.3%      35688 ±  4%  sched_debug.cfs_rq[58]:/.avg->runnable_avg_sum
    156424 ± 23%    +137.7%     371749 ± 37%  sched_debug.cfs_rq[29]:/.spread0
        44 ± 41%    +201.7%        133 ± 37%  sched_debug.cfs_rq[33]:/.blocked_load_avg
         7 ± 17%     +79.3%         13 ± 15%  sched_debug.cpu#11.cpu_load[2]
         7 ± 15%     +72.4%         12 ±  4%  sched_debug.cfs_rq[18]:/.runnable_load_avg
         6 ± 13%     +96.0%         12 ± 12%  sched_debug.cpu#21.cpu_load[4]
     38958 ±  6%    +249.7%     136223 ±  0%  sched_debug.cfs_rq[56]:/.exec_clock
    166485 ± 27%    +146.8%     410810 ± 40%  sched_debug.cfs_rq[27]:/.spread0
       903 ±  9%    +122.0%       2006 ±  2%  sched_debug.cpu#25.curr->pid
     10608 ±  7%    +232.5%      35277 ±  5%  sched_debug.cfs_rq[62]:/.avg->runnable_avg_sum
       231 ±  7%    +232.4%        767 ±  5%  sched_debug.cfs_rq[62]:/.tg_runnable_contrib
    510864 ±  4%     -85.9%      71998 ±  0%  sched_debug.cpu#29.ttwu_count
       497 ± 14%    +258.9%       1783 ± 30%  sched_debug.cpu#55.ttwu_local
       584 ± 27%    +251.9%       2057 ±  9%  sched_debug.cpu#58.curr->pid
       577 ± 14%    +214.3%       1815 ± 12%  sched_debug.cpu#51.curr->pid
    424410 ±  4%     -84.9%      64153 ±  1%  sched_debug.cpu#5.sched_goidle
       464 ± 14%     -39.7%        280 ±  6%  sched_debug.cpu#24.nr_uninterruptible
    849809 ±  4%     -84.3%     133474 ±  1%  sched_debug.cpu#5.nr_switches
         6 ± 19%     +88.9%         12 ± 14%  sched_debug.cpu#11.cpu_load[3]
    893664 ±  8%     -84.3%     140385 ±  2%  sched_debug.cpu#5.sched_count
      1050 ± 22%     +92.7%       2023 ±  4%  sched_debug.cpu#14.curr->pid
         6 ± 41%     +84.0%         11 ±  9%  sched_debug.cpu#20.cpu_load[0]
       562 ± 26%    +264.2%       2049 ±  2%  sched_debug.cpu#56.curr->pid
    484950 ±  3%     -87.6%      60072 ±  4%  sched_debug.cpu#29.sched_goidle
       631 ± 20%    +204.4%       1921 ± 13%  sched_debug.cpu#35.curr->pid
       400 ±  9%     +91.0%        765 ±  3%  sched_debug.cfs_rq[29]:/.tg_runnable_contrib
    221437 ±  4%     -69.0%      68559 ±  1%  sched_debug.cpu#32.sched_goidle
    151736 ± 28%    +131.8%     351711 ± 34%  sched_debug.cfs_rq[31]:/.spread0
     39350 ±  8%    +241.4%     134348 ±  0%  sched_debug.cfs_rq[60]:/.exec_clock
    424957 ±  2%     -83.4%      70675 ±  2%  sched_debug.cpu#4.ttwu_count
    399685 ±  1%     -82.2%      71004 ±  0%  sched_debug.cpu#11.ttwu_count
    971165 ±  3%     -87.1%     125255 ±  4%  sched_debug.cpu#29.nr_switches
    423917 ±  3%     -83.7%      69106 ±  1%  sched_debug.cpu#5.ttwu_count
         8 ± 19%     +63.6%         13 ± 15%  sched_debug.cpu#22.cpu_load[1]
         7 ± 19%     +71.0%         13 ± 12%  sched_debug.cpu#22.cpu_load[2]
         6 ± 19%     +96.3%         13 ± 12%  sched_debug.cpu#22.cpu_load[3]
       608 ± 20%    +258.9%       2182 ±  6%  sched_debug.cpu#57.curr->pid
         4 ± 30%    +205.9%         13 ±  5%  sched_debug.cpu#33.cpu_load[0]
    376316 ±  1%     -81.4%      70115 ±  2%  sched_debug.cpu#11.sched_goidle
    754666 ±  1%     -80.6%     146300 ±  2%  sched_debug.cpu#11.nr_switches
    511244 ±  3%     -87.5%      63857 ±  6%  sched_debug.cpu#26.sched_goidle
   1023764 ±  3%     -87.0%     133252 ±  6%  sched_debug.cpu#26.nr_switches
         2 ± 35%    +600.0%         14 ±  5%  sched_debug.cpu#48.cpu_load[4]
         6 ± 30%     +76.0%         11 ±  6%  sched_debug.cfs_rq[20]:/.runnable_load_avg
     39811 ±  7%    +236.6%     134001 ±  1%  sched_debug.cfs_rq[61]:/.exec_clock
        76 ± 17%     +64.7%        126 ± 12%  sched_debug.cpu#28.nr_uninterruptible
         8 ± 16%     +57.1%         13 ± 14%  sched_debug.cpu#23.cpu_load[0]
     58133 ±  3%    +126.1%     131423 ±  2%  sched_debug.cfs_rq[14]:/.exec_clock
    516681 ±  2%     -85.9%      72656 ±  1%  sched_debug.cpu#26.ttwu_count
    206503 ±  3%     -68.6%      64766 ±  1%  sched_debug.cpu#32.ttwu_count
     18371 ±  9%     +91.0%      35082 ±  3%  sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum
         3 ± 33%    +308.3%         12 ±  6%  sched_debug.cpu#55.cpu_load[4]
         3 ± 14%    +257.1%         12 ±  4%  sched_debug.cpu#59.cpu_load[3]
         4 ± 33%    +161.1%         11 ± 13%  sched_debug.cpu#42.cpu_load[2]
         4 ± 30%    +225.0%         13 ±  9%  sched_debug.cpu#32.cpu_load[3]
         3 ± 31%    +264.3%         12 ± 11%  sched_debug.cpu#35.cpu_load[4]
         3 ± 29%    +240.0%         12 ± 11%  sched_debug.cfs_rq[53]:/.runnable_load_avg
         3 ± 29%    +240.0%         12 ±  6%  sched_debug.cpu#53.cpu_load[2]
         3 ± 22%    +246.7%         13 ±  5%  sched_debug.cpu#52.cpu_load[3]
         3 ± 31%    +257.1%         12 ±  8%  sched_debug.cpu#51.cpu_load[3]
         3 ± 39%    +300.0%         13 ±  5%  sched_debug.cpu#32.cpu_load[4]
         4 ± 30%    +212.5%         12 ±  4%  sched_debug.cpu#40.cpu_load[2]
         4 ± 38%    +194.1%         12 ±  4%  sched_debug.cpu#40.cpu_load[1]
         2 ± 19%    +466.7%         12 ±  8%  sched_debug.cpu#40.cpu_load[4]
         2 ± 47%    +372.7%         13 ±  5%  sched_debug.cpu#33.cpu_load[3]
         4 ± 10%    +200.0%         12 ±  6%  sched_debug.cpu#59.cpu_load[1]
         4 ± 38%    +194.1%         12 ±  4%  sched_debug.cpu#40.cpu_load[0]
         3 ± 29%    +220.0%         12 ± 21%  sched_debug.cpu#36.cpu_load[2]
         4 ± 17%    +212.5%         12 ± 14%  sched_debug.cpu#39.cpu_load[3]
         4 ± 27%    +147.4%         11 ± 19%  sched_debug.cpu#42.cpu_load[1]
         4 ±  0%    +287.5%         15 ±  3%  sched_debug.cpu#57.cpu_load[3]
         4 ±  0%    +212.5%         12 ±  4%  sched_debug.cpu#59.cpu_load[2]
    190817 ±  7%     -69.0%      59123 ±  5%  sched_debug.cpu#37.sched_goidle
       683 ±  5%    +204.3%       2080 ±  9%  sched_debug.cpu#61.curr->pid
       109 ± 10%     +37.0%        150 ± 21%  sched_debug.cpu#26.nr_uninterruptible
       528 ± 18%    +232.1%       1755 ± 12%  sched_debug.cpu#55.curr->pid
       540 ± 32%    +257.9%       1934 ±  9%  sched_debug.cpu#39.curr->pid
    429861 ±  1%     -82.7%      74351 ±  1%  sched_debug.cpu#2.ttwu_count
     39439 ±  8%    +245.8%     136399 ±  0%  sched_debug.cfs_rq[57]:/.exec_clock
       973 ± 25%    +110.9%       2052 ± 10%  sched_debug.cpu#0.curr->pid
     40253 ±  9%    +235.4%     135015 ±  0%  sched_debug.cfs_rq[62]:/.exec_clock
  73690739 ±  3%     -67.6%   23868773 ± 10%  cpuidle.C1E-NHM.time
    443566 ±  4%     -67.9%     142393 ±  1%  sched_debug.cpu#32.nr_switches
       133 ± 15%    +429.1%        705 ±  5%  sched_debug.cfs_rq[40]:/.tg_runnable_contrib
    247383 ±  3%     -77.8%      54929 ±  5%  sched_debug.cpu#57.sched_goidle
      6128 ± 15%    +428.5%      32386 ±  5%  sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum
       586 ±  9%    +204.9%       1787 ±  8%  sched_debug.cpu#36.ttwu_local
         5 ± 27%    +177.3%         15 ±  9%  sched_debug.cpu#61.cpu_load[2]
         4 ±  9%    +236.8%         16 ±  4%  sched_debug.cpu#57.cpu_load[1]
         9 ± 20%     +45.9%         13 ±  3%  sched_debug.cpu#30.cpu_load[4]
         2 ± 30%    +400.0%         13 ±  3%  sched_debug.cpu#48.cpu_load[3]
       230 ±  5%    +224.5%        748 ±  2%  sched_debug.cfs_rq[59]:/.tg_runnable_contrib
       625 ± 32%    +207.4%       1922 ± 17%  sched_debug.cpu#32.curr->pid
    984354 ±  2%     -87.2%     126424 ±  5%  sched_debug.cpu#29.sched_count
    181989 ± 11%     -65.9%      62130 ±  1%  sched_debug.cpu#49.ttwu_count
       473 ±  7%    +219.2%       1512 ± 22%  sched_debug.cpu#52.ttwu_local
     10613 ±  5%    +224.4%      34424 ±  2%  sched_debug.cfs_rq[59]:/.avg->runnable_avg_sum
       581 ± 12%    +185.7%       1661 ± 17%  sched_debug.cpu#48.ttwu_local
     40432 ±  8%    +237.9%     136634 ±  1%  sched_debug.cfs_rq[58]:/.exec_clock
    193465 ±  9%     -67.5%      62936 ±  1%  sched_debug.cpu#37.ttwu_count
       308 ± 10%    +140.7%        742 ±  5%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
       176 ± 11%    +288.1%        683 ±  5%  sched_debug.cfs_rq[37]:/.tg_runnable_contrib
    187261 ±  7%     -68.1%      59804 ±  6%  sched_debug.cpu#35.sched_goidle
      8109 ± 10%    +287.2%      31401 ±  5%  sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum
     14139 ±  9%    +141.3%      34124 ±  5%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
    382269 ±  7%     -67.9%     122882 ±  5%  sched_debug.cpu#37.nr_switches
       315 ±  4%    +135.6%        742 ±  4%  sched_debug.cfs_rq[15]:/.tg_runnable_contrib
     14456 ±  4%    +136.0%      34117 ±  4%  sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
    281534 ±  3%     -86.8%      37215 ±  6%  cpuidle.C1E-NHM.usage
       603 ± 38%    +208.4%       1862 ±  8%  sched_debug.cpu#40.curr->pid
    495617 ±  3%     -77.0%     114184 ±  5%  sched_debug.cpu#57.nr_switches
    198497 ±  3%     -67.6%      64225 ±  0%  sched_debug.cpu#35.ttwu_count
    498597 ±  4%     -76.9%     115414 ±  4%  sched_debug.cpu#57.sched_count
    446635 ±  3%     -61.0%     174387 ± 28%  sched_debug.cpu#32.sched_count
         8 ± 16%     +62.9%         14 ± 15%  sched_debug.cpu#23.cpu_load[1]
    202136 ±  5%     -68.5%      63771 ±  3%  sched_debug.cpu#36.sched_goidle
       568 ± 24%    +226.5%       1856 ±  8%  sched_debug.cpu#53.curr->pid
       869 ± 19%    +109.7%       1822 ±  7%  sched_debug.cpu#12.curr->pid
     40794 ±  8%    +228.5%     133993 ±  1%  sched_debug.cfs_rq[63]:/.exec_clock
    191084 ±  7%     -66.8%      63524 ±  1%  sched_debug.cpu#36.ttwu_count
    183888 ±  8%     -65.6%      63297 ±  6%  sched_debug.cpu#52.sched_goidle
        10 ± 18%     +29.3%         13 ±  3%  sched_debug.cpu#30.cpu_load[3]
         5 ± 31%    +170.0%         13 ± 11%  sched_debug.cpu#9.cpu_load[4]
    189595 ±  8%     -66.4%      63732 ±  2%  sched_debug.cpu#34.ttwu_count
       181 ± 15%    +284.3%        696 ±  7%  sched_debug.cfs_rq[35]:/.tg_runnable_contrib
     10639 ± 12%    +240.2%      36198 ±  2%  sched_debug.cfs_rq[56]:/.avg->runnable_avg_sum
       231 ± 12%    +239.3%        785 ±  2%  sched_debug.cfs_rq[56]:/.tg_runnable_contrib
       558 ± 15%    +230.8%       1848 ±  4%  sched_debug.cpu#52.curr->pid
    375242 ±  7%     -66.9%     124149 ±  6%  sched_debug.cpu#35.nr_switches
       229 ±  2%    +238.5%        777 ±  1%  sched_debug.cfs_rq[61]:/.tg_runnable_contrib
      8353 ± 14%    +283.7%      32054 ±  7%  sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum
    173742 ± 13%     -64.5%      61631 ±  5%  sched_debug.cpu#49.sched_goidle
     10571 ±  2%    +237.9%      35717 ±  1%  sched_debug.cfs_rq[61]:/.avg->runnable_avg_sum
    197826 ±  8%     -67.3%      64771 ±  4%  sched_debug.cpu#38.sched_goidle
    404925 ±  5%     -67.4%     132191 ±  3%  sched_debug.cpu#36.nr_switches
    368375 ±  8%     -64.4%     131038 ±  6%  sched_debug.cpu#52.nr_switches
         4 ± 38%    +170.6%         11 ± 19%  sched_debug.cfs_rq[55]:/.runnable_load_avg
         5 ± 14%    +185.0%         14 ±  9%  sched_debug.cpu#60.cpu_load[1]
         4 ± 39%    +262.5%         14 ±  7%  sched_debug.cpu#56.cpu_load[4]
         5 ± 14%    +195.0%         14 ±  7%  sched_debug.cpu#58.cpu_load[3]
         4 ± 31%    +205.3%         14 ±  5%  sched_debug.cfs_rq[58]:/.runnable_load_avg
         1 ± 34%    +120.0%          2 ± 30%  sched_debug.cfs_rq[9]:/.nr_spread_over
         1 ±  0%    +200.0%          3 ± 40%  sched_debug.cfs_rq[1]:/.nr_spread_over
         4 ± 19%    +216.7%         14 ±  9%  sched_debug.cpu#60.cpu_load[2]
         4 ± 25%    +237.5%         13 ± 15%  sched_debug.cpu#54.cpu_load[2]
         5 ± 37%    +200.0%         15 ±  9%  sched_debug.cpu#61.cpu_load[3]
         4 ± 24%    +205.6%         13 ± 12%  sched_debug.cpu#54.cpu_load[1]
       445 ±  5%    +332.8%       1929 ± 12%  sched_debug.cpu#40.ttwu_local
       661 ± 16%    +184.0%       1877 ±  7%  sched_debug.cpu#37.curr->pid
    176233 ±  8%     -64.5%      62640 ±  2%  sched_debug.cpu#52.ttwu_count
       453 ± 19%    +319.1%       1898 ± 11%  sched_debug.cpu#46.ttwu_local
    167768 ± 12%     -64.8%      59130 ±  6%  sched_debug.cpu#53.sched_goidle
    383507 ±  7%     -66.9%     126751 ±  4%  sched_debug.cpu#37.sched_count
    189267 ± 14%     -66.6%      63161 ±  1%  sched_debug.cpu#38.ttwu_count
    271885 ±  4%     -75.2%      67422 ±  0%  sched_debug.cpu#62.ttwu_count
    396300 ±  8%     -66.1%     134542 ±  5%  sched_debug.cpu#38.nr_switches
    198817 ±  9%     -66.0%      67505 ±  4%  sched_debug.cpu#34.sched_goidle
     16468 ±  4%    +185.9%      47080 ±  1%  sched_debug.cfs_rq[3]:/.tg->runnable_avg
     16466 ±  4%    +185.8%      47066 ±  1%  sched_debug.cfs_rq[4]:/.tg->runnable_avg
     16459 ±  4%    +186.0%      47082 ±  1%  sched_debug.cfs_rq[2]:/.tg->runnable_avg
     16458 ±  4%    +186.0%      47063 ±  1%  sched_debug.cfs_rq[1]:/.tg->runnable_avg
     16484 ±  4%    +185.5%      47069 ±  1%  sched_debug.cfs_rq[6]:/.tg->runnable_avg
     10545 ± 10%    +215.5%      33271 ±  3%  sched_debug.cfs_rq[63]:/.avg->runnable_avg_sum
     16455 ±  4%    +186.0%      47061 ±  1%  sched_debug.cfs_rq[0]:/.tg->runnable_avg
     16495 ±  4%    +185.4%      47078 ±  1%  sched_debug.cfs_rq[7]:/.tg->runnable_avg
     16481 ±  4%    +185.5%      47062 ±  1%  sched_debug.cfs_rq[5]:/.tg->runnable_avg
        10 ± 48%    +182.9%         29 ± 44%  sched_debug.cfs_rq[34]:/.load
       229 ± 10%    +214.5%        722 ±  3%  sched_debug.cfs_rq[63]:/.tg_runnable_contrib
    405011 ±  5%     -66.1%     137434 ±  6%  sched_debug.cpu#36.sched_count
     16507 ±  4%    +185.2%      47087 ±  1%  sched_debug.cfs_rq[8]:/.tg->runnable_avg
     16516 ±  4%    +185.1%      47086 ±  1%  sched_debug.cfs_rq[9]:/.tg->runnable_avg
     16527 ±  4%    +185.1%      47117 ±  1%  sched_debug.cfs_rq[12]:/.tg->runnable_avg
     16525 ±  4%    +185.0%      47099 ±  1%  sched_debug.cfs_rq[11]:/.tg->runnable_avg
     16522 ±  4%    +185.0%      47089 ±  1%  sched_debug.cfs_rq[10]:/.tg->runnable_avg
     16528 ±  4%    +185.1%      47115 ±  1%  sched_debug.cfs_rq[13]:/.tg->runnable_avg
    348070 ± 13%     -63.1%     128384 ±  5%  sched_debug.cpu#49.nr_switches
       506 ±  6%    +197.3%       1504 ±  4%  sched_debug.cpu#53.ttwu_local
     16538 ±  4%    +184.9%      47115 ±  1%  sched_debug.cfs_rq[15]:/.tg->runnable_avg
     16539 ±  4%    +184.9%      47116 ±  1%  sched_debug.cfs_rq[14]:/.tg->runnable_avg
     16549 ±  4%    +184.8%      47129 ±  1%  sched_debug.cfs_rq[17]:/.tg->runnable_avg
     16543 ±  4%    +184.8%      47118 ±  1%  sched_debug.cfs_rq[16]:/.tg->runnable_avg
    184779 ± 11%     -66.2%      62497 ±  5%  sched_debug.cpu#48.sched_goidle
       941 ± 14%    +100.2%       1883 ± 11%  sched_debug.cpu#15.curr->pid
     16591 ±  4%    +184.2%      47159 ±  1%  sched_debug.cfs_rq[24]:/.tg->runnable_avg
     16562 ±  4%    +184.6%      47131 ±  1%  sched_debug.cfs_rq[18]:/.tg->runnable_avg
     16594 ±  4%    +184.2%      47166 ±  1%  sched_debug.cfs_rq[25]:/.tg->runnable_avg
     16593 ±  4%    +184.4%      47195 ±  1%  sched_debug.cfs_rq[28]:/.tg->runnable_avg
     16591 ±  4%    +184.4%      47192 ±  1%  sched_debug.cfs_rq[29]:/.tg->runnable_avg
     16597 ±  4%    +184.3%      47181 ±  1%  sched_debug.cfs_rq[26]:/.tg->runnable_avg
     16597 ±  4%    +184.4%      47195 ±  1%  sched_debug.cfs_rq[27]:/.tg->runnable_avg
     16570 ±  4%    +184.5%      47138 ±  1%  sched_debug.cfs_rq[19]:/.tg->runnable_avg
     16593 ±  4%    +184.2%      47152 ±  1%  sched_debug.cfs_rq[23]:/.tg->runnable_avg
     16587 ±  4%    +184.2%      47138 ±  1%  sched_debug.cfs_rq[22]:/.tg->runnable_avg
     16612 ±  4%    +184.1%      47192 ±  1%  sched_debug.cfs_rq[32]:/.tg->runnable_avg
     16600 ±  4%    +184.2%      47176 ±  1%  sched_debug.cfs_rq[30]:/.tg->runnable_avg
     16606 ±  4%    +184.2%      47196 ±  1%  sched_debug.cfs_rq[31]:/.tg->runnable_avg
     16580 ±  4%    +184.3%      47142 ±  1%  sched_debug.cfs_rq[21]:/.tg->runnable_avg
     16577 ±  4%    +184.4%      47142 ±  1%  sched_debug.cfs_rq[20]:/.tg->runnable_avg
     16626 ±  4%    +183.9%      47201 ±  1%  sched_debug.cfs_rq[34]:/.tg->runnable_avg
     16628 ±  4%    +183.9%      47199 ±  1%  sched_debug.cfs_rq[33]:/.tg->runnable_avg
     16636 ±  4%    +183.8%      47207 ±  1%  sched_debug.cfs_rq[36]:/.tg->runnable_avg
     16633 ±  4%    +183.8%      47204 ±  1%  sched_debug.cfs_rq[35]:/.tg->runnable_avg
     16641 ±  4%    +183.7%      47206 ±  1%  sched_debug.cfs_rq[37]:/.tg->runnable_avg
    183606 ± 14%     -66.0%      62470 ±  2%  sched_debug.cpu#51.ttwu_count
     16652 ±  4%    +183.5%      47213 ±  1%  sched_debug.cfs_rq[40]:/.tg->runnable_avg
     16650 ±  4%    +183.6%      47221 ±  1%  sched_debug.cfs_rq[41]:/.tg->runnable_avg
     16677 ±  4%    +183.3%      47243 ±  1%  sched_debug.cfs_rq[45]:/.tg->runnable_avg
    336124 ± 12%     -63.6%     122396 ±  6%  sched_debug.cpu#53.nr_switches
     16674 ±  4%    +183.4%      47248 ±  1%  sched_debug.cfs_rq[51]:/.tg->runnable_avg
     16659 ±  4%    +183.5%      47226 ±  1%  sched_debug.cfs_rq[42]:/.tg->runnable_avg
     16672 ±  4%    +183.3%      47235 ±  1%  sched_debug.cfs_rq[49]:/.tg->runnable_avg
     16653 ±  4%    +183.4%      47199 ±  1%  sched_debug.cfs_rq[39]:/.tg->runnable_avg
     16674 ±  4%    +183.3%      47243 ±  1%  sched_debug.cfs_rq[44]:/.tg->runnable_avg
     16651 ±  4%    +183.4%      47195 ±  1%  sched_debug.cfs_rq[38]:/.tg->runnable_avg
     14838 ±  7%    +126.6%      33617 ±  3%  sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum
     16677 ±  4%    +183.2%      47238 ±  1%  sched_debug.cfs_rq[50]:/.tg->runnable_avg
     16675 ±  4%    +183.2%      47224 ±  1%  sched_debug.cfs_rq[48]:/.tg->runnable_avg
     16683 ±  4%    +183.3%      47256 ±  1%  sched_debug.cfs_rq[52]:/.tg->runnable_avg
     16666 ±  4%    +183.4%      47227 ±  1%  sched_debug.cfs_rq[43]:/.tg->runnable_avg
        16 ±  6%    +193.9%         48 ±  1%  vmstat.procs.r
     16679 ±  4%    +183.2%      47228 ±  1%  sched_debug.cfs_rq[46]:/.tg->runnable_avg
     16680 ±  4%    +183.0%      47213 ±  1%  sched_debug.cfs_rq[47]:/.tg->runnable_avg
     16686 ±  4%    +183.2%      47259 ±  1%  sched_debug.cfs_rq[53]:/.tg->runnable_avg
     16704 ±  4%    +182.9%      47264 ±  1%  sched_debug.cfs_rq[55]:/.tg->runnable_avg
     16700 ±  4%    +183.0%      47264 ±  1%  sched_debug.cfs_rq[54]:/.tg->runnable_avg
     16720 ±  4%    +182.7%      47261 ±  1%  sched_debug.cfs_rq[57]:/.tg->runnable_avg
     16730 ±  4%    +182.5%      47256 ±  1%  sched_debug.cfs_rq[59]:/.tg->runnable_avg
     16726 ±  4%    +182.6%      47266 ±  1%  sched_debug.cfs_rq[58]:/.tg->runnable_avg
     16734 ±  4%    +182.5%      47268 ±  1%  sched_debug.cfs_rq[61]:/.tg->runnable_avg
     16733 ±  4%    +182.4%      47260 ±  1%  sched_debug.cfs_rq[60]:/.tg->runnable_avg
     16714 ±  4%    +182.8%      47260 ±  1%  sched_debug.cfs_rq[56]:/.tg->runnable_avg
     16759 ±  5%    +182.1%      47272 ±  1%  sched_debug.cfs_rq[63]:/.tg->runnable_avg
     16740 ±  4%    +182.3%      47264 ±  1%  sched_debug.cfs_rq[62]:/.tg->runnable_avg
    398244 ±  8%     -65.7%     136524 ±  5%  sched_debug.cpu#38.sched_count
    348117 ± 13%     -61.1%     135573 ±  9%  sched_debug.cpu#49.sched_count
    336174 ± 12%     -62.4%     126449 ±  7%  sched_debug.cpu#53.sched_count
     61049 ±  5%    +113.0%     130050 ±  0%  sched_debug.cfs_rq[18]:/.exec_clock
    398443 ±  9%     -64.9%     140004 ±  3%  sched_debug.cpu#34.nr_switches
         3 ± 39%    +323.1%         13 ±  3%  sched_debug.cpu#48.cpu_load[0]
         3 ± 25%    +323.1%         13 ±  3%  sched_debug.cpu#48.cpu_load[2]
         3 ± 33%    +284.6%         12 ±  4%  sched_debug.cpu#40.cpu_load[3]
         3 ± 31%    +292.9%         13 ±  3%  sched_debug.cpu#48.cpu_load[1]
    370157 ± 11%     -65.0%     129455 ±  4%  sched_debug.cpu#48.nr_switches
    173811 ± 10%     -63.9%      62775 ±  0%  sched_debug.cpu#48.ttwu_count
    376459 ±  7%     -64.9%     132057 ±  9%  sched_debug.cpu#35.sched_count
         5 ± 20%    +147.6%         13 ± 14%  sched_debug.cfs_rq[7]:/.runnable_load_avg
         4 ± 24%    +200.0%         13 ±  8%  sched_debug.cpu#38.cpu_load[3]
         4 ± 30%    +231.2%         13 ±  9%  sched_debug.cpu#54.cpu_load[0]
         5 ± 37%    +160.0%         13 ± 12%  sched_debug.cfs_rq[38]:/.runnable_load_avg
         5 ± 42%    +155.0%         12 ± 10%  sched_debug.cpu#50.cpu_load[0]
    398843 ±  9%     -64.4%     141829 ±  4%  sched_debug.cpu#34.sched_count
     29862 ± 10%    +315.1%     123964 ±  0%  sched_debug.cfs_rq[37]:/.exec_clock
     69.47 ±  1%     -64.5%      24.64 ±  1%  turbostat.%c1
       326 ±  5%    +125.0%        734 ±  6%  sched_debug.cfs_rq[22]:/.tg_runnable_contrib
     14948 ±  5%    +125.7%      33739 ±  6%  sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum
       565 ± 18%    +214.6%       1779 ± 13%  sched_debug.cpu#37.ttwu_local
       452 ± 18%    +283.9%       1737 ± 18%  sched_debug.cpu#49.ttwu_local
       721 ± 23%    +174.1%       1978 ±  7%  sched_debug.cpu#62.curr->pid
     29298 ±  4%    +320.8%     123279 ±  1%  sched_debug.cfs_rq[34]:/.exec_clock
     40698 ±  6%    +232.5%     135315 ±  0%  sched_debug.cfs_rq[59]:/.exec_clock
       534 ± 12%    +248.3%       1862 ± 30%  sched_debug.cpu#38.ttwu_local
        35 ± 35%     -54.3%         16 ±  8%  sched_debug.cfs_rq[14]:/.load
        35 ± 32%     -55.2%         16 ±  8%  sched_debug.cpu#14.load
      7610 ±  9%    +311.8%      31343 ± 13%  sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum
       686 ± 23%    +179.2%       1915 ±  2%  sched_debug.cpu#17.curr->pid
       166 ±  9%    +310.7%        681 ± 13%  sched_debug.cfs_rq[36]:/.tg_runnable_contrib
    368896 ±  7%     -62.8%     137215 ±  7%  sched_debug.cpu#52.sched_count
       791 ± 30%    +117.7%       1722 ±  9%  sched_debug.cpu#20.curr->pid
         5 ± 24%    +152.4%         13 ±  6%  sched_debug.cfs_rq[62]:/.runnable_load_avg
         6 ± 26%    +140.0%         15 ± 12%  sched_debug.cpu#61.cpu_load[0]
         5 ± 18%    +160.9%         15 ±  8%  sched_debug.cpu#58.cpu_load[2]
         6 ± 26%    +140.0%         15 ± 12%  sched_debug.cpu#61.cpu_load[1]
       680 ± 24%    +198.1%       2028 ± 12%  sched_debug.cpu#42.curr->pid
    174536 ± 16%    +243.0%     598575 ± 24%  sched_debug.cfs_rq[24]:/.spread0
       606 ± 34%    +242.2%       2075 ±  8%  sched_debug.cpu#41.curr->pid
      9829 ± 11%    +263.3%      35712 ±  5%  sched_debug.cfs_rq[60]:/.avg->runnable_avg_sum
       213 ± 11%    +263.4%        776 ±  5%  sched_debug.cfs_rq[60]:/.tg_runnable_contrib
         4 ± 40%    +172.2%         12 ± 10%  sched_debug.cfs_rq[42]:/.runnable_load_avg
         4 ± 19%    +211.8%         13 ±  8%  sched_debug.cpu#52.cpu_load[2]
         5 ± 48%    +131.8%         12 ±  8%  sched_debug.cfs_rq[46]:/.runnable_load_avg
         4 ± 11%    +255.6%         16 ±  4%  sched_debug.cpu#57.cpu_load[2]
         4 ± 19%    +205.9%         13 ±  5%  sched_debug.cpu#52.cpu_load[1]
         4 ± 30%    +182.4%         12 ± 14%  sched_debug.cfs_rq[51]:/.runnable_load_avg
         4 ± 25%    +231.2%         13 ±  3%  sched_debug.cpu#52.cpu_load[0]
         5 ± 14%    +150.0%         12 ± 14%  sched_debug.cpu#39.cpu_load[2]
         4 ± 25%    +225.0%         13 ±  5%  sched_debug.cfs_rq[52]:/.runnable_load_avg
         4 ± 40%    +172.2%         12 ± 17%  sched_debug.cpu#42.cpu_load[0]
         4 ± 34%    +194.1%         12 ±  8%  sched_debug.cpu#51.cpu_load[2]
         4 ± 24%    +177.8%         12 ± 14%  sched_debug.cpu#35.cpu_load[3]
      1308 ±  1%    +126.4%       2962 ± 49%  sched_debug.cpu#14.ttwu_local
       530 ± 29%    +206.5%       1626 ± 12%  sched_debug.cpu#50.ttwu_local
    170379 ±  7%     -66.0%      57923 ±  1%  sched_debug.cpu#55.sched_goidle
      9222 ±  9%    +248.6%      32152 ±  4%  sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum
       523 ± 36%    +237.7%       1766 ±  7%  sched_debug.cpu#59.curr->pid
       200 ±  9%    +249.4%        698 ±  4%  sched_debug.cfs_rq[38]:/.tg_runnable_contrib
       540 ± 22%    +250.5%       1894 ±  6%  sched_debug.cpu#60.curr->pid
    167034 ± 14%     -62.4%      62885 ±  5%  sched_debug.cpu#51.sched_goidle
         8 ± 23%     +81.2%         14 ± 14%  sched_debug.cpu#23.cpu_load[2]
       584 ± 25%    +189.3%       1691 ±  6%  sched_debug.cpu#43.ttwu_local
     59537 ±  3%    +114.7%     127808 ±  1%  sched_debug.cfs_rq[21]:/.exec_clock
   3500275 ±  3%    +151.4%    8797983 ±  0%  softirqs.TIMER
    341326 ±  7%     -64.6%     120668 ±  1%  sched_debug.cpu#55.nr_switches
    370336 ± 11%     -62.9%     137515 ±  7%  sched_debug.cpu#48.sched_count
         5 ± 25%    +178.3%         16 ± 22%  sched_debug.cpu#1.cpu_load[4]
         4 ± 45%    +222.2%         14 ±  7%  sched_debug.cpu#56.cpu_load[3]
         2 ±  0%    +125.0%          4 ± 24%  sched_debug.cfs_rq[0]:/.nr_spread_over
         5 ± 31%    +175.0%         13 ±  9%  sched_debug.cpu#38.cpu_load[2]
    190067 ±  3%     -66.9%      62977 ±  3%  sched_debug.cpu#33.sched_goidle
      8888 ± 12%    +265.4%      32480 ±  2%  sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum
    341372 ±  7%     -63.7%     123871 ±  3%  sched_debug.cpu#55.sched_count
    259809 ±  2%     -73.9%      67736 ±  1%  sched_debug.cpu#56.ttwu_count
       193 ± 12%    +265.1%        706 ±  2%  sched_debug.cfs_rq[34]:/.tg_runnable_contrib
    334659 ± 14%     -61.1%     130211 ±  5%  sched_debug.cpu#51.nr_switches
      1453 ± 22%    +136.1%       3431 ± 24%  sched_debug.cpu#12.ttwu_local
       328 ±  5%    +137.7%        780 ±  6%  sched_debug.cfs_rq[23]:/.tg_runnable_contrib
         7 ± 17%     +93.1%         14 ±  7%  sched_debug.cpu#18.cpu_load[3]
    190052 ±  4%     -66.3%      64136 ±  1%  sched_debug.cpu#33.ttwu_count
    181149 ±  7%     -65.5%      62508 ±  0%  sched_debug.cpu#55.ttwu_count
    380828 ±  3%     -65.7%     130803 ±  3%  sched_debug.cpu#33.nr_switches
       838 ± 11%    +128.7%       1918 ±  7%  sched_debug.cpu#23.curr->pid
     60928 ±  5%    +111.6%     128950 ±  1%  sched_debug.cfs_rq[22]:/.exec_clock
         5 ± 41%    +145.5%         13 ± 13%  sched_debug.cpu#41.cpu_load[1]
     15049 ±  5%    +138.4%      35879 ±  6%  sched_debug.cfs_rq[23]:/.avg->runnable_avg_sum
       782 ± 49%    +144.9%       1917 ± 19%  sched_debug.cpu#34.curr->pid
         4 ± 36%    +200.0%         13 ± 13%  sched_debug.cpu#41.cpu_load[2]
     14510 ±  3%    +133.1%      33826 ±  3%  sched_debug.cfs_rq[20]:/.avg->runnable_avg_sum
       316 ±  3%    +132.9%        737 ±  3%  sched_debug.cfs_rq[20]:/.tg_runnable_contrib
       612 ± 36%    +200.3%       1839 ±  4%  sched_debug.cpu#50.curr->pid
       337 ±  4%    +109.3%        705 ±  5%  sched_debug.cfs_rq[21]:/.tg_runnable_contrib
    382766 ±  3%     -64.5%     135808 ±  4%  sched_debug.cpu#33.sched_count
     14583 ±  4%    +141.9%      35280 ±  5%  sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
       318 ±  4%    +141.3%        768 ±  5%  sched_debug.cfs_rq[13]:/.tg_runnable_contrib
     15468 ±  5%    +109.6%      32424 ±  5%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
       787 ± 29%    +171.7%       2138 ±  7%  sched_debug.cpu#24.curr->pid
     20340 ±  1%     -57.8%       8589 ±  1%  uptime.idle
       950 ± 35%     +98.9%       1890 ± 11%  sched_debug.cpu#2.curr->pid
       315 ±  7%    +130.6%        726 ±  6%  sched_debug.cfs_rq[12]:/.tg_runnable_contrib
     14440 ±  7%    +131.2%      33389 ±  6%  sched_debug.cfs_rq[12]:/.avg->runnable_avg_sum
       432 ±  5%    +124.7%        972 ± 10%  sched_debug.cpu#60.ttwu_local
         5 ± 20%    +175.0%         13 ±  7%  sched_debug.cpu#62.cpu_load[3]
         5 ± 20%    +195.5%         16 ± 27%  sched_debug.cpu#8.cpu_load[4]
         5 ± 14%    +143.5%         14 ± 17%  sched_debug.cpu#15.cpu_load[4]
         6 ± 17%    +124.0%         14 ± 13%  sched_debug.cpu#13.cpu_load[4]
         5 ± 20%    +154.5%         14 ±  8%  sched_debug.cpu#5.cpu_load[4]
         5 ± 14%    +134.8%         13 ± 12%  sched_debug.cpu#22.cpu_load[4]
         5 ±  9%    +150.0%         13 ±  7%  sched_debug.cpu#60.cpu_load[0]
    335869 ± 14%     -59.3%     136745 ±  7%  sched_debug.cpu#51.sched_count
       866 ± 17%    +113.6%       1850 ± 17%  sched_debug.cpu#16.curr->pid
     14550 ±  1%    +136.4%      34401 ±  3%  sched_debug.cfs_rq[19]:/.avg->runnable_avg_sum
       843 ± 20%    +139.5%       2020 ±  7%  sched_debug.cpu#11.curr->pid
    598054 ± 10%     -53.8%     276304 ± 21%  sched_debug.cpu#42.avg_idle
         7 ± 14%     +64.5%         12 ±  6%  sched_debug.cpu#12.cpu_load[1]
       317 ±  1%    +135.9%        749 ±  3%  sched_debug.cfs_rq[19]:/.tg_runnable_contrib
       826 ± 17%    +146.3%       2036 ±  8%  sched_debug.cpu#3.curr->pid
         4 ± 43%    +173.7%         13 ± 14%  sched_debug.cfs_rq[41]:/.runnable_load_avg
     15098 ±  6%    +130.7%      34838 ±  2%  sched_debug.cfs_rq[7]:/.avg->runnable_avg_sum
    148254 ± 11%     -55.9%      65306 ±  0%  sched_debug.cpu#45.ttwu_count
       329 ±  6%    +130.3%        758 ±  2%  sched_debug.cfs_rq[7]:/.tg_runnable_contrib
    170167 ±  9%     -63.0%      63030 ±  2%  sched_debug.cpu#53.ttwu_count
       343 ±  8%    +113.8%        734 ±  4%  sched_debug.cfs_rq[4]:/.tg_runnable_contrib
         6 ± 23%    +130.8%         15 ±  8%  sched_debug.cpu#58.cpu_load[1]
     14279 ±  4%    +138.7%      34087 ±  1%  sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
       311 ±  4%    +137.7%        741 ±  1%  sched_debug.cfs_rq[8]:/.tg_runnable_contrib
       939 ± 17%     +97.2%       1852 ± 10%  sched_debug.cpu#35.ttwu_local
    148294 ± 16%     -56.5%      64514 ±  1%  sched_debug.cpu#45.sched_goidle
     15760 ±  8%    +113.6%      33671 ±  4%  sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum
         8 ± 19%     +68.8%         13 ±  3%  sched_debug.cpu#18.cpu_load[2]
         4 ± 33%    +177.8%         12 ± 16%  sched_debug.cfs_rq[32]:/.runnable_load_avg
    180819 ±  5%     -67.1%      59533 ±  3%  sched_debug.cpu#39.sched_goidle
      2125 ± 39%     +45.1%       3083 ± 38%  numa-vmstat.node2.nr_anon_pages
      8496 ± 39%     +45.2%      12333 ± 38%  numa-meminfo.node2.AnonPages
    177750 ±  9%     -65.1%      61959 ±  1%  sched_debug.cpu#50.ttwu_count
         5 ± 20%    +147.6%         13 ± 14%  sched_debug.cpu#32.cpu_load[1]
     15552 ±  2%    +124.5%      34911 ±  5%  sched_debug.cfs_rq[6]:/.avg->runnable_avg_sum
     15315 ±  4%    +121.2%      33874 ±  5%  sched_debug.cfs_rq[10]:/.avg->runnable_avg_sum
       339 ±  2%    +124.3%        760 ±  5%  sched_debug.cfs_rq[6]:/.tg_runnable_contrib
    297130 ± 16%     -54.9%     134084 ±  2%  sched_debug.cpu#45.nr_switches
       324 ±  7%    +126.0%        732 ±  3%  sched_debug.cfs_rq[18]:/.tg_runnable_contrib
       319 ±  5%    +124.3%        716 ±  3%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
       334 ±  4%    +120.6%        737 ±  4%  sched_debug.cfs_rq[10]:/.tg_runnable_contrib
     14627 ±  5%    +124.6%      32849 ±  3%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
        62 ± 15%     +81.7%        114 ± 22%  sched_debug.cfs_rq[35]:/.tg_load_contrib
     57625 ±  3%    +126.3%     130409 ±  1%  sched_debug.cfs_rq[9]:/.exec_clock
     15710 ±  6%    +126.1%      35526 ±  3%  sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum
     17785 ±  4%    +114.5%      38148 ±  2%  sched_debug.cfs_rq[24]:/.avg->runnable_avg_sum
    362283 ±  5%     -65.8%     123900 ±  3%  sched_debug.cpu#39.nr_switches
      9255 ± 40%     +41.6%      13110 ± 30%  numa-meminfo.node2.Active(anon)
      2315 ± 40%     +41.6%       3277 ± 30%  numa-vmstat.node2.nr_active_anon
       388 ±  4%    +113.7%        829 ±  2%  sched_debug.cfs_rq[24]:/.tg_runnable_contrib
     14664 ±  7%    +125.3%      33037 ±  5%  sched_debug.cfs_rq[14]:/.avg->runnable_avg_sum
    297259 ± 16%     -53.6%     138074 ±  1%  sched_debug.cpu#45.sched_count
     57759 ±  3%    +124.4%     129607 ±  3%  sched_debug.cfs_rq[12]:/.exec_clock
       343 ±  6%    +125.0%        773 ±  3%  sched_debug.cfs_rq[3]:/.tg_runnable_contrib
       320 ±  8%    +124.7%        719 ±  5%  sched_debug.cfs_rq[14]:/.tg_runnable_contrib
     15258 ±  8%    +123.9%      34162 ±  6%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
       355 ±  8%    +113.2%        757 ±  1%  sched_debug.cfs_rq[2]:/.tg_runnable_contrib
     59869 ±  4%    +119.1%     131193 ±  0%  sched_debug.cfs_rq[17]:/.exec_clock
     60764 ±  1%    +113.8%     129936 ±  3%  sched_debug.cfs_rq[8]:/.exec_clock
     16268 ±  8%    +113.6%      34751 ±  1%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
       333 ±  8%    +123.1%        743 ±  6%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
     15124 ±  9%    +125.6%      34123 ±  6%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
       333 ±  7%    +117.8%        726 ±  4%  sched_debug.cfs_rq[5]:/.tg_runnable_contrib
    177540 ±  9%     -64.7%      62756 ±  1%  sched_debug.cpu#54.ttwu_count
     15308 ±  7%    +118.0%      33371 ±  4%  sched_debug.cfs_rq[5]:/.avg->runnable_avg_sum
     59954 ±  6%    +117.7%     130516 ±  0%  sched_debug.cfs_rq[11]:/.exec_clock
     15754 ± 10%    +107.9%      32747 ±  6%  sched_debug.cfs_rq[16]:/.avg->runnable_avg_sum
         5 ± 22%    +134.8%         13 ± 11%  sched_debug.cpu#9.cpu_load[3]
       331 ±  9%    +124.8%        744 ±  6%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
       343 ± 10%    +107.4%        712 ±  6%  sched_debug.cfs_rq[16]:/.tg_runnable_contrib
         5 ± 20%    +127.3%         12 ± 14%  sched_debug.cpu#39.cpu_load[0]
         4 ± 27%    +168.4%         12 ±  8%  sched_debug.cpu#51.cpu_load[1]
         5 ± 14%    +113.0%         12 ±  6%  sched_debug.cfs_rq[17]:/.runnable_load_avg
         5 ± 30%    +122.7%         12 ± 17%  sched_debug.cfs_rq[35]:/.runnable_load_avg
         4 ± 27%    +157.9%         12 ± 10%  sched_debug.cpu#51.cpu_load[0]
         5 ± 20%    +127.3%         12 ± 14%  sched_debug.cpu#39.cpu_load[1]
         5 ± 32%    +131.8%         12 ±  8%  sched_debug.cpu#63.cpu_load[3]
         6 ± 19%     +81.5%         12 ± 12%  sched_debug.cpu#16.cpu_load[4]
         5 ± 24%    +138.1%         12 ± 14%  sched_debug.cpu#35.cpu_load[2]
    183707 ±  5%     -65.1%      64034 ±  1%  sched_debug.cpu#39.ttwu_count
    182822 ±  7%     -64.0%      65856 ±  4%  sched_debug.cpu#54.sched_goidle
         3 ± 43%    +233.3%         12 ±  8%  sched_debug.cpu#34.cpu_load[4]
        56 ± 20%     +78.4%        101 ± 24%  sched_debug.cfs_rq[35]:/.blocked_load_avg
    139252 ± 16%     -54.0%      64000 ±  2%  sched_debug.cpu#42.ttwu_count
     60499 ±  4%    +116.0%     130668 ±  0%  sched_debug.cfs_rq[16]:/.exec_clock
     15134 ±  9%    +129.3%      34698 ±  2%  sched_debug.cfs_rq[17]:/.avg->runnable_avg_sum
     60021 ±  4%    +116.8%     130132 ±  1%  sched_debug.cfs_rq[20]:/.exec_clock
     60178 ±  7%    +119.3%     131954 ±  3%  sched_debug.cfs_rq[10]:/.exec_clock
     60603 ±  4%    +116.1%     130941 ±  1%  sched_debug.cfs_rq[19]:/.exec_clock
         5 ± 22%    +147.8%         14 ±  9%  sched_debug.cpu#19.cpu_load[4]
         6 ± 21%    +133.3%         15 ± 19%  sched_debug.cpu#1.cpu_load[3]
         7 ± 20%    +114.3%         15 ± 12%  sched_debug.cpu#23.cpu_load[3]
         7 ± 10%    +103.6%         14 ±  5%  sched_debug.cpu#3.cpu_load[4]
         6 ± 26%    +125.0%         13 ± 15%  sched_debug.cfs_rq[11]:/.runnable_load_avg
         5 ± 37%    +145.5%         13 ± 12%  sched_debug.cpu#38.cpu_load[1]
         6 ± 20%    +140.0%         15 ± 12%  sched_debug.cpu#23.cpu_load[4]
         6 ± 26%    +103.7%         13 ± 13%  sched_debug.cfs_rq[19]:/.runnable_load_avg
       887 ± 19%    +138.4%       2114 ±  1%  sched_debug.cpu#1.curr->pid
       330 ±  9%    +128.9%        756 ±  2%  sched_debug.cfs_rq[17]:/.tg_runnable_contrib
     61838 ±  3%    +113.9%     132255 ±  0%  sched_debug.cfs_rq[1]:/.exec_clock
    125542 ±  9%     -48.0%      65277 ±  2%  sched_debug.cpu#41.sched_goidle
    363290 ±  5%     -64.2%     129971 ±  3%  sched_debug.cpu#39.sched_count
     61549 ±  2%    +110.5%     129558 ±  1%  sched_debug.cfs_rq[5]:/.exec_clock
    179177 ±  9%     -64.1%      64237 ±  4%  sched_debug.cpu#50.sched_goidle
     62105 ±  2%    +110.7%     130860 ±  1%  sched_debug.cfs_rq[4]:/.exec_clock
    366224 ±  7%     -62.8%     136064 ±  4%  sched_debug.cpu#54.nr_switches
       785 ± 17%    +144.2%       1918 ±  6%  sched_debug.cpu#63.curr->pid
         5 ± 24%    +155.0%         12 ± 15%  sched_debug.cpu#32.cpu_load[0]
    366355 ±  7%     -61.6%     140522 ±  7%  sched_debug.cpu#54.sched_count
     17897 ±  7%    +111.1%      37790 ±  4%  sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum
     18221 ±  8%    +102.9%      36980 ±  4%  sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum
    139298 ± 21%     -49.4%      70496 ±  4%  sched_debug.cpu#44.sched_goidle
       533 ± 26%    +188.1%       1535 ±  9%  sched_debug.cpu#51.ttwu_local
    251646 ±  9%     -46.2%     135449 ±  2%  sched_debug.cpu#41.nr_switches
        81 ± 31%     +92.0%        156 ± 16%  sched_debug.cpu#27.nr_uninterruptible
       397 ±  8%    +102.3%        803 ±  4%  sched_debug.cfs_rq[25]:/.tg_runnable_contrib
     62563 ±  4%    +111.3%     132217 ±  1%  sched_debug.cfs_rq[2]:/.exec_clock
        15 ± 20%     +68.3%         25 ± 42%  sched_debug.cfs_rq[61]:/.load
        15 ± 20%     +68.3%         25 ± 42%  sched_debug.cpu#61.load
       391 ±  7%    +110.3%        822 ±  4%  sched_debug.cfs_rq[31]:/.tg_runnable_contrib
    252106 ±  9%     -45.5%     137280 ±  3%  sched_debug.cpu#41.sched_count
    637864 ± 12%     -48.7%     327236 ± 15%  sched_debug.cpu#46.avg_idle
    358959 ±  9%     -63.0%     132896 ±  5%  sched_debug.cpu#50.nr_switches
         4 ± 31%    +173.7%         13 ±  9%  sched_debug.cpu#32.cpu_load[2]
         4 ± 25%    +206.2%         12 ±  8%  sched_debug.cpu#55.cpu_load[3]
     62121 ±  4%    +110.7%     130896 ±  1%  sched_debug.cfs_rq[6]:/.exec_clock
        64 ± 23%    +111.6%        136 ± 27%  sched_debug.cpu#8.nr_uninterruptible
    359157 ±  9%     -55.6%     159516 ± 28%  sched_debug.cpu#50.sched_count
       923 ± 21%    +112.5%       1963 ± 10%  sched_debug.cpu#19.curr->pid
     61984 ±  4%    +109.6%     129941 ±  0%  sched_debug.cfs_rq[7]:/.exec_clock
      1121 ± 19%     +89.5%       2125 ±  5%  sched_debug.cpu#31.curr->pid
     17994 ±  5%     +98.5%      35718 ±  1%  sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum
       102 ± 36%     -47.1%         54 ± 24%  sched_debug.cfs_rq[58]:/.blocked_load_avg
       392 ±  5%     +97.5%        775 ±  1%  sched_debug.cfs_rq[27]:/.tg_runnable_contrib
    279111 ± 21%     -47.7%     145948 ±  4%  sched_debug.cpu#44.nr_switches
     62503 ±  4%    +109.2%     130769 ±  0%  sched_debug.cfs_rq[3]:/.exec_clock
    129420 ±  6%     -48.2%      67042 ±  2%  sched_debug.cpu#40.ttwu_count
         8 ± 13%     +55.9%         13 ±  6%  sched_debug.cpu#18.cpu_load[1]
     18170 ±  8%     +99.1%      36176 ±  6%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
       396 ±  8%     +98.7%        788 ±  6%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
      1100 ±  5%     +91.6%       2108 ±  8%  sched_debug.cpu#34.ttwu_local
    125224 ± 22%     -47.0%      66368 ±  1%  sched_debug.cpu#44.ttwu_count
    131648 ± 15%     -51.2%      64301 ±  0%  sched_debug.cpu#43.ttwu_count
         5 ± 25%    +117.4%         12 ±  6%  sched_debug.cpu#20.cpu_load[4]
         8 ± 13%     +87.9%         15 ± 18%  sched_debug.cpu#36.load
         7 ± 17%    +132.1%         16 ± 27%  sched_debug.cpu#8.cpu_load[3]
         1 ± 33%    +150.0%          3 ± 22%  sched_debug.cfs_rq[13]:/.nr_spread_over
         5 ± 37%    +163.6%         14 ± 10%  sched_debug.cpu#56.cpu_load[2]
         6 ± 16%    +111.1%         14 ±  7%  sched_debug.cpu#7.cpu_load[3]
         5 ± 31%    +130.4%         13 ± 11%  sched_debug.cpu#38.cpu_load[0]
         8 ± 13%     +81.8%         15 ± 16%  sched_debug.cfs_rq[36]:/.load
         6 ± 13%    +128.0%         14 ±  7%  sched_debug.cpu#7.cpu_load[4]
         6 ± 25%    +107.7%         13 ±  8%  sched_debug.cpu#62.cpu_load[0]
         7 ± 10%     +92.9%         13 ± 16%  sched_debug.cpu#15.cpu_load[3]
         6 ± 26%    +103.7%         13 ±  3%  sched_debug.cpu#17.cpu_load[4]
         5 ± 41%    +152.2%         14 ± 10%  sched_debug.cpu#56.cpu_load[1]
         5 ± 41%    +139.1%         13 ±  7%  sched_debug.cpu#56.cpu_load[0]
         8 ± 13%     +69.7%         14 ± 14%  sched_debug.cpu#19.cpu_load[1]
         6 ± 16%     +85.2%         12 ± 12%  sched_debug.cfs_rq[16]:/.runnable_load_avg
         6 ± 26%    +129.2%         13 ±  7%  sched_debug.cpu#62.cpu_load[2]
         5 ± 31%    +130.4%         13 ±  9%  sched_debug.cpu#35.cpu_load[0]
         7 ± 20%    +103.6%         14 ± 12%  sched_debug.cpu#7.cpu_load[0]
         5 ± 24%    +133.3%         12 ±  8%  sched_debug.cpu#55.cpu_load[2]
         6 ± 33%    +122.2%         15 ±  8%  sched_debug.cpu#58.cpu_load[0]
     18222 ±  6%     +96.9%      35875 ±  4%  sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum
    146795 ± 16%     -53.1%      68791 ±  3%  sched_debug.cpu#42.sched_goidle
    128302 ±  7%     -48.8%      65646 ±  1%  sched_debug.cpu#41.ttwu_count
       397 ±  6%     +96.2%        780 ±  4%  sched_debug.cfs_rq[28]:/.tg_runnable_contrib
    279405 ± 21%     -45.8%     151308 ±  3%  sched_debug.cpu#44.sched_count
     68673 ±  1%    +101.0%     138021 ±  1%  sched_debug.cfs_rq[0]:/.exec_clock
     72077 ±  5%    +100.8%     144728 ±  0%  sched_debug.cpu#46.nr_load_updates
     71626 ±  3%    +101.8%     144571 ±  0%  sched_debug.cpu#47.nr_load_updates
       440 ± 10%     +96.9%        867 ±  8%  sched_debug.cpu#61.ttwu_local
    141858 ±  1%     -50.0%      70866 ±  3%  sched_debug.cpu#40.sched_goidle
        33 ± 36%     -49.3%         17 ±  4%  sched_debug.cfs_rq[0]:/.load
     73919 ±  0%     +97.9%     146324 ±  1%  sched_debug.cpu#40.nr_load_updates
     73274 ±  3%     +98.0%     145097 ±  0%  sched_debug.cpu#41.nr_load_updates
     17741 ±  7%    +102.7%      35954 ±  1%  sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum
     73236 ±  2%     +98.0%     145027 ±  0%  sched_debug.cfs_rq[24]:/.exec_clock
     72077 ±  2%     +99.4%     143704 ±  0%  sched_debug.cfs_rq[25]:/.exec_clock
       387 ±  7%    +102.1%        783 ±  1%  sched_debug.cfs_rq[30]:/.tg_runnable_contrib
         5 ± 46%    +145.0%         12 ± 12%  sched_debug.cpu#34.cpu_load[3]
        33 ± 39%     -49.3%         17 ±  7%  sched_debug.cpu#0.load
    294115 ± 16%     -51.6%     142381 ±  3%  sched_debug.cpu#42.nr_switches
       933 ± 18%    +112.0%       1978 ± 20%  sched_debug.cpu#22.curr->pid
       850 ± 14%    +111.4%       1797 ±  4%  sched_debug.cpu#4.curr->pid
         5 ± 20%    +118.2%         12 ± 15%  sched_debug.cpu#55.cpu_load[0]
     71684 ±  3%     +95.6%     140217 ±  0%  sched_debug.cfs_rq[29]:/.exec_clock
     73607 ±  6%     +98.7%     146254 ±  1%  sched_debug.cpu#44.nr_load_updates
    114289 ± 13%     -42.7%      65451 ±  0%  sched_debug.cpu#47.ttwu_count
     71217 ±  3%     +96.7%     140070 ±  0%  sched_debug.cfs_rq[28]:/.exec_clock
     72279 ±  3%     +95.6%     141391 ±  0%  sched_debug.cfs_rq[26]:/.exec_clock
       480 ±  2%     +76.0%        845 ± 11%  sched_debug.cpu#63.ttwu_local
     71428 ±  4%     +95.5%     139650 ±  0%  sched_debug.cfs_rq[31]:/.exec_clock
     72174 ±  4%     +94.9%     140663 ±  0%  sched_debug.cfs_rq[27]:/.exec_clock
     73935 ±  4%     +95.9%     144836 ±  0%  sched_debug.cpu#43.nr_load_updates
       469 ±  6%     +92.1%        902 ± 13%  sched_debug.cpu#59.ttwu_local
      1004 ± 21%     +95.8%       1966 ±  4%  sched_debug.cpu#29.curr->pid
      1103 ± 13%     +68.5%       1859 ± 11%  sched_debug.cpu#28.curr->pid
    284228 ±  1%     -48.4%     146748 ±  3%  sched_debug.cpu#40.nr_switches
    533580 ±  6%     -43.9%     299569 ± 15%  sched_debug.cpu#52.avg_idle
       985 ±  9%     +95.8%       1928 ±  5%  sched_debug.cpu#33.ttwu_local
       150 ± 16%     -55.5%         67 ± 32%  sched_debug.cfs_rq[52]:/.blocked_load_avg
         8 ±  9%     +91.4%         16 ±  4%  sched_debug.cpu#24.cpu_load[4]
        34 ± 36%     -51.4%         16 ± 14%  sched_debug.cfs_rq[28]:/.load
         9 ± 41%     +77.8%         16 ± 11%  sched_debug.cpu#54.load
         9 ± 41%     +77.8%         16 ± 11%  sched_debug.cfs_rq[54]:/.load
    288105 ±  2%     -48.2%     149355 ±  3%  sched_debug.cpu#40.sched_count
    574987 ± 15%     -44.0%     321728 ± 24%  sched_debug.cpu#49.avg_idle
     75106 ±  6%     +92.2%     144349 ±  0%  sched_debug.cpu#42.nr_load_updates
       887 ± 23%    +117.8%       1933 ± 10%  sched_debug.cpu#5.curr->pid
         7 ± 10%     +80.6%         14 ± 11%  sched_debug.cpu#19.cpu_load[2]
         7 ± 14%     +86.7%         14 ± 11%  sched_debug.cpu#5.cpu_load[2]
         7 ± 14%    +103.6%         14 ±  9%  sched_debug.cpu#19.cpu_load[3]
         7 ± 19%     +83.9%         14 ±  5%  sched_debug.cpu#3.cpu_load[0]
         6 ± 41%    +103.8%         13 ± 13%  sched_debug.cfs_rq[9]:/.runnable_load_avg
         7 ± 19%     +93.5%         15 ± 12%  sched_debug.cpu#1.cpu_load[2]
         7 ± 26%    +100.0%         14 ±  8%  sched_debug.cfs_rq[1]:/.runnable_load_avg
     72318 ±  4%     +91.9%     138766 ±  0%  sched_debug.cfs_rq[30]:/.exec_clock
    294503 ± 16%     -50.5%     145879 ±  4%  sched_debug.cpu#42.sched_count
         6 ± 21%     +77.8%         12 ±  8%  sched_debug.cpu#20.cpu_load[2]
         7 ± 20%     +80.0%         13 ± 15%  sched_debug.cpu#13.cpu_load[3]
         7 ± 20%     +70.0%         12 ±  3%  sched_debug.cfs_rq[12]:/.runnable_load_avg
         7 ± 36%     +82.1%         12 ±  8%  sched_debug.cpu#63.cpu_load[2]
         6 ± 20%    +104.0%         12 ±  6%  sched_debug.cpu#12.cpu_load[4]
         5 ± 20%    +122.7%         12 ± 13%  sched_debug.cpu#55.cpu_load[1]
         7 ± 35%     +73.3%         13 ±  5%  sched_debug.cfs_rq[0]:/.runnable_load_avg
         6 ± 20%    +104.0%         12 ± 11%  sched_debug.cpu#35.cpu_load[1]
         7 ± 26%     +71.4%         12 ±  8%  sched_debug.cpu#20.cpu_load[1]
         6 ±  6%     +92.6%         13 ±  5%  sched_debug.cfs_rq[3]:/.runnable_load_avg
         6 ±  7%    +107.7%         13 ± 11%  sched_debug.cpu#6.cpu_load[4]
         7 ± 26%     +82.1%         12 ±  3%  sched_debug.cpu#4.cpu_load[4]
         6 ± 27%     +96.2%         12 ±  3%  sched_debug.cpu#14.cpu_load[4]
         7 ± 10%     +71.4%         12 ± 13%  sched_debug.cpu#16.cpu_load[3]
    152023 ± 25%    +155.4%     388338 ± 34%  sched_debug.cfs_rq[28]:/.spread0
       905 ± 21%    +107.1%       1874 ± 15%  sched_debug.cpu#6.curr->pid
      1065 ± 14%     +82.7%       1945 ±  8%  sched_debug.cpu#30.curr->pid
    109213 ± 14%     -39.5%      66094 ±  2%  sched_debug.cpu#47.sched_goidle
       969 ± 27%    +110.6%       2042 ±  3%  sched_debug.cpu#9.curr->pid
    123361 ± 14%     -45.7%      66953 ±  4%  sched_debug.cpu#43.sched_goidle
     76544 ±  5%     +90.2%     145574 ±  0%  sched_debug.cpu#45.nr_load_updates
    624604 ±  7%     -46.8%     331988 ± 13%  sched_debug.cpu#44.avg_idle
    218936 ± 14%     -37.2%     137507 ±  2%  sched_debug.cpu#47.nr_switches
    519754 ± 12%     -38.6%     318976 ±  6%  sched_debug.cpu#33.avg_idle
      1048 ±  4%     +90.7%       1999 ±  4%  sched_debug.cpu#27.curr->pid
         9 ± 32%     +77.8%         16 ± 17%  sched_debug.cpu#50.load
         9 ± 32%     +75.0%         15 ± 15%  sched_debug.cfs_rq[50]:/.load
     80125 ±  3%     +80.9%     144977 ±  0%  sched_debug.cpu#54.nr_load_updates
     79744 ±  4%     +82.3%     145334 ±  1%  sched_debug.cpu#53.nr_load_updates
         6 ± 41%    +104.0%         12 ± 14%  sched_debug.cpu#34.cpu_load[2]
     80391 ±  2%     +79.7%     144447 ±  0%  sched_debug.cpu#52.nr_load_updates
     80078 ±  4%     +80.5%     144562 ±  0%  sched_debug.cpu#48.nr_load_updates
     80441 ±  5%     +79.8%     144606 ±  0%  sched_debug.cpu#51.nr_load_updates
     80274 ±  3%     +79.6%     144142 ±  0%  sched_debug.cpu#55.nr_load_updates
         8 ± 13%     +70.6%         14 ± 14%  sched_debug.cpu#5.cpu_load[1]
         8 ± 16%     +74.3%         15 ± 12%  sched_debug.cpu#0.cpu_load[3]
         8 ± 19%     +96.9%         15 ± 11%  sched_debug.cpu#0.cpu_load[4]
         9 ± 21%     +60.5%         15 ±  5%  sched_debug.cfs_rq[52]:/.load
    622405 ±  3%     -45.1%     341805 ± 14%  sched_debug.cpu#41.avg_idle
    247262 ± 14%     -43.8%     138983 ±  4%  sched_debug.cpu#43.nr_switches
    556949 ± 13%     -40.8%     329934 ± 13%  sched_debug.cpu#48.avg_idle
    220428 ± 13%     -29.8%     154692 ± 13%  sched_debug.cpu#47.sched_count
      1136 ± 12%     +67.9%       1907 ±  7%  sched_debug.cpu#26.curr->pid
       852 ± 18%    +117.6%       1855 ±  9%  sched_debug.cpu#8.curr->pid
         6 ± 23%    +112.0%         13 ±  8%  sched_debug.cpu#9.cpu_load[2]
     80479 ±  3%     +79.5%     144456 ±  0%  sched_debug.cpu#50.nr_load_updates
 5.655e+09 ±  3%     -58.4%  2.351e+09 ±  2%  cpuidle.C3-NHM.time
      1846 ± 11%     +59.3%       2941 ± 16%  sched_debug.cpu#2.ttwu_local
         7 ± 14%     +80.6%         14 ± 10%  sched_debug.cpu#7.cpu_load[1]
         8 ± 17%     +78.1%         14 ±  7%  sched_debug.cpu#1.cpu_load[1]
         7 ±  5%     +58.1%         12 ± 14%  sched_debug.cpu#16.cpu_load[2]
         6 ± 19%    +103.7%         13 ±  7%  sched_debug.cpu#62.cpu_load[1]
         7 ± 14%     +74.2%         13 ±  3%  sched_debug.cpu#2.cpu_load[4]
         7 ± 14%     +80.6%         14 ± 10%  sched_debug.cpu#7.cpu_load[2]
         6 ± 19%    +100.0%         13 ±  8%  sched_debug.cpu#5.cpu_load[3]
         7 ± 14%     +61.3%         12 ± 25%  sched_debug.cfs_rq[15]:/.runnable_load_avg
         6 ± 31%    +107.7%         13 ± 13%  sched_debug.cfs_rq[63]:/.runnable_load_avg
         7 ± 10%    +106.5%         16 ± 29%  sched_debug.cpu#8.cpu_load[2]
         8 ±  8%     +75.0%         14 ±  5%  sched_debug.cpu#3.cpu_load[3]
         7 ± 23%     +80.6%         14 ±  5%  sched_debug.cpu#17.cpu_load[3]
         8 ± 15%     +96.9%         15 ± 30%  sched_debug.cpu#8.cpu_load[0]
     83696 ±  0%     +74.1%     145676 ±  0%  sched_debug.cpu#34.nr_load_updates
     81108 ±  4%     +77.9%     144284 ±  0%  sched_debug.cpu#49.nr_load_updates
      1152 ± 10%     +93.6%       2230 ±  8%  sched_debug.cpu#32.ttwu_local
     83482 ±  4%     +74.1%     145347 ±  0%  sched_debug.cpu#38.nr_load_updates
    563098 ± 11%     -40.3%     336316 ± 11%  sched_debug.cpu#53.avg_idle
       473 ± 11%     +73.6%        821 ±  6%  sched_debug.cpu#62.ttwu_local
     84691 ±  1%     +72.7%     146295 ±  0%  sched_debug.cpu#35.nr_load_updates
        28 ± 37%     -43.8%         15 ± 16%  sched_debug.cfs_rq[13]:/.load
        27 ± 38%     -42.7%         15 ± 16%  sched_debug.cpu#13.load
     82882 ±  2%     +75.6%     145577 ±  0%  sched_debug.cpu#39.nr_load_updates
    498258 ±  7%     -32.4%     336924 ± 21%  sched_debug.cpu#34.avg_idle
     83560 ±  1%     +74.4%     145717 ±  0%  sched_debug.cpu#36.nr_load_updates
       469 ± 10%     +71.8%        807 ±  8%  sched_debug.cpu#57.ttwu_local
    247486 ± 14%     -41.8%     143921 ±  3%  sched_debug.cpu#43.sched_count
       155 ± 17%     -49.3%         78 ± 43%  sched_debug.cfs_rq[49]:/.blocked_load_avg
    527328 ± 14%     -32.7%     354686 ± 30%  sched_debug.cpu#50.avg_idle
       951 ± 18%     +96.5%       1868 ± 12%  sched_debug.cpu#21.curr->pid
       446 ±  8%     +88.5%        840 ±  8%  sched_debug.cpu#56.ttwu_local
         6 ± 17%     +84.6%         12 ±  5%  sched_debug.cpu#20.cpu_load[3]
     84258 ±  2%     +72.9%     145705 ±  0%  sched_debug.cpu#33.nr_load_updates
     84000 ±  3%     +73.6%     145816 ±  0%  sched_debug.cpu#37.nr_load_updates
         7 ± 48%    +103.3%         15 ± 15%  sched_debug.cfs_rq[49]:/.load
        10 ± 36%     +67.5%         16 ±  8%  sched_debug.cpu#41.load
    553971 ± 16%     -38.8%     338817 ± 26%  sched_debug.cpu#45.avg_idle
      1048 ± 22%     +89.7%       1988 ± 11%  sched_debug.cpu#10.curr->pid
     90262 ±  2%     +57.1%     141765 ±  1%  sched_debug.cpu#0.nr_load_updates
       883 ±  3%     -42.0%        512 ±  4%  cpuidle.POLL.usage
   2381442 ±  0%     -45.9%    1288111 ±  0%  cpuidle.C3-NHM.usage
    503911 ± 14%     -41.6%     294421 ± 20%  sched_debug.cpu#54.avg_idle
         8 ± 16%     +60.0%         14 ±  7%  sched_debug.cpu#3.cpu_load[1]
         8 ±  9%     +54.3%         13 ± 15%  sched_debug.cpu#19.cpu_load[0]
         8 ± 19%     +71.9%         13 ±  9%  sched_debug.cpu#17.cpu_load[1]
         9 ± 21%     +60.5%         15 ±  2%  sched_debug.cpu#52.load
       107 ± 34%     -36.0%         68 ± 17%  sched_debug.cfs_rq[58]:/.tg_load_contrib
    112841 ± 17%     -41.9%      65594 ±  1%  sched_debug.cpu#46.ttwu_count
    604642 ±  8%     -34.9%     393664 ± 28%  sched_debug.cpu#40.avg_idle
       154 ± 16%     -47.8%         80 ± 26%  sched_debug.cfs_rq[52]:/.tg_load_contrib
         7 ± 11%     +73.3%         13 ±  5%  sched_debug.cpu#18.cpu_load[0]
         7 ± 34%     +64.5%         12 ±  8%  sched_debug.cpu#63.cpu_load[1]
         6 ± 19%     +88.9%         12 ±  6%  sched_debug.cpu#12.cpu_load[3]
         7 ±  6%     +76.7%         13 ±  8%  sched_debug.cpu#6.cpu_load[3]
         5 ± 49%    +108.7%         12 ± 13%  sched_debug.cpu#45.cpu_load[0]
         7 ± 19%     +64.5%         12 ±  6%  sched_debug.cpu#4.cpu_load[3]
         7 ± 11%     +65.5%         12 ± 13%  sched_debug.cpu#21.cpu_load[3]
         7 ± 38%     +70.0%         12 ±  8%  sched_debug.cpu#63.cpu_load[0]
         7 ± 14%     +70.0%         12 ±  6%  sched_debug.cpu#12.cpu_load[2]
         7 ± 11%     +75.9%         12 ±  6%  sched_debug.cpu#12.cpu_load[0]
         7 ± 14%     +73.3%         13 ±  9%  sched_debug.cpu#10.cpu_load[4]
         6 ± 43%     +96.3%         13 ± 16%  sched_debug.cpu#34.cpu_load[1]
         7 ± 20%     +82.8%         13 ±  8%  sched_debug.cpu#9.cpu_load[1]
         7 ± 29%     +76.7%         13 ± 13%  sched_debug.cpu#9.cpu_load[0]
         6 ± 28%    +125.9%         15 ± 37%  sched_debug.cfs_rq[8]:/.runnable_load_avg
         8 ±  8%     +50.0%         12 ± 13%  sched_debug.cpu#21.cpu_load[2]
        99 ± 22%     -36.4%         63 ± 40%  sched_debug.cfs_rq[16]:/.tg_load_contrib
     92714 ±  2%     +65.3%     153258 ±  0%  sched_debug.cpu#56.nr_load_updates
    122255 ± 18%     -42.8%      69927 ±  3%  sched_debug.cpu#46.sched_goidle
      1038 ± 12%     +93.7%       2010 ± 21%  sched_debug.cpu#13.curr->pid
    637159 ±  6%     -42.8%     364152 ± 16%  sched_debug.cpu#47.avg_idle
         9 ± 20%     +75.0%         15 ± 13%  sched_debug.cfs_rq[53]:/.load
         8 ± 18%     +77.1%         15 ± 30%  sched_debug.cpu#5.cpu_load[0]
        10 ±  7%     +55.0%         15 ±  3%  sched_debug.cpu#24.cpu_load[2]
        10 ± 18%     +52.5%         15 ±  9%  sched_debug.cpu#0.cpu_load[2]
         9 ± 15%     +70.3%         15 ± 13%  sched_debug.cpu#53.load
         9 ±  8%     +64.1%         16 ±  4%  sched_debug.cpu#24.cpu_load[3]
     93245 ±  3%     +64.3%     153239 ±  0%  sched_debug.cpu#57.nr_load_updates
     93978 ±  3%     +63.3%     153433 ±  0%  sched_debug.cpu#58.nr_load_updates
        53 ± 20%     -48.1%         27 ± 39%  sched_debug.cfs_rq[24]:/.tg_load_contrib
     93568 ±  3%     +62.6%     152138 ±  0%  sched_debug.cpu#62.nr_load_updates
    505486 ± 18%     -33.6%     335452 ± 14%  sched_debug.cpu#35.avg_idle
     93233 ±  3%     +62.7%     151695 ±  0%  sched_debug.cpu#60.nr_load_updates
    245017 ± 18%     -40.9%     144877 ±  3%  sched_debug.cpu#46.nr_switches
     93586 ±  3%     +61.9%     151487 ±  0%  sched_debug.cpu#61.nr_load_updates
        11 ± 18%     +47.8%         17 ± 12%  sched_debug.cfs_rq[58]:/.load
        11 ± 27%     +54.5%         17 ± 12%  sched_debug.cpu#58.load
        27 ± 17%     -33.6%         18 ±  7%  sched_debug.cfs_rq[31]:/.load
     94340 ±  2%     +61.7%     152558 ±  0%  sched_debug.cpu#59.nr_load_updates
     94212 ±  3%     +60.6%     151306 ±  0%  sched_debug.cpu#63.nr_load_updates
       785 ± 14%     +29.1%       1014 ± 18%  sched_debug.cpu#30.ttwu_local
         8 ± 23%     +71.9%         13 ±  7%  sched_debug.cpu#17.cpu_load[2]
         8 ± 17%     +63.6%         13 ±  6%  sched_debug.cpu#2.cpu_load[3]
         8 ± 13%     +64.7%         14 ±  5%  sched_debug.cpu#3.cpu_load[2]
         9 ±  4%     +48.6%         13 ±  3%  sched_debug.cpu#27.cpu_load[4]
         8 ± 20%     +54.3%         13 ±  6%  sched_debug.cpu#2.cpu_load[2]
         7 ± 24%     +82.8%         13 ± 11%  sched_debug.cpu#17.cpu_load[0]
         8 ± 16%     +62.9%         14 ±  7%  sched_debug.cpu#1.cpu_load[0]
         8 ± 10%     +93.9%         16 ± 29%  sched_debug.cpu#8.cpu_load[1]
         8 ± 10%     +63.6%         13 ± 16%  sched_debug.cpu#15.cpu_load[2]
         9 ± 23%     +38.9%         12 ± 12%  sched_debug.cpu#16.cpu_load[0]
         8 ±  5%     +55.9%         13 ±  9%  sched_debug.cpu#10.cpu_load[3]
         8 ± 13%     +47.1%         12 ± 12%  sched_debug.cpu#16.cpu_load[1]
         6 ± 36%     +92.6%         13 ± 12%  sched_debug.cfs_rq[6]:/.runnable_load_avg
    502140 ± 12%     -35.6%     323535 ± 15%  sched_debug.cpu#51.avg_idle
    746062 ±  1%     -47.1%     394583 ±  0%  softirqs.SCHED
      1078 ±  4%     +50.7%       1625 ±  9%  sched_debug.cpu#22.ttwu_local
       740 ± 12%     +35.0%        999 ± 11%  sched_debug.cpu#25.ttwu_local
    245937 ± 18%     -39.0%     150096 ±  4%  sched_debug.cpu#46.sched_count
        78 ± 43%     -53.5%         36 ± 44%  sched_debug.cfs_rq[57]:/.tg_load_contrib
        28 ± 19%     -33.9%         18 ±  8%  sched_debug.cpu#31.load
         7 ± 14%     +76.7%         13 ± 16%  sched_debug.cfs_rq[22]:/.runnable_load_avg
        10 ± 12%     +41.9%         15 ±  2%  sched_debug.cpu#24.cpu_load[1]
        22 ±  7%     -31.1%         15 ±  7%  sched_debug.cpu#21.load
         7 ±  6%     +56.7%         11 ±  9%  sched_debug.cfs_rq[4]:/.runnable_load_avg
         9 ± 37%     +52.6%         14 ± 10%  sched_debug.cpu#2.cpu_load[0]
         7 ± 14%     +56.7%         11 ± 18%  sched_debug.cfs_rq[21]:/.runnable_load_avg
         9 ± 33%     +78.9%         17 ±  9%  sched_debug.cpu#42.load
      3.40 ±  2%     -45.0%       1.87 ±  8%  turbostat.%c3
        73 ± 29%     +66.6%        122 ± 21%  sched_debug.cpu#29.nr_uninterruptible
    611173 ±  6%     -49.8%     306820 ± 15%  sched_debug.cpu#43.avg_idle
   2095578 ±  1%     -31.4%    1438534 ±  0%  numa-meminfo.node3.SUnreclaim
    523718 ±  1%     -31.3%     359624 ±  0%  numa-vmstat.node3.nr_slab_unreclaimable
   2106490 ±  1%     -31.2%    1449462 ±  0%  numa-meminfo.node3.Slab
    886663 ±  1%     -31.2%     609723 ±  0%  numa-meminfo.node3.PageTables
    221608 ±  1%     -31.2%     152413 ±  0%  numa-vmstat.node3.nr_page_table_pages
        10 ± 23%     +52.5%         15 ± 12%  sched_debug.cpu#31.cpu_load[4]
         9 ± 32%     +70.3%         15 ±  6%  sched_debug.cfs_rq[42]:/.load
     86466 ±  2%     +69.6%     146665 ±  1%  sched_debug.cpu#32.nr_load_updates
      3404 ± 17%     +27.2%       4329 ± 12%  numa-meminfo.node2.Mapped
         8 ± 16%     +51.4%         13 ± 17%  sched_debug.cpu#13.cpu_load[2]
         8 ± 13%     +52.9%         13 ±  9%  sched_debug.cpu#6.cpu_load[0]
         7 ± 33%     +58.1%         12 ± 15%  sched_debug.cpu#21.cpu_load[0]
         8 ± 10%     +57.6%         13 ±  9%  sched_debug.cpu#6.cpu_load[2]
         8 ± 21%     +47.1%         12 ±  4%  sched_debug.cpu#14.cpu_load[2]
         9 ± 15%     +44.4%         13 ±  9%  sched_debug.cpu#4.cpu_load[1]
         8 ± 21%     +50.0%         12 ±  6%  sched_debug.cpu#4.cpu_load[2]
         8 ± 15%     +48.5%         12 ± 15%  sched_debug.cpu#21.cpu_load[1]
         8 ± 23%     +71.9%         13 ± 13%  sched_debug.cfs_rq[23]:/.runnable_load_avg
         8 ± 24%     +40.0%         12 ± 12%  sched_debug.cfs_rq[10]:/.runnable_load_avg
        27 ± 13%     -38.0%         16 ± 14%  sched_debug.cpu#28.load
    403384 ±  8%     -29.5%     284499 ± 10%  sched_debug.cpu#56.avg_idle
       852 ± 17%     +26.8%       1080 ± 12%  numa-vmstat.node2.nr_mapped
   3218544 ±  1%     -29.6%    2264649 ±  0%  numa-meminfo.node3.MemUsed
       703 ± 10%     +33.3%        938 ± 13%  sched_debug.cpu#31.ttwu_local
    488743 ± 12%     -37.1%     307311 ±  7%  sched_debug.cpu#39.avg_idle
         8 ± 37%     +88.6%         16 ± 10%  sched_debug.cfs_rq[39]:/.load
         9 ± 39%     +83.3%         16 ± 10%  sched_debug.cpu#39.load
         9 ±  5%     +39.5%         13 ±  9%  sched_debug.cpu#10.cpu_load[2]
         9 ± 14%     +48.6%         13 ±  3%  sched_debug.cfs_rq[25]:/.runnable_load_avg
        10 ±  7%     +35.0%         13 ±  8%  sched_debug.cpu#28.cpu_load[3]
         9 ± 15%     +43.2%         13 ± 18%  sched_debug.cpu#15.cpu_load[1]
        10 ±  7%     +35.0%         13 ±  3%  sched_debug.cpu#27.cpu_load[3]
         8 ± 14%     +51.4%         13 ±  9%  sched_debug.cpu#6.cpu_load[1]
         9 ±  8%     +45.9%         13 ±  8%  sched_debug.cpu#28.cpu_load[4]
    944754 ±  0%     -28.1%     678924 ±  1%  numa-numastat.node3.local_node
    948941 ±  0%     -28.0%     683119 ±  1%  numa-numastat.node3.numa_hit
    114901 ±  2%     +34.7%     154715 ±  1%  sched_debug.cpu#9.nr_load_updates
        25 ±  6%     -31.0%         17 ± 11%  sched_debug.cpu#30.load
      1460 ± 19%     +37.8%       2013 ± 10%  sched_debug.cpu#7.ttwu_local
    460171 ±  5%     -30.5%     319618 ± 10%  sched_debug.cpu#32.avg_idle
        10 ± 14%     +36.6%         14 ±  8%  sched_debug.cpu#25.cpu_load[4]
         8 ± 31%     +65.7%         14 ±  7%  sched_debug.cfs_rq[24]:/.runnable_load_avg
    607228 ±  1%     -27.9%     437862 ±  3%  numa-vmstat.node3.numa_local
    114663 ±  1%     +33.1%     152576 ±  1%  sched_debug.cpu#12.nr_load_updates
    513031 ± 16%     -32.2%     347796 ± 10%  sched_debug.cpu#37.avg_idle
      2004 ± 18%     +44.1%       2888 ± 11%  proc-vmstat.numa_pages_migrated
      2004 ± 18%     +44.1%       2888 ± 11%  proc-vmstat.pgmigrate_success
    644441 ±  1%     -26.3%     474922 ±  3%  numa-vmstat.node3.numa_hit
         7 ± 27%     +66.7%         12 ± 12%  sched_debug.cfs_rq[5]:/.runnable_load_avg
        11 ± 15%     +38.6%         15 ± 12%  sched_debug.cpu#31.cpu_load[3]
        11 ± 11%     +35.6%         15 ± 12%  sched_debug.cpu#31.cpu_load[2]
         7 ± 22%     +63.3%         12 ±  3%  sched_debug.cpu#14.cpu_load[3]
    116422 ±  2%     +32.4%     154101 ±  1%  sched_debug.cpu#10.nr_load_updates
       129 ±  9%     -36.4%         82 ± 27%  sched_debug.cfs_rq[44]:/.blocked_load_avg
    514997 ± 15%     -26.5%     378518 ±  6%  sched_debug.cpu#55.avg_idle
    511213 ± 14%     -23.4%     391526 ± 21%  sched_debug.cpu#36.avg_idle
      1107 ±  6%     +41.2%       1564 ± 14%  sched_debug.cpu#23.ttwu_local
    421195 ±  6%     -28.2%     302545 ± 12%  sched_debug.cpu#57.avg_idle
    116187 ±  1%     +31.2%     152493 ±  0%  sched_debug.cpu#11.nr_load_updates
    117788 ±  1%     +29.6%     152672 ±  1%  sched_debug.cpu#8.nr_load_updates
         9 ± 20%     +44.4%         13 ±  5%  sched_debug.cpu#4.cpu_load[0]
        10 ± 10%     +29.3%         13 ±  3%  sched_debug.cpu#27.cpu_load[2]
        10 ± 12%     +35.0%         13 ±  6%  sched_debug.cpu#28.cpu_load[2]
        10 ±  7%     +35.0%         13 ± 19%  sched_debug.cpu#13.cpu_load[1]
     41426 ±  7%     +36.8%      56660 ±  5%  proc-vmstat.numa_hint_faults_local
    114514 ±  1%     +34.0%     153480 ±  1%  sched_debug.cpu#14.nr_load_updates
    113983 ±  1%     +34.3%     153134 ±  1%  sched_debug.cpu#13.nr_load_updates
    117248 ±  1%     +29.9%     152335 ±  0%  sched_debug.cpu#17.nr_load_updates
    117878 ±  1%     +29.0%     152058 ±  0%  sched_debug.cpu#19.nr_load_updates
    118372 ±  1%     +28.3%     151813 ±  0%  sched_debug.cpu#16.nr_load_updates
        10 ± 14%     +23.8%         13 ±  7%  sched_debug.cpu#10.cpu_load[0]
        10 ±  8%     +26.8%         13 ±  7%  sched_debug.cpu#10.cpu_load[1]
        11 ± 12%     +22.7%         13 ±  3%  sched_debug.cpu#27.cpu_load[1]
         9 ± 27%     +52.8%         13 ±  7%  sched_debug.cpu#2.cpu_load[1]
    117488 ±  1%     +28.1%     150510 ±  0%  sched_debug.cpu#22.nr_load_updates
        13 ± 24%     +38.9%         18 ±  4%  sched_debug.cfs_rq[57]:/.load
        13 ± 26%     +38.9%         18 ±  4%  sched_debug.cpu#57.load
    117379 ±  1%     +27.9%     150133 ±  0%  sched_debug.cpu#21.nr_load_updates
   1602483 ±  3%     -19.6%    1288298 ±  0%  numa-meminfo.node0.SUnreclaim
    238564 ± 15%     +29.9%     309806 ±  6%  sched_debug.cpu#27.avg_idle
    311032 ±  2%     -22.7%     240441 ±  5%  sched_debug.cpu#8.avg_idle
    400457 ±  3%     -19.6%     322053 ±  0%  numa-vmstat.node0.nr_slab_unreclaimable
      1394 ± 12%     +28.9%       1797 ±  7%  sched_debug.cpu#6.ttwu_local
    120507 ±  1%     +26.0%     151799 ±  1%  sched_debug.cpu#6.nr_load_updates
    348850 ±  6%     -24.7%     262520 ± 21%  sched_debug.cpu#6.avg_idle
    675626 ±  3%     -19.6%     543470 ±  0%  numa-meminfo.node0.PageTables
    168838 ±  3%     -19.5%     135853 ±  0%  numa-vmstat.node0.nr_page_table_pages
    120183 ±  3%     +26.2%     151615 ±  0%  sched_debug.cpu#20.nr_load_updates
    120277 ±  1%     +25.9%     151380 ±  0%  sched_debug.cpu#7.nr_load_updates
  35935589 ±  0%     -20.4%   28606880 ±  0%  slabinfo.vm_area_struct.num_objs
    816717 ±  0%     -20.4%     650156 ±  0%  slabinfo.vm_area_struct.active_slabs
    816717 ±  0%     -20.4%     650156 ±  0%  slabinfo.vm_area_struct.num_slabs
    118159 ±  1%     +26.1%     148944 ±  0%  sched_debug.cpu#1.nr_load_updates
  35891627 ±  0%     -20.3%   28590239 ±  0%  slabinfo.vm_area_struct.active_objs
    120720 ±  1%     +24.9%     150796 ±  0%  sched_debug.cpu#4.nr_load_updates
    474282 ±  6%     -22.9%     365875 ± 19%  sched_debug.cpu#38.avg_idle
   1651580 ±  0%     -20.1%    1319009 ±  0%  proc-vmstat.nr_slab_unreclaimable
   6606619 ±  0%     -20.1%    5276360 ±  0%  meminfo.SUnreclaim
    120367 ±  1%     +24.9%     150388 ±  0%  sched_debug.cpu#5.nr_load_updates
        11 ± 14%     +34.1%         14 ± 10%  sched_debug.cfs_rq[31]:/.runnable_load_avg
        20 ±  5%     -24.7%         15 ±  8%  sched_debug.cfs_rq[21]:/.load
        12 ±  8%     +16.3%         14 ±  5%  sched_debug.cpu#25.cpu_load[0]
    696867 ±  0%     -20.0%     557635 ±  0%  proc-vmstat.nr_page_table_pages
   6653178 ±  0%     -20.0%    5322573 ±  0%  meminfo.Slab
    248196 ±  9%     +25.4%     311208 ± 12%  sched_debug.cpu#24.avg_idle
   2787604 ±  0%     -20.0%    2230917 ±  0%  meminfo.PageTables
 5.922e+08 ±  0%     -19.9%  4.747e+08 ±  0%  proc-vmstat.pgfault
    118211 ±  2%     +28.0%     151343 ±  0%  sched_debug.cpu#18.nr_load_updates
    120807 ±  1%     +24.7%     150598 ±  0%  sched_debug.cpu#3.nr_load_updates
    128900 ±  1%     +24.2%     160040 ±  0%  sched_debug.cpu#25.nr_load_updates
    121256 ±  1%     +24.3%     150777 ±  1%  sched_debug.cpu#2.nr_load_updates
    114909 ±  3%     +34.0%     153977 ±  1%  sched_debug.cpu#15.nr_load_updates
    128637 ±  1%     +23.4%     158697 ±  0%  sched_debug.cpu#26.nr_load_updates
    424064 ± 10%     -22.4%     328912 ± 13%  sched_debug.cpu#63.avg_idle
   2518148 ±  2%     -17.3%    2082266 ±  0%  numa-meminfo.node0.MemUsed
    377009 ± 10%     -22.9%     290499 ± 10%  sched_debug.cpu#58.avg_idle
      1751 ±  9%     +27.3%       2230 ±  8%  sched_debug.cpu#3.ttwu_local
    128243 ±  1%     +22.8%     157484 ±  0%  sched_debug.cpu#28.nr_load_updates
    128594 ±  1%     +22.3%     157264 ±  0%  sched_debug.cpu#29.nr_load_updates
    128398 ±  1%     +23.1%     158004 ±  0%  sched_debug.cpu#27.nr_load_updates
    129844 ±  1%     +24.5%     161710 ±  0%  sched_debug.cpu#24.nr_load_updates
    128589 ±  1%     +21.7%     156520 ±  0%  sched_debug.cpu#30.nr_load_updates
    127546 ±  1%     +22.9%     156748 ±  0%  sched_debug.cpu#31.nr_load_updates
       134 ±  7%     -29.4%         95 ± 24%  sched_debug.cfs_rq[44]:/.tg_load_contrib
     70304 ±  8%     +22.6%      86182 ±  3%  proc-vmstat.numa_hint_faults
        29 ± 39%     -37.0%         18 ±  2%  sched_debug.cfs_rq[25]:/.load
        28 ± 44%     -33.6%         18 ±  2%  sched_debug.cpu#25.load
    272672 ±  2%     -15.8%     229700 ±  1%  proc-vmstat.pgalloc_dma32
    363798 ± 12%     -21.2%     286629 ± 13%  sched_debug.cpu#59.avg_idle
   1613943 ±  3%     -19.5%    1298521 ±  0%  numa-meminfo.node0.Slab
    117340 ±  1%     +28.4%     150721 ±  0%  sched_debug.cpu#23.nr_load_updates
   4814407 ±  0%     -16.8%    4004118 ±  1%  proc-vmstat.pgfree
   1552099 ±  0%     -16.8%    1291492 ±  0%  numa-meminfo.node2.Slab
    649904 ±  0%     -16.7%     541350 ±  0%  numa-meminfo.node2.PageTables
    162410 ±  0%     -16.7%     135321 ±  0%  numa-vmstat.node2.nr_page_table_pages
   1540899 ±  0%     -17.0%    1279172 ±  0%  numa-meminfo.node2.SUnreclaim
    385059 ±  0%     -17.0%     319769 ±  0%  numa-vmstat.node2.nr_slab_unreclaimable
   4548086 ±  0%     -16.4%    3804042 ±  1%  proc-vmstat.pgalloc_normal
   1255200 ±  0%     +19.0%    1493504 ±  0%  numa-vmstat.node3.nr_free_pages
   5019891 ±  0%     +19.0%    5973786 ±  0%  numa-meminfo.node3.MemFree
      5905 ±  2%     -14.0%       5081 ±  0%  sched_debug.cfs_rq[2]:/.tg_load_avg
      5916 ±  2%     -14.2%       5077 ±  0%  sched_debug.cfs_rq[0]:/.tg_load_avg
      5918 ±  2%     -14.0%       5087 ±  0%  sched_debug.cfs_rq[1]:/.tg_load_avg
   2423291 ±  1%     -15.3%    2052984 ±  0%  numa-meminfo.node2.MemUsed
        10 ± 12%     +26.8%         13 ±  9%  sched_debug.cpu#28.cpu_load[1]
      0.13 ±  3%     -15.7%       0.11 ± 10%  turbostat.%pc3
   3420656 ±  0%     -15.1%    2903309 ±  2%  proc-vmstat.numa_local
   3433217 ±  0%     -15.1%    2915876 ±  2%  proc-vmstat.numa_hit
    838458 ±  1%     -13.0%     729220 ±  2%  numa-numastat.node0.local_node
    736674 ±  3%     +18.6%     874029 ±  1%  softirqs.RCU
    840554 ±  1%     -12.9%     732351 ±  2%  numa-numastat.node0.numa_hit
      5802 ±  3%     -12.5%       5078 ±  0%  sched_debug.cfs_rq[3]:/.tg_load_avg
      5730 ±  3%     -11.3%       5083 ±  0%  sched_debug.cfs_rq[4]:/.tg_load_avg
    533590 ±  2%     -11.2%     473739 ±  1%  numa-vmstat.node0.numa_local
    237268 ±  7%     +27.6%     302850 ± 13%  sched_debug.cpu#28.avg_idle
    565252 ±  2%     -10.4%     506412 ±  1%  numa-vmstat.node0.numa_hit
      5709 ±  3%     -11.1%       5077 ±  0%  sched_debug.cfs_rq[5]:/.tg_load_avg
    111048 ±  5%     -13.4%      96201 ± 10%  meminfo.DirectMap4k
      5698 ±  3%     -10.8%       5084 ±  0%  sched_debug.cfs_rq[6]:/.tg_load_avg
    270517 ±  8%     +11.1%     300584 ±  4%  sched_debug.cpu#29.avg_idle
        12 ± 19%     +32.7%         16 ±  6%  sched_debug.cpu#38.load
        12 ± 19%     +32.7%         16 ±  6%  sched_debug.cfs_rq[38]:/.load
      5703 ±  3%     -11.1%       5071 ±  0%  sched_debug.cfs_rq[7]:/.tg_load_avg
      5701 ±  3%     -10.9%       5081 ±  0%  sched_debug.cfs_rq[8]:/.tg_load_avg
    537830 ±  1%     -12.3%     471678 ±  1%  numa-vmstat.node2.numa_local
      5708 ±  2%     -10.6%       5102 ±  0%  sched_debug.cfs_rq[9]:/.tg_load_avg
    824960 ±  2%     -10.8%     735556 ±  1%  numa-numastat.node2.local_node
    829145 ±  2%     -10.9%     738701 ±  1%  numa-numastat.node2.numa_hit
      5670 ±  2%     -10.0%       5101 ±  0%  sched_debug.cfs_rq[10]:/.tg_load_avg
      5663 ±  2%      -9.9%       5100 ±  0%  sched_debug.cfs_rq[11]:/.tg_load_avg
    574968 ±  0%     -11.6%     508060 ±  1%  numa-vmstat.node2.numa_hit
      5660 ±  2%      -9.7%       5109 ±  0%  sched_debug.cfs_rq[12]:/.tg_load_avg
      5580 ±  1%      -9.5%       5050 ±  1%  sched_debug.cfs_rq[34]:/.tg_load_avg
      5578 ±  1%      -9.5%       5049 ±  1%  sched_debug.cfs_rq[33]:/.tg_load_avg
      5655 ±  1%     -10.1%       5085 ±  1%  sched_debug.cfs_rq[14]:/.tg_load_avg
      5651 ±  1%      -9.9%       5092 ±  0%  sched_debug.cfs_rq[15]:/.tg_load_avg
      5656 ±  2%      -9.6%       5111 ±  0%  sched_debug.cfs_rq[13]:/.tg_load_avg
      5615 ±  1%      -9.4%       5086 ±  1%  sched_debug.cfs_rq[19]:/.tg_load_avg
      5631 ±  1%      -9.7%       5085 ±  1%  sched_debug.cfs_rq[20]:/.tg_load_avg
      9735 ±  6%     +11.7%      10878 ±  3%  slabinfo.anon_vma.active_objs
      9735 ±  6%     +11.7%      10878 ±  3%  slabinfo.anon_vma.num_objs
      5635 ±  1%      -9.6%       5094 ±  1%  sched_debug.cfs_rq[21]:/.tg_load_avg
      5645 ±  1%      -9.8%       5090 ±  0%  sched_debug.cfs_rq[16]:/.tg_load_avg
      5400 ±  1%      -8.4%       4949 ±  2%  sched_debug.cfs_rq[63]:/.tg_load_avg
      5388 ±  2%      -8.2%       4948 ±  2%  sched_debug.cfs_rq[62]:/.tg_load_avg
      5569 ±  1%      -9.0%       5070 ±  1%  sched_debug.cfs_rq[35]:/.tg_load_avg
      5566 ±  1%      -9.1%       5060 ±  1%  sched_debug.cfs_rq[40]:/.tg_load_avg
      5392 ±  2%      -8.1%       4955 ±  2%  sched_debug.cfs_rq[61]:/.tg_load_avg
      5623 ±  1%      -9.5%       5087 ±  1%  sched_debug.cfs_rq[18]:/.tg_load_avg
      5562 ±  1%      -9.0%       5064 ±  1%  sched_debug.cfs_rq[37]:/.tg_load_avg
      5395 ±  2%      -7.8%       4974 ±  2%  sched_debug.cfs_rq[60]:/.tg_load_avg
      5638 ±  1%      -9.9%       5081 ±  0%  sched_debug.cfs_rq[17]:/.tg_load_avg
      5565 ±  1%      -8.9%       5070 ±  1%  sched_debug.cfs_rq[36]:/.tg_load_avg
      5502 ±  2%      -9.4%       4985 ±  2%  sched_debug.cfs_rq[47]:/.tg_load_avg
      5581 ±  1%      -9.6%       5042 ±  1%  sched_debug.cfs_rq[43]:/.tg_load_avg
      5526 ±  3%      -9.6%       4995 ±  2%  sched_debug.cfs_rq[46]:/.tg_load_avg
      5558 ±  1%      -8.9%       5063 ±  1%  sched_debug.cfs_rq[39]:/.tg_load_avg
      5581 ±  1%      -8.8%       5091 ±  1%  sched_debug.cfs_rq[32]:/.tg_load_avg
      5622 ±  1%      -9.3%       5102 ±  1%  sched_debug.cfs_rq[27]:/.tg_load_avg
      5559 ±  1%      -8.8%       5070 ±  1%  sched_debug.cfs_rq[38]:/.tg_load_avg
      5567 ±  1%      -9.7%       5028 ±  1%  sched_debug.cfs_rq[45]:/.tg_load_avg
      5588 ±  1%      -9.9%       5036 ±  1%  sched_debug.cfs_rq[44]:/.tg_load_avg
      5603 ±  1%      -8.9%       5102 ±  1%  sched_debug.cfs_rq[28]:/.tg_load_avg
     40992 ±  8%    +525.7%     256479 ±  1%  time.involuntary_context_switches
  37575247 ±  0%     -81.1%    7104211 ±  1%  time.voluntary_context_switches
    206833 ±  0%     -78.8%      43766 ±  0%  vmstat.system.cs
      5002 ±  4%    +209.3%      15474 ±  0%  time.system_time
      1649 ±  3%    +185.0%       4701 ±  0%  time.percent_of_cpu_this_job_got
     27.13 ±  3%    +170.9%      73.49 ±  0%  turbostat.%c0
     24116 ±  5%    +133.1%      56210 ±  9%  vmstat.system.in
 5.909e+08 ±  0%     -19.9%  4.734e+08 ±  0%  time.minor_page_faults
       369 ±  0%      -4.6%        352 ±  0%  time.elapsed_time

lkp-nex05: Nehalem-EX
Memory: 192G

lkp-nex06: Nehalem-EX
Memory: 64G




                                 time.elapsed_time

  375 ++--------------------------------------------------------------------+
      |                 *..      .*...  .*...  .*.                          |
      |               ..   *...*.     *.     *.   ..                        |
  370 ++             .                                .*...*..      .*...*..*
      *...*..*...*..*                               *.        *...*.        |
      |                                                                     |
  365 ++                                                                    |
      |                                                                     |
  360 ++                                                                    |
      |                                                                     |
      |                                                                     |
  355 O+  O         O                                                       |
      |      O                 O  O             O                 O         |
      |          O      O  O          O  O          O  O   O  O      O   O  O
  350 ++-------------------------------------O------------------------------+


                                time.minor_page_faults

  6.2e+08 ++----------------------------------------------------------------+
          |                  .*..                                           |
    6e+08 *+.*...*..*..  ..*.    *..*...*..*..*...*..                  ..*..*
  5.8e+08 ++           *.                            *..*...*..*..*..*.     |
          |                                                                 |
  5.6e+08 ++                                                                |
          |                                                                 |
  5.4e+08 ++                                                                |
          |                                                                 |
  5.2e+08 ++                                                                |
    5e+08 O+ O   O  O  O                                                    |
          |                                                                 |
  4.8e+08 ++                                                                |
          |                O  O  O  O   O  O  O   O  O  O   O  O  O  O   O  O
  4.6e+08 ++----------------------------------------------------------------+


                               vm-scalability.throughput

  9.5e+06 ++----------------------------------------------------------------+
          |                                                                 |
    9e+06 ++             ..*..*..               ..*..                       |
          *..*...*..*..*.        *..*...*..*..*.     *..*...*..*..*..*...*..*
          |                                                                 |
  8.5e+06 ++                                                                |
          |                                                                 |
    8e+06 ++                                                                |
          |                                                                 |
  7.5e+06 O+ O   O  O  O                                                    |
          |                                                                 |
          |                   O  O      O     O   O  O  O   O  O  O  O   O  O
    7e+06 ++               O        O      O                                |
          |                                                                 |
  6.5e+06 ++----------------------------------------------------------------+


                                cpuidle.C1E-NHM.time

  8e+07 ++----------------------------------------------*--*---------*------+
        |                                           *.        *...*.     *..|
  7e+07 ++       .*...                   .*..     ..                        *
  6e+07 *+.*...*.     *..*..   .*..*...*.      ..*                          |
        |                    ..              *.                             |
  5e+07 ++                  *                                               |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++               O  O   O  O   O  O      O                   O      |
  2e+07 ++                                   O      O   O  O  O   O      O  O
        |                                                                   |
  1e+07 ++                                                                  |
        |                                                                   |
      0 O+-O---O--O---O-----------------------------------------------------+


                                cpuidle.C1E-NHM.usage

  300000 ++---------------------------------------------*--*---*-----*------+
         |                                           *.           *.     *..*
  250000 ++                                        ..                       |
         *..*...*..*..*...*..   *...*..*...*..*.. .                         |
         |                    ..                 *                          |
  200000 ++                  *                                              |
         |                                                                  |
  150000 ++                                                                 |
         |                                                                  |
  100000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   50000 ++               O  O  O   O  O   O  O  O   O  O  O   O  O  O   O  O
         O  O   O  O  O                                                     |
       0 ++-----------------------------------------------------------------+


                           proc-vmstat.nr_slab_unreclaimable

   1.7e+06 ++------------------*------------------*-------------------------+
           *..*...*..*..  .*.     *..*..*...*..*.                       .*..*
  1.65e+06 ++           *.                           *...*..*..*..*...*.    |
   1.6e+06 ++                                                               |
           |                                                                |
  1.55e+06 ++                                                               |
   1.5e+06 ++                                                               |
           |                                                                |
  1.45e+06 ++                                                               |
   1.4e+06 O+ O   O  O  O                                                   |
           |                                                                |
  1.35e+06 ++                                                               |
   1.3e+06 ++              O   O  O  O  O   O  O  O  O   O  O  O  O   O  O  O
           |                                                                |
  1.25e+06 ++---------------------------------------------------------------+


                           proc-vmstat.nr_page_table_pages

  720000 ++------------------*----------------------------------------------+
         *..            ..*.    *...*..*...*..*..*...                       |
  700000 ++ *...*..*..*.                             *..*..*...*..*..*...*..*
  680000 ++                                                                 |
         |                                                                  |
  660000 ++                                                                 |
  640000 ++                                                                 |
         |                                                                  |
  620000 ++                                                                 |
  600000 ++                                                                 |
         O  O   O  O  O                                                     |
  580000 ++                                                                 |
  560000 ++                                                              O  |
         |                O  O  O   O  O   O  O  O   O  O  O   O  O  O      O
  540000 ++-----------------------------------------------------------------+


                                 proc-vmstat.numa_hit

  3.6e+06 ++----------------------------------------------------------------+
          |                   *..                                           |
  3.5e+06 ++                ..   *..  ..*..*..*...*..                  ..*..|
          *..*...*..*..*...*        *.                 .*...*..*..*..*.     *
  3.4e+06 ++                                         *.                     |
  3.3e+06 ++                                                                |
          |                                                                 |
  3.2e+06 ++                                                                |
          |                                                                 |
  3.1e+06 ++                                                                |
    3e+06 O+ O   O  O                                                       |
          |            O      O     O         O      O      O            O  |
  2.9e+06 ++               O     O      O  O      O     O      O  O         O
          |                                                                 |
  2.8e+06 ++---------------------------------------------------------O------+


                                proc-vmstat.numa_local

  3.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  3.5e+06 ++                 .*..     ..*..  .*...*..                  ..*..|
          *..*...*..*..*...*.    *..*.     *.          .*...*..*..*..*.     |
  3.4e+06 ++                                         *.                     *
  3.3e+06 ++                                                                |
          |                                                                 |
  3.2e+06 ++                                                                |
          |                                                                 |
  3.1e+06 ++                                                                |
    3e+06 ++     O  O                                                       |
          O  O         O      O     O         O      O      O            O  |
  2.9e+06 ++               O     O         O      O     O      O  O         O
          |                             O                                   |
  2.8e+06 ++---------------------------------------------------------O------+


                              proc-vmstat.pgalloc_normal

  4.7e+06 ++----------------------------------------------------------------+
  4.6e+06 ++                 .*..     ..*..*..*...*                    ..*..|
          *..*...*..*..*...*.      .*.             +    *...*..*..*..*.     *
  4.5e+06 ++                     *.                 + ..                    |
  4.4e+06 ++                                         *                      |
          |                                                                 |
  4.3e+06 ++                                                                |
  4.2e+06 ++                                                                |
  4.1e+06 ++                                                                |
          |                                                                 |
    4e+06 ++ O   O  O                                                       |
  3.9e+06 O+           O                                                 O  |
          |                   O     O         O      O      O     O         |
  3.8e+06 ++               O     O      O  O      O     O      O            O
  3.7e+06 ++---------------------------------------------------------O------+


                                  proc-vmstat.pgfree

    5e+06 ++----------------------------------------------------------------+
          |                  .*..     ..*..  .*...*..                       |
  4.8e+06 ++.*...  .*..*...*.    *..*.     *.          .*...*..*..*..*...*..|
          *.     *.                                  *.                     *
          |                                                                 |
  4.6e+06 ++                                                                |
          |                                                                 |
  4.4e+06 ++                                                                |
          |                                                                 |
  4.2e+06 O+ O   O  O                                                       |
          |            O                                                    |
          |                   O  O      O     O   O  O  O   O  O         O  O
    4e+06 ++               O        O      O                      O  O      |
          |                                                                 |
  3.8e+06 ++----------------------------------------------------------------+


                                  proc-vmstat.pgfault

  6.2e+08 ++----------------------------------------------------------------+
          |                  .*..               ..*..                       |
    6e+08 *+.*...*..*..*...*.    *..*...*..*..*.              .*..*..  ..*..*
  5.8e+08 ++                                         *..*...*.       *.     |
          |                                                                 |
  5.6e+08 ++                                                                |
          |                                                                 |
  5.4e+08 ++                                                                |
          |                                                                 |
  5.2e+08 ++                                                                |
    5e+08 O+ O   O  O  O                                                    |
          |                                                                 |
  4.8e+08 ++                                                             O  |
          |                O  O  O  O   O  O  O   O  O  O   O  O  O  O      O
  4.6e+08 ++----------------------------------------------------------------+


                                     meminfo.Slab

    7e+06 ++----------------------------------------------------------------+
          |                  .*..               ..*..                       |
  6.8e+06 *+.  ..*..     ..*.    *..*...*..*..*.                            |
  6.6e+06 ++ *.     *..*.                            *..*...*..*..*..*...*..*
          |                                                                 |
  6.4e+06 ++                                                                |
  6.2e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
  5.8e+06 ++                                                                |
          O  O   O     O                                                    |
  5.6e+06 ++        O                                                       |
  5.4e+06 ++                                                                |
          |                   O  O  O   O     O   O  O  O   O  O  O  O   O  O
  5.2e+06 ++---------------O---------------O--------------------------------+


                                  meminfo.SUnreclaim

  6.8e+06 ++------------------*-------------------*-------------------------+
          *..*...*..*..  ..*.    *..*...*..*..*.                       ..*..*
  6.6e+06 ++           *.                            *..*...*..*..*..*.     |
  6.4e+06 ++                                                                |
          |                                                                 |
  6.2e+06 ++                                                                |
    6e+06 ++                                                                |
          |                                                                 |
  5.8e+06 ++                                                                |
  5.6e+06 O+ O   O  O  O                                                    |
          |                                                                 |
  5.4e+06 ++                                                                |
  5.2e+06 ++               O  O  O  O   O  O  O   O  O  O   O  O  O  O   O  O
          |                                                                 |
    5e+06 ++----------------------------------------------------------------+


                                  meminfo.PageTables

  2.9e+06 ++----------------------------------------------------------------+
          |              ..*..*..*..*...*..*..*...*..                       |
  2.8e+06 *+.*...*..*..*.                            *..*...*..*..*..*...*..*
          |                                                                 |
  2.7e+06 ++                                                                |
  2.6e+06 ++                                                                |
          |                                                                 |
  2.5e+06 ++                                                                |
          |                                                                 |
  2.4e+06 O+ O   O     O                                                    |
  2.3e+06 ++        O                                                       |
          |                                                                 |
  2.2e+06 ++               O  O  O  O   O  O  O   O  O  O   O  O  O  O   O  O
          |                                                                 |
  2.1e+06 ++----------------------------------------------------------------+


                          slabinfo.vm_area_struct.active_objs

  3.7e+07 ++------------------*-------------------*-------------------------+
          *..*...  .*..  ..*.    *..*...*..*..*.                            |
  3.6e+07 ++     *.    *.                            *..*...*..*..*..*...*..*
  3.5e+07 ++                                                                |
          |                                                                 |
  3.4e+07 ++                                                                |
  3.3e+07 ++                                                                |
          |                                                                 |
  3.2e+07 ++                                                                |
  3.1e+07 ++                                                                |
          O  O   O  O  O                                                    |
    3e+07 ++                                                                |
  2.9e+07 ++                                                                |
          |                   O  O  O   O     O   O  O  O   O  O  O  O   O  O
  2.8e+07 ++---------------O---------------O--------------------------------+


                           slabinfo.vm_area_struct.num_objs

  3.7e+07 ++------------------*-------------------*-------------------------+
          *..*...*..*..  ..*.    *..*...*..*..*.                       ..*..|
  3.6e+07 ++           *.                            *..*...*..*..*..*.     *
  3.5e+07 ++                                                                |
          |                                                                 |
  3.4e+07 ++                                                                |
  3.3e+07 ++                                                                |
          |                                                                 |
  3.2e+07 ++                                                                |
  3.1e+07 ++                                                                |
          O  O   O  O  O                                                    |
    3e+07 ++                                                                |
  2.9e+07 ++                                                                |
          |                   O  O  O   O  O  O   O  O  O   O  O  O  O   O  O
  2.8e+07 ++---------------O------------------------------------------------+


                        slabinfo.vm_area_struct.active_slabs

  840000 ++------------------*-------------------*--------------------------+
  820000 *+.*...*..*..  ..*.    *...*..*...*..*.    .                  ..*..*
         |            *.                             *..*..*...*..*..*.     |
  800000 ++                                                                 |
  780000 ++                                                                 |
         |                                                                  |
  760000 ++                                                                 |
  740000 ++                                                                 |
  720000 ++                                                                 |
         |                                                                  |
  700000 O+ O   O  O  O                                                     |
  680000 ++                                                                 |
         |                                                                  |
  660000 ++                     O      O      O  O   O  O  O   O  O      O  O
  640000 ++---------------O--O------O------O-------------------------O------+


                          slabinfo.vm_area_struct.num_slabs

  840000 ++------------------*-------------------*--------------------------+
  820000 *+.*...*..*..  ..*.    *...*..*...*..*.    .                  ..*..*
         |            *.                             *..*..*...*..*..*.     |
  800000 ++                                                                 |
  780000 ++                                                                 |
         |                                                                  |
  760000 ++                                                                 |
  740000 ++                                                                 |
  720000 ++                                                                 |
         |                                                                  |
  700000 O+ O   O  O  O                                                     |
  680000 ++                                                                 |
         |                                                                  |
  660000 ++                     O      O      O  O   O  O  O   O  O      O  O
  640000 ++---------------O--O------O------O-------------------------O------+


                           sched_debug.cpu#39.nr_switches

  600000 ++---------------------*-------------------------------------------+
         |                      ::                                          |
  500000 ++                    :  :                  *..                    |
         |                     :  :                 +   *..                 |
         |         *..        :    :               +       *..              |
  400000 *+.      :           :     *..           +           .  .*..      .*
         |  *..   :   *...*..:                *..*             *.    *...*. |
  300000 ++    . :           *         *... ..                              |
         |      *                          *                                |
  200000 ++                                                                 |
         |                                                                  |
         O  O         O   O  O  O   O  O   O  O  O   O  O  O   O  O  O   O  O
  100000 ++     O                                                           |
         |         O                                                        |
       0 ++-----------------------------------------------------------------+


                           sched_debug.cpu#39.sched_count

  600000 ++---------------------*-------------------------------------------+
         |                      ::                   *..                    |
  500000 ++                    :  :                 :                       |
         |                     :  :                :    *..                 |
         |         *..        :    :               :       *..              |
  400000 *+.      :           :     *..           :           .  .*..      .*
         |  *..   :   *...*..:                *..*             *.    *...*. |
  300000 ++    . :           *         *... ..                              |
         |      *                          *                                |
  200000 ++                                                                 |
         |  O                                                               |
         O            O   O  O  O   O  O   O  O  O   O  O  O   O  O  O   O  O
  100000 ++     O  O                                                        |
         |                                                                  |
       0 ++-----------------------------------------------------------------+


                           sched_debug.cpu#39.sched_goidle

  300000 ++---------------------*-------------------------------------------+
         |                      ::                                          |
  250000 ++                    :  :                  *..                    |
         |                     :  :                 +   *..                 |
         |         *..        :    :               +       *..              |
  200000 *+.      :           :     *..           +           .  .*..      .*
         |  *..   :   *...*..:                *..*             *.    *...*. |
  150000 ++    . :           *         *... ..                              |
         |      *                          *                                |
  100000 ++                                                                 |
         |                                                                  |
         O  O         O   O  O  O   O  O   O  O  O   O  O  O   O  O  O   O  O
   50000 ++     O                                                           |
         |         O                                                        |
       0 ++-----------------------------------------------------------------+


                            sched_debug.cpu#39.ttwu_count

  350000 ++-----------------------------------------------------------------+
         |                      *                                           |
  300000 ++                     ::                                          |
         |                     :  :                  *..                    |
  250000 ++                    :  :                 +                       |
         |         *..        :    :               +    *..*..              |
  200000 *+.      +           :     *..           +           .  .*..*...   |
         |  *... +    *...*..:               .*..*             *.        *..*
  150000 ++     *            *         *...*.                               |
         |                                                                  |
  100000 ++                                                                 |
         O  O         O   O  O  O   O  O      O  O      O      O  O  O   O  O
   50000 ++     O                          O         O     O                |
         |         O                                                        |
       0 ++-----------------------------------------------------------------+


                           sched_debug.cpu#53.nr_switches

  400000 ++-----------------------------------------------------------------+
         |                             *.                      *..*..*      |
  350000 ++             ..*..*        :  ..   *..   .*..*     :       +     |
         *           .*.      :       :     ..    ..     :   :         +    |
  300000 ++    .*..*.          :     :     *     *        :  :          +  .*
         | + ..                :  ..*                     : :            *. |
  250000 ++ *                   *.                         *                |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  150000 ++                     O   O                                       |
         |                O  O         O      O  O   O  O  O   O  O  O   O  O
  100000 ++ O   O  O  O                    O                                |
         O                                                                  |
   50000 ++-----------------------------------------------------------------+


                           sched_debug.cpu#53.sched_count

  400000 ++-----------------------------------------------------------------+
         |                             *.                      *..*..*      |
  350000 ++             ..*..*        +  ..   *..   .*..*     :       +     |
         *      *..  .*.      :      +      ..    ..     :   :         +    |
  300000 ++   ..   *.          :   .*      *     *        :  :          +  .*
         | + .                 : ..                       : :            *. |
  250000 ++ *                   *                          *                |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  150000 ++                     O   O                O     O      O         |
         |                O  O         O      O  O      O      O     O   O  O
  100000 ++ O   O  O  O                    O                                |
         O                                                                  |
   50000 ++-----------------------------------------------------------------+


                           sched_debug.cpu#53.sched_goidle

  200000 ++-----------------------------------------------------------------+
         |                             *.                      *..*..*.     |
  180000 ++             ..*..*        +  ..   *..   .*..*     :        ..   |
  160000 *+          .*.      :      +      ..    ..     :   :              |
         |+    .*..*.          :   .*      *     *        :  :           *..*
  140000 +++ ..                : ..                       : :               |
  120000 ++ *                   *                          *                |
         |                                                                  |
  100000 ++                                                                 |
   80000 ++                                                                 |
         |                      O   O         O                             |
   60000 ++               O  O         O   O     O   O  O  O   O  O  O   O  O
   40000 ++ O   O  O  O                                                     |
         O                                                                  |
   20000 ++-----------------------------------------------------------------+


                            sched_debug.cpu#53.ttwu_count

  200000 ++----------------------------*------------------------------------+
         |                   *         :+                      *..*..*.     |
  180000 *+                .. :       :  +    *..      .*     :        ..   |
  160000 ++           *...*   :       :   + ..   *...*.  :   :              |
         | +        ..         :     :     *              :  :           *..*
  140000 ++ *...*..*           :     :                    : :               |
         |                      *...*                      *                |
  120000 ++                                                                 |
         |                                                                  |
  100000 ++                                                                 |
   80000 ++                                                                 |
         |                                                                  |
   60000 ++ O             O  O  O   O  O   O  O  O   O  O  O   O  O  O   O  O
         |      O  O  O                                                     |
   40000 O+-----------------------------------------------------------------+


                          kmsg.hrtimer:interrupt_took#ns

    1 ++--------------------------O----------O--------------------O---------+
      |                                                                     |
      |                                                                     |
  0.8 ++                                                                    |
      |                                                                     |
      |                                                                     |
  0.6 ++                                                                    |
      |                                                                     |
  0.4 ++                                                                    |
      |                                                                     |
      |                                                                     |
  0.2 ++                                                                    |
      |                                                                     |
      |                                                                     |
    0 O+--O--O---O--O---O--O---O------O--O------O---O--O---O--O------O---O--O


                    kmsg.CE:hpet_increased_min_delta_ns_to#nsec

    1 ++------------------------------O-------------------------------------+
      |                                                                     |
      |                                                                     |
  0.8 ++                                                                    |
      |                                                                     |
      |                                                                     |
  0.6 ++                                                                    |
      |                                                                     |
  0.4 ++                                                                    |
      |                                                                     |
      |                                                                     |
  0.2 ++                                                                    |
      |                                                                     |
      |                                                                     |
    0 O+--O--O---O--O---O--O---O--O------O---O--O---O--O---O--O---O--O---O--O


                   kmsg.DHCP/BOOTP:Reply_not_for_us,op[#]xid[#]

    1 ++--------------------------*-----------------------------------------+
      |                           :                                         |
      |                           ::                                        |
  0.8 ++                         : :                                        |
      |                          : :                                        |
      |                          : :                                        |
  0.6 ++                         :  :                                       |
      |                          :  :                                       |
  0.4 ++                        :   :                                       |
      |                         :    :                                      |
      |                         :    :                                      |
  0.2 ++                        :    :                                      |
      |                        :     :                                      |
      |                        :      :                                     |
    0 O+--O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O


                     kmsg.dmar:DRHD:handling_fault_status_reg

    1 ++--------------------------------------------*-----------------------+
      |                                             :                       |
      |                                            ::                       |
  0.8 ++                                           : :                      |
      |                                            : :                      |
      |                                            : :                      |
  0.6 ++                                          :  :                      |
      |                                           :   :                     |
  0.4 ++                                          :   :                     |
      |                                          :    :                     |
      |                                          :    :                     |
  0.2 ++                                         :    :                     |
      |                                          :     :                    |
      |                                         :      :                    |
    0 O+--O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O


           kmsg.dmar:INTR-REMAP:Request_device[[f0:#f.#]fault_index_c9b0

    1 ++--------------------------------------------*-----------------------+
      |                                             :                       |
      |                                            ::                       |
  0.8 ++                                           : :                      |
      |                                            : :                      |
      |                                            : :                      |
  0.6 ++                                          :  :                      |
      |                                           :   :                     |
  0.4 ++                                          :   :                     |
      |                                          :    :                     |
      |                                          :    :                     |
  0.2 ++                                         :    :                     |
      |                                          :     :                    |
      |                                         :      :                    |
    0 O+--O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O


 kmsg.INTR-REMAP:[fault_reason#]Blocked_a_compatibility_format_interrupt_request

    1 ++--------------------------------------------*-----------------------+
      |                                             :                       |
      |                                            ::                       |
  0.8 ++                                           : :                      |
      |                                            : :                      |
      |                                            : :                      |
  0.6 ++                                          :  :                      |
      |                                           :   :                     |
  0.4 ++                                          :   :                     |
      |                                          :    :                     |
      |                                          :    :                     |
  0.2 ++                                         :    :                     |
      |                                          :     :                    |
      |                                         :      :                    |
    0 O+--O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O

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


--=-FEeEQE1InGJZTw+5o9sH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: vm-scalability
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
commit: 8191d07dbb16ae88cc2bc475584b9f185f02795f
model: Nehalem-EX
memory: 64G
nr_cpu: 64
nr_hdd_partitions: 0
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
rootfs: clearlinux-x86_64-20141119.cgz
perf-profile: 
runtime: 300s
size: 
vm-scalability:
  test:
  - small-allocs
testbox: lkp-nex06
tbox_group: lkp-nex06
kconfig: x86_64-rhel
enqueue_time: 2014-12-05 15:23:14.945092246 +08:00
head_commit: 8191d07dbb16ae88cc2bc475584b9f185f02795f
base_commit: 009d0431c3914de64666bec0d350e54fdd59df6a
branch: next/master
kernel: "/kernel/x86_64-rhel/8191d07dbb16ae88cc2bc475584b9f185f02795f/vmlinuz-3.18.0-rc7-next-20141205-g8191d07"
user: lkp
queue: cyclic
result_root: "/result/lkp-nex06/vm-scalability/performance-300s-small-allocs/clearlinux-x86_64-20141119.cgz/x86_64-rhel/8191d07dbb16ae88cc2bc475584b9f185f02795f/0"
job_file: "/lkp/scheduled/lkp-nex06/cyclic_vm-scalability-performance-300s-small-allocs-clearlinux-x86_64.cgz-x86_64-rhel-HEAD-8191d07dbb16ae88cc2bc475584b9f185f02795f-0.yaml"
dequeue_time: 2014-12-06 02:39:22.930615393 +08:00
job_state: finished
loadavg: 52.90 43.13 20.22 1/529 12451
start_time: '1417833648'
end_time: '1417834004'
version: "/lkp/lkp/.src-20141205-010122"

--=-FEeEQE1InGJZTw+5o9sH
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
mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
truncate -s 33607249920 /tmp/vm-scalability.img
mkfs.xfs -q /tmp/vm-scalability.img
mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
./case-small-allocs
./usemem --runtime 300 -n 64 --readonly --unit 40960 68719476736
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--=-FEeEQE1InGJZTw+5o9sH
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-FEeEQE1InGJZTw+5o9sH--

