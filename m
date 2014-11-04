Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKDE3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:29:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:40837 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaKDE3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:29:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,311,1413270000"; 
   d="yaml'?scan'208";a="626008634"
Date: Tue, 4 Nov 2014 12:28:21 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sched/fair] 83a0a96a5f2: -19.9% unixbench.score
Message-ID: <20141104042821.GL27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qVyHzDF4yf4A8jkR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 83a0a96a5f26d974580fd7251043ff70c8f1823d ("sched/fair: Leverage the idle state info when choosing the "idlest" cpu")


442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
       883 ±  2%     -19.9%        706 ±  0%  ivb42/unixbench/performance-execl
       883           -19.9%        706        GEO-MEAN unixbench.score

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       562 ± 15%    +572.8%       3786 ±  8%  ivb42/unixbench/performance-execl
       562          +572.8%       3786        GEO-MEAN sched_debug.cpu#28.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       127 ± 38%   +1135.4%       1576 ± 16%  ivb42/unixbench/performance-execl
       127         +1135.4%       1576        GEO-MEAN sched_debug.cfs_rq[47]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       207 ± 25%   +1868.9%       4075 ±  6%  ivb42/unixbench/performance-execl
       206         +1868.9%       4075        GEO-MEAN sched_debug.cpu#47.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       158 ± 25%   +3096.7%       5076 ± 14%  ivb42/unixbench/performance-execl
       158         +3096.7%       5076        GEO-MEAN sched_debug.cpu#47.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       349 ± 25%   +3878.9%      13886 ± 10%  ivb42/unixbench/performance-execl
       348         +3878.9%      13886        GEO-MEAN sched_debug.cpu#47.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    160.41 ± 42%    +510.9%     980.00 ± 14%  ivb42/unixbench/performance-execl
    160.41          +510.9%     980.00        GEO-MEAN sched_debug.cfs_rq[22]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     24065 ± 18%     -86.2%       3331 ± 32%  client7/autotest/performance-unixbench
     24064           -86.2%       3331        GEO-MEAN proc-vmstat.numa_hint_faults

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     18054 ± 16%     -83.7%       2939 ± 26%  client7/autotest/performance-unixbench
     18054           -83.7%       2939        GEO-MEAN proc-vmstat.numa_hint_faults_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       143 ± 36%    +824.1%       1327 ± 18%  ivb42/unixbench/performance-execl
       143          +824.1%       1326        GEO-MEAN sched_debug.cfs_rq[46]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         2 ± 39%    +961.5%         27 ± 18%  ivb42/unixbench/performance-execl
         2          +961.5%         27        GEO-MEAN sched_debug.cfs_rq[46]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       279 ± 46%    +754.8%       2384 ± 12%  ivb42/unixbench/performance-execl
       278          +754.8%       2384        GEO-MEAN sched_debug.cpu#22.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        24 ± 31%  +13712.4%       3342 ± 13%  ivb42/unixbench/performance-execl
        24        +13712.4%       3342        GEO-MEAN sched_debug.cpu#46.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     44.55 ± 20%   +2597.5%    1201.85 ± 11%  ivb42/unixbench/performance-execl
     44.55         +2597.5%    1201.85        GEO-MEAN sched_debug.cfs_rq[45]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        28 ± 33%  +11224.6%       3216 ±  8%  ivb42/unixbench/performance-execl
        28        +11224.6%       3216        GEO-MEAN sched_debug.cpu#45.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       129 ± 37%   +3211.6%       4291 ± 14%  ivb42/unixbench/performance-execl
       129         +3211.6%       4291        GEO-MEAN sched_debug.cpu#45.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       178 ±  7%    +425.4%        937 ± 18%  ivb42/unixbench/performance-execl
       178          +425.4%        937        GEO-MEAN sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       285 ± 35%   +4047.2%      11852 ± 13%  ivb42/unixbench/performance-execl
       285         +4047.2%      11852        GEO-MEAN sched_debug.cpu#45.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       148 ± 33%    +796.8%       1334 ±  9%  ivb42/unixbench/performance-execl
       148          +796.8%       1334        GEO-MEAN sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2135 ± 47%    +395.0%      10571 ± 27%  ivb42/unixbench/performance-execl
      2135          +395.0%      10571        GEO-MEAN sched_debug.cpu#23.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     44.50 ± 27%   +2702.7%    1247.30 ± 10%  ivb42/unixbench/performance-execl
     44.50         +2702.7%    1247.30        GEO-MEAN sched_debug.cfs_rq[44]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        32 ± 23%  +10782.8%       3547 ± 12%  ivb42/unixbench/performance-execl
        32        +10782.8%       3547        GEO-MEAN sched_debug.cpu#44.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        69 ± 26%   +5486.8%       3888 ± 11%  ivb42/unixbench/performance-execl
        69         +5486.8%       3888        GEO-MEAN sched_debug.cpu#44.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        49 ± 27%   +7581.0%       3809 ± 15%  ivb42/unixbench/performance-execl
        49         +7581.0%       3809        GEO-MEAN sched_debug.cpu#43.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        97 ± 15%   +4243.9%       4213 ± 14%  ivb42/unixbench/performance-execl
        97         +4243.9%       4213        GEO-MEAN sched_debug.cpu#43.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       400 ± 49%   +3373.7%      13894 ± 15%  ivb42/unixbench/performance-execl
       399         +3373.7%      13894        GEO-MEAN sched_debug.cpu#43.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       219 ± 28%    +644.9%       1637 ± 24%  ivb42/unixbench/performance-execl
       219          +644.9%       1637        GEO-MEAN sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         4 ± 41%    +775.0%         35 ± 24%  ivb42/unixbench/performance-execl
         4          +775.0%         34        GEO-MEAN sched_debug.cfs_rq[42]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       156 ± 24%   +2848.8%       4617 ± 19%  ivb42/unixbench/performance-execl
       156         +2848.8%       4617        GEO-MEAN sched_debug.cpu#42.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    144.90 ± 46%    +548.0%     938.91 ±  5%  ivb42/unixbench/performance-execl
    144.90          +548.0%     938.91        GEO-MEAN sched_debug.cfs_rq[20]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         3 ±  0%    +546.7%         19 ± 19%  ivb42/unixbench/performance-execl
         3          +546.7%         19        GEO-MEAN sched_debug.cfs_rq[22]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       537 ± 49%   +2591.8%      14471 ± 17%  ivb42/unixbench/performance-execl
       537         +2591.8%      14471        GEO-MEAN sched_debug.cpu#24.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     97.93 ± 13%   +1528.5%    1594.83 ± 45%  ivb42/unixbench/performance-execl
     97.93         +1528.5%    1594.83        GEO-MEAN sched_debug.cfs_rq[41]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        87 ± 35%   +5044.0%       4516 ± 49%  ivb42/unixbench/performance-execl
        87         +5044.0%       4516        GEO-MEAN sched_debug.cpu#41.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       259 ± 19%   +1778.2%       4872 ± 46%  ivb42/unixbench/performance-execl
       259         +1778.2%       4872        GEO-MEAN sched_debug.cpu#41.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       244 ± 20%   +2290.7%       5838 ± 36%  ivb42/unixbench/performance-execl
       244         +2290.7%       5837        GEO-MEAN sched_debug.cpu#41.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       571 ± 16%   +2745.5%      16247 ± 40%  ivb42/unixbench/performance-execl
       571         +2745.5%      16247        GEO-MEAN sched_debug.cpu#41.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       142 ± 19%    +857.4%       1365 ± 13%  ivb42/unixbench/performance-execl
       142          +857.4%       1365        GEO-MEAN sched_debug.cfs_rq[40]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       144 ±  8%   +2504.3%       3760 ± 15%  ivb42/unixbench/performance-execl
       144         +2504.3%       3760        GEO-MEAN sched_debug.cpu#40.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       516 ± 11%    +698.5%       4125 ± 12%  ivb42/unixbench/performance-execl
       516          +698.5%       4125        GEO-MEAN sched_debug.cpu#40.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       227 ± 16%    +887.1%       2243 ± 46%  ivb42/unixbench/performance-execl
       227          +887.1%       2243        GEO-MEAN sched_debug.cfs_rq[39]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       265 ±  4%   +1393.0%       3959 ±  9%  ivb42/unixbench/performance-execl
       265         +1393.0%       3959        GEO-MEAN sched_debug.cpu#39.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       154 ± 39%    +689.8%       1222 ±  7%  ivb42/unixbench/performance-execl
       154          +689.8%       1222        GEO-MEAN sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       539 ±  6%    +853.6%       5145 ± 15%  ivb42/unixbench/performance-execl
       539          +853.6%       5145        GEO-MEAN sched_debug.cpu#39.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1348 ±  5%    +989.0%      14689 ±  8%  ivb42/unixbench/performance-execl
      1348          +989.0%      14688        GEO-MEAN sched_debug.cpu#39.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     21692 ±  5%     -93.0%       1514 ± 27%  ivb42/unixbench/performance-execl
     21692           -93.0%       1514        GEO-MEAN sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       475 ±  5%     -93.3%         31 ± 28%  ivb42/unixbench/performance-execl
       475           -93.3%         31        GEO-MEAN sched_debug.cfs_rq[37]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2944 ± 26%     -90.2%        288 ± 45%  ivb42/unixbench/performance-execl
      2943           -90.2%        288        GEO-MEAN sched_debug.cfs_rq[37]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2841 ± 29%     -90.1%        281 ± 42%  ivb42/unixbench/performance-execl
      2841           -90.1%        281        GEO-MEAN sched_debug.cfs_rq[37]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     48940 ±  5%     -90.0%       4906 ± 21%  ivb42/unixbench/performance-execl
     48940           -90.0%       4906        GEO-MEAN sched_debug.cfs_rq[37]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     20714 ±  5%     -93.0%       1442 ±  9%  ivb42/unixbench/performance-execl
     20714           -93.0%       1442        GEO-MEAN sched_debug.cfs_rq[37]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     77987 ±  5%     -94.6%       4187 ± 11%  ivb42/unixbench/performance-execl
     77987           -94.6%       4187        GEO-MEAN sched_debug.cpu#37.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     82036 ±  4%     -94.5%       4471 ± 12%  ivb42/unixbench/performance-execl
     82036           -94.5%       4471        GEO-MEAN sched_debug.cpu#37.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     79721 ±  4%     -92.9%       5679 ±  9%  ivb42/unixbench/performance-execl
     79721           -92.9%       5678        GEO-MEAN sched_debug.cpu#37.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    239352 ±  5%     -91.0%      21655 ± 43%  ivb42/unixbench/performance-execl
    239352           -91.0%      21655        GEO-MEAN sched_debug.cpu#37.sched_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       561 ±  5%     -89.3%         60 ±  7%  client7/autotest/performance-unixbench
       561           -89.3%         60        GEO-MEAN sched_debug.cpu#10.nr_uninterruptible

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       141 ± 17%    +958.6%       1502 ± 24%  ivb42/unixbench/performance-execl
       141          +958.6%       1502        GEO-MEAN sched_debug.cfs_rq[24]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4853 ± 45%    +265.4%      17735 ± 13%  ivb42/unixbench/performance-execl
      4853          +265.4%      17735        GEO-MEAN sched_debug.cpu#18.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    237543 ±  4%     -93.4%      15601 ±  9%  ivb42/unixbench/performance-execl
    237543           -93.4%      15601        GEO-MEAN sched_debug.cpu#37.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       103 ± 31%   +1259.8%       1408 ± 15%  ivb42/unixbench/performance-execl
       103         +1259.8%       1408        GEO-MEAN sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         1 ± 30%   +1750.0%         29 ± 16%  ivb42/unixbench/performance-execl
         1         +1750.0%         29        GEO-MEAN sched_debug.cfs_rq[36]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       580 ±  4%     -87.4%         73 ± 18%  client7/autotest/performance-unixbench
       580           -87.4%         72        GEO-MEAN sched_debug.cpu#11.nr_uninterruptible

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     60.43 ± 34%   +2204.0%    1392.25 ± 14%  ivb42/unixbench/performance-execl
     60.43         +2204.0%    1392.25        GEO-MEAN sched_debug.cfs_rq[36]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    237456 ±  5%     -94.8%      12333 ±  8%  ivb42/unixbench/performance-execl
    237456           -94.8%      12333        GEO-MEAN sched_debug.cpu#25.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       125 ± 30%   +1132.0%       1549 ± 26%  ivb42/unixbench/performance-execl
       125         +1132.0%       1549        GEO-MEAN sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        76 ± 10%     -94.0%          4 ± 29%  ivb42/unixbench/performance-execl
        76           -94.0%          4        GEO-MEAN sched_debug.cpu#25.nr_uninterruptible

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         1 ± 41%   +1722.2%         32 ± 27%  ivb42/unixbench/performance-execl
         1         +1722.2%         32        GEO-MEAN sched_debug.cfs_rq[35]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       212 ± 10%     -89.2%         23 ± 45%  ivb42/unixbench/performance-execl
       212           -89.2%         23        GEO-MEAN sched_debug.cpu#25.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     52.35 ± 28%   +2147.9%    1176.67 ±  8%  ivb42/unixbench/performance-execl
     52.35         +2147.9%    1176.67        GEO-MEAN sched_debug.cfs_rq[35]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        32 ± 21%  +10078.9%       3277 ± 10%  ivb42/unixbench/performance-execl
        32        +10078.9%       3277        GEO-MEAN sched_debug.cpu#35.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       189 ± 47%   +2179.0%       4321 ±  4%  ivb42/unixbench/performance-execl
       189         +2179.0%       4320        GEO-MEAN sched_debug.cpu#35.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       221 ± 10%     -92.7%         16 ± 37%  ivb42/unixbench/performance-execl
       221           -92.7%         16        GEO-MEAN sched_debug.cpu#25.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       415 ± 43%   +2780.7%      11960 ±  5%  ivb42/unixbench/performance-execl
       415         +2780.7%      11960        GEO-MEAN sched_debug.cpu#35.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       152 ± 31%    +955.5%       1612 ± 27%  ivb42/unixbench/performance-execl
       152          +955.5%       1612        GEO-MEAN sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         2 ± 42%   +1325.0%         34 ± 28%  ivb42/unixbench/performance-execl
         2         +1325.0%         34        GEO-MEAN sched_debug.cfs_rq[34]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    118.51 ± 38%    +908.5%    1195.16 ± 15%  ivb42/unixbench/performance-execl
    118.51          +908.5%    1195.16        GEO-MEAN sched_debug.cfs_rq[34]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        33 ± 17%   +9688.1%       3288 ± 18%  ivb42/unixbench/performance-execl
        33         +9688.1%       3288        GEO-MEAN sched_debug.cpu#34.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       104 ± 25%   +3279.5%       3521 ± 18%  ivb42/unixbench/performance-execl
       104         +3279.5%       3521        GEO-MEAN sched_debug.cpu#34.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     96.86 ± 33%   +1158.7%    1219.23 ± 14%  ivb42/unixbench/performance-execl
     96.86         +1158.7%    1219.23        GEO-MEAN sched_debug.cfs_rq[33]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        39 ± 41%   +8688.2%       3427 ± 19%  ivb42/unixbench/performance-execl
        38         +8688.2%       3427        GEO-MEAN sched_debug.cpu#33.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       102 ± 16%   +3940.5%       4153 ± 27%  ivb42/unixbench/performance-execl
       102         +3940.5%       4153        GEO-MEAN sched_debug.cpu#33.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    110098 ± 46%     -99.6%        387 ± 40%  ivb42/unixbench/performance-execl
    110098           -99.6%        387        GEO-MEAN cpuidle.C1E-IVT.usage

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     83.33 ± 25%   +1320.9%    1184.02 ± 10%  ivb42/unixbench/performance-execl
     83.33         +1320.9%    1184.02        GEO-MEAN sched_debug.cfs_rq[32]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        37 ± 33%   +8704.3%       3257 ± 10%  ivb42/unixbench/performance-execl
        36         +8704.3%       3257        GEO-MEAN sched_debug.cpu#32.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       128 ± 34%    +984.6%       1390 ±  9%  ivb42/unixbench/performance-execl
       128          +984.6%       1390        GEO-MEAN sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    238673 ±  4%     -94.4%      13266 ± 12%  ivb42/unixbench/performance-execl
    238673           -94.4%      13266        GEO-MEAN sched_debug.cpu#25.sched_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     79668 ±  5%     -94.5%       4396 ±  9%  ivb42/unixbench/performance-execl
     79668           -94.5%       4396        GEO-MEAN sched_debug.cpu#25.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        32 ± 19%  +12456.2%       4068 ± 10%  ivb42/unixbench/performance-execl
        32        +12456.2%       4068        GEO-MEAN sched_debug.cpu#31.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     82071 ±  5%     -95.3%       3841 ±  7%  ivb42/unixbench/performance-execl
     82071           -95.3%       3841        GEO-MEAN sched_debug.cpu#25.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        58 ± 22%   +5710.2%       3404 ±  8%  ivb42/unixbench/performance-execl
        58         +5710.2%       3404        GEO-MEAN sched_debug.cpu#30.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         0 ±  0%      +Inf%          9 ± 14%  ivb42/unixbench/performance-execl
         0            +Inf%          9        GEO-MEAN sched_debug.cpu#30.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         0 ±  0%      +Inf%         10 ± 14%  ivb42/unixbench/performance-execl
         0            +Inf%         10        GEO-MEAN sched_debug.cpu#30.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     77932 ±  5%     -95.5%       3486 ±  9%  ivb42/unixbench/performance-execl
     77931           -95.5%       3486        GEO-MEAN sched_debug.cpu#25.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     21145 ±  5%     -93.8%       1317 ±  9%  ivb42/unixbench/performance-execl
     21145           -93.8%       1317        GEO-MEAN sched_debug.cfs_rq[25]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     49475 ±  5%     -90.7%       4602 ± 19%  ivb42/unixbench/performance-execl
     49475           -90.7%       4602        GEO-MEAN sched_debug.cfs_rq[25]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    111.21 ± 15%   +1157.8%    1398.82 ± 28%  ivb42/unixbench/performance-execl
    111.21         +1157.8%    1398.82        GEO-MEAN sched_debug.cfs_rq[29]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        50 ± 17%   +7189.8%       3703 ± 29%  ivb42/unixbench/performance-execl
        50         +7189.8%       3703        GEO-MEAN sched_debug.cpu#29.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       169 ± 24%   +2312.8%       4082 ± 27%  ivb42/unixbench/performance-execl
       169         +2312.8%       4082        GEO-MEAN sched_debug.cpu#29.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       227 ± 26%   +1980.9%       4740 ± 24%  ivb42/unixbench/performance-execl
       227         +1980.9%       4740        GEO-MEAN sched_debug.cpu#29.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       523 ± 25%   +2425.4%      13227 ± 25%  ivb42/unixbench/performance-execl
       523         +2425.4%      13227        GEO-MEAN sched_debug.cpu#29.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       139 ± 20%    +855.5%       1336 ±  9%  ivb42/unixbench/performance-execl
       139          +855.5%       1336        GEO-MEAN sched_debug.cfs_rq[28]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       124 ± 10%   +2742.0%       3535 ±  8%  ivb42/unixbench/performance-execl
       124         +2742.0%       3535        GEO-MEAN sched_debug.cpu#28.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       317 ± 19%   +1298.1%       4443 ± 15%  ivb42/unixbench/performance-execl
       317         +1298.1%       4443        GEO-MEAN sched_debug.cpu#28.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       779 ± 17%   +1500.4%      12477 ± 12%  ivb42/unixbench/performance-execl
       779         +1500.4%      12477        GEO-MEAN sched_debug.cpu#28.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         0 ±  0%      +Inf%         15 ± 40%  ivb42/unixbench/performance-execl
         0            +Inf%         15        GEO-MEAN sched_debug.cpu#6.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         0 ±  0%      +Inf%         10 ± 39%  ivb42/unixbench/performance-execl
         0            +Inf%         10        GEO-MEAN sched_debug.cpu#6.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       225 ± 16%    +609.3%       1602 ± 25%  ivb42/unixbench/performance-execl
       225          +609.3%       1602        GEO-MEAN sched_debug.cfs_rq[27]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       222 ±  5%   +1799.9%       4221 ± 26%  ivb42/unixbench/performance-execl
       222         +1799.9%       4221        GEO-MEAN sched_debug.cpu#27.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       760 ± 13%    +495.6%       4527 ± 26%  ivb42/unixbench/performance-execl
       760          +495.6%       4527        GEO-MEAN sched_debug.cpu#27.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1597 ± 46%    +831.1%      14871 ± 24%  ivb42/unixbench/performance-execl
      1597          +831.1%      14871        GEO-MEAN sched_debug.cpu#27.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         0 ±  0%      +Inf%          7 ± 38%  ivb42/unixbench/performance-execl
         0            +Inf%          7        GEO-MEAN sched_debug.cpu#8.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         0 ±  0%      +Inf%          5 ± 21%  ivb42/unixbench/performance-execl
         0            +Inf%          5        GEO-MEAN sched_debug.cpu#8.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       624 ± 27%    +519.1%       3868 ± 18%  ivb42/unixbench/performance-execl
       624          +519.1%       3868        GEO-MEAN sched_debug.cpu#26.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       959 ± 18%    +410.1%       4895 ± 21%  ivb42/unixbench/performance-execl
       959          +410.1%       4895        GEO-MEAN sched_debug.cpu#26.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2541 ± 18%    +440.2%      13729 ± 20%  ivb42/unixbench/performance-execl
      2541          +440.2%      13729        GEO-MEAN sched_debug.cpu#26.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     22090 ±  4%     -92.4%       1687 ± 10%  ivb42/unixbench/performance-execl
     22090           -92.4%       1687        GEO-MEAN sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       484 ±  4%     -92.6%         36 ± 10%  ivb42/unixbench/performance-execl
       484           -92.6%         36        GEO-MEAN sched_debug.cfs_rq[25]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3626 ± 11%     -86.2%        500 ± 41%  ivb42/unixbench/performance-execl
      3626           -86.2%        500        GEO-MEAN sched_debug.cfs_rq[25]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3478 ± 10%     -86.9%        455 ± 43%  ivb42/unixbench/performance-execl
      3478           -86.9%        455        GEO-MEAN sched_debug.cfs_rq[25]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        38 ± 35%  +10817.3%       4170 ± 23%  ivb42/unixbench/performance-execl
        38        +10817.3%       4170        GEO-MEAN sched_debug.cpu#24.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       946 ± 20%    +379.4%       4535 ± 10%  ivb42/unixbench/performance-execl
       945          +379.4%       4534        GEO-MEAN sched_debug.cpu#39.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2091 ± 44%    +347.1%       9348 ± 34%  ivb42/unixbench/performance-execl
      2091          +347.1%       9348        GEO-MEAN sched_debug.cpu#18.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        88 ± 41%    +339.4%        388 ± 36%  ivb42/unixbench/performance-execl
        88          +339.4%        388        GEO-MEAN sched_debug.cfs_rq[44]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        88 ± 41%    +341.2%        390 ± 36%  ivb42/unixbench/performance-execl
        88          +341.2%        390        GEO-MEAN sched_debug.cfs_rq[44]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1324 ± 34%    +513.2%       8120 ± 44%  ivb42/unixbench/performance-execl
      1324          +513.2%       8120        GEO-MEAN sched_debug.cpu#10.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1971 ± 42%    +321.7%       8312 ± 29%  ivb42/unixbench/performance-execl
      1971          +321.7%       8312        GEO-MEAN sched_debug.cpu#1.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     46599 ±  4%     -79.1%       9725 ±  5%  ivb42/unixbench/performance-execl
     46598           -79.1%       9725        GEO-MEAN sched_debug.cpu#25.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       191 ± 27%    +485.9%       1123 ± 44%  ivb42/unixbench/performance-execl
       191          +485.9%       1123        GEO-MEAN sched_debug.cfs_rq[18]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2403 ± 45%    +230.2%       7935 ± 14%  ivb42/unixbench/performance-execl
      2402          +230.2%       7935        GEO-MEAN sched_debug.cpu#18.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1119 ± 35%    +316.7%       4666 ± 16%  ivb42/unixbench/performance-execl
      1119          +316.7%       4666        GEO-MEAN sched_debug.cfs_rq[36]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         2 ± 42%    +408.3%         12 ± 47%  ivb42/unixbench/performance-execl
         2          +408.3%         12        GEO-MEAN sched_debug.cpu#34.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1558 ± 48%    +437.8%       8380 ± 16%  ivb42/unixbench/performance-execl
      1558          +437.8%       8380        GEO-MEAN sched_debug.cpu#9.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       230 ± 11%    +364.3%       1069 ± 30%  ivb42/unixbench/performance-execl
       230          +364.3%       1069        GEO-MEAN sched_debug.cfs_rq[5]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1008 ± 21%    +320.3%       4237 ± 16%  ivb42/unixbench/performance-execl
      1008          +320.3%       4237        GEO-MEAN sched_debug.cpu#26.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         6 ± 32%    +406.2%         32 ± 34%  ivb42/unixbench/performance-execl
         6          +406.2%         32        GEO-MEAN sched_debug.cfs_rq[29]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3825 ± 49%    +306.0%      15529 ±  4%  ivb42/unixbench/performance-execl
      3825          +306.0%      15529        GEO-MEAN sched_debug.cpu#11.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         5 ± 35%    +480.8%         30 ± 27%  ivb42/unixbench/performance-execl
         5          +480.8%         30        GEO-MEAN sched_debug.cfs_rq[30]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1899 ± 49%    +265.8%       6949 ±  5%  ivb42/unixbench/performance-execl
      1899          +265.8%       6949        GEO-MEAN sched_debug.cpu#11.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     46217 ±  4%     -76.5%      10842 ±  4%  ivb42/unixbench/performance-execl
     46217           -76.5%      10842        GEO-MEAN sched_debug.cpu#37.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         1 ± 50%    +162.5%          4 ± 40%  client7/autotest/performance-unixbench
         1          +162.5%          4        GEO-MEAN sched_debug.cfs_rq[13]:/.nr_spread_over

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         1 ±  0%    +280.0%          3 ± 42%  client7/autotest/performance-unixbench
         1          +280.0%          3        GEO-MEAN sched_debug.cfs_rq[2]:/.nr_spread_over

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       247 ± 39%    +334.2%       1076 ± 16%  ivb42/unixbench/performance-execl
       247          +334.2%       1076        GEO-MEAN sched_debug.cfs_rq[23]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1379 ± 24%    +261.0%       4981 ± 23%  ivb42/unixbench/performance-execl
      1379          +261.0%       4981        GEO-MEAN sched_debug.cfs_rq[46]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       136 ± 33%    +272.5%        508 ± 39%  ivb42/unixbench/performance-execl
       136          +272.5%        508        GEO-MEAN sched_debug.cfs_rq[42]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    238919 ±  0%     -65.3%      82939 ±  1%  client7/autotest/performance-unixbench
    238919           -65.3%      82939        GEO-MEAN sched_debug.cpu#11.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     11568 ±  1%     -64.5%       4102 ±  4%  client7/autotest/performance-unixbench
     11568           -64.5%       4102        GEO-MEAN sched_debug.cfs_rq[11]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    239165 ±  0%     -65.9%      81671 ±  6%  client7/autotest/performance-unixbench
    239164           -65.9%      81671        GEO-MEAN sched_debug.cpu#10.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       216 ± 22%    +319.1%        908 ±  6%  ivb42/unixbench/performance-execl
       216          +319.1%        908        GEO-MEAN sched_debug.cfs_rq[16]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     11671 ±  1%     -64.3%       4161 ±  4%  client7/autotest/performance-unixbench
     11671           -64.3%       4161        GEO-MEAN sched_debug.cfs_rq[11]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       267 ± 33%    +431.9%       1424 ± 26%  ivb42/unixbench/performance-execl
       267          +431.9%       1424        GEO-MEAN sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       328 ± 29%    +367.4%       1536 ± 34%  ivb42/unixbench/performance-execl
       328          +367.4%       1536        GEO-MEAN sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     11566 ±  0%     -61.7%       4426 ±  5%  client7/autotest/performance-unixbench
     11566           -61.7%       4426        GEO-MEAN sched_debug.cfs_rq[10]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     11667 ±  0%     -61.6%       4479 ±  5%  client7/autotest/performance-unixbench
     11667           -61.6%       4479        GEO-MEAN sched_debug.cfs_rq[10]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       780 ± 34%    +249.5%       2726 ± 12%  ivb42/unixbench/performance-execl
       780          +249.5%       2725        GEO-MEAN sched_debug.cpu#16.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    228614 ± 10%     -59.6%      92280 ±  9%  client7/autotest/performance-unixbench
    228614           -59.6%      92280        GEO-MEAN sched_debug.cfs_rq[11]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     12739 ± 16%     -73.8%       3334 ± 16%  client7/autotest/performance-unixbench
     12739           -73.8%       3334        GEO-MEAN proc-vmstat.numa_pte_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        14 ± 20%    +112.2%         31 ± 21%  client7/autotest/performance-unixbench
        14          +112.2%         31        GEO-MEAN sched_debug.cpu#0.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1327 ± 17%    +275.9%       4990 ± 17%  ivb42/unixbench/performance-execl
      1327          +275.9%       4990        GEO-MEAN sched_debug.cpu#38.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       273 ± 14%    +282.8%       1048 ± 22%  ivb42/unixbench/performance-execl
       273          +282.8%       1048        GEO-MEAN sched_debug.cfs_rq[1]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       230 ±  5%     -54.3%        105 ± 10%  client7/autotest/performance-unixbench
       230           -54.3%        105        GEO-MEAN sched_debug.cfs_rq[11]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     10582 ±  5%     -54.0%       4868 ± 10%  client7/autotest/performance-unixbench
     10582           -54.0%       4868        GEO-MEAN sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1980 ±  8%    +102.2%       4005 ±  7%  client7/autotest/performance-unixbench
      1980          +102.2%       4005        GEO-MEAN sched_debug.cfs_rq[1]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2015 ±  8%    +101.6%       4062 ±  7%  client7/autotest/performance-unixbench
      2014          +101.6%       4062        GEO-MEAN sched_debug.cfs_rq[1]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      6081 ± 28%    +200.7%      18288 ±  8%  ivb42/unixbench/performance-execl
      6081          +200.7%      18287        GEO-MEAN sched_debug.cpu#1.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    178606 ± 27%     -74.1%      46308 ± 46%  client7/autotest/performance-unixbench
    178606           -74.1%      46308        GEO-MEAN sched_debug.cfs_rq[4]:/.spread0

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         8 ± 48%    +176.2%         23 ± 20%  client7/autotest/performance-unixbench
         8          +176.2%         23        GEO-MEAN sched_debug.cpu#7.cpu_load[1]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1857 ±  4%     +91.5%       3556 ±  6%  client7/autotest/performance-unixbench
      1857           +91.5%       3556        GEO-MEAN sched_debug.cfs_rq[3]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1831 ±  4%     +91.0%       3497 ±  6%  client7/autotest/performance-unixbench
      1830           +91.0%       3497        GEO-MEAN sched_debug.cfs_rq[3]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1863 ±  7%     +80.2%       3359 ±  3%  client7/autotest/performance-unixbench
      1863           +80.2%       3359        GEO-MEAN sched_debug.cfs_rq[6]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1884 ±  6%     +80.7%       3406 ±  3%  client7/autotest/performance-unixbench
      1884           +80.7%       3406        GEO-MEAN sched_debug.cfs_rq[7]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     48892 ±  8%     +78.2%      87107 ±  3%  client7/autotest/performance-unixbench
     48892           +78.2%      87107        GEO-MEAN sched_debug.cpu#6.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1834 ±  7%     +80.3%       3307 ±  3%  client7/autotest/performance-unixbench
      1834           +80.3%       3307        GEO-MEAN sched_debug.cfs_rq[6]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1865 ±  6%     +79.7%       3352 ±  3%  client7/autotest/performance-unixbench
      1865           +79.7%       3352        GEO-MEAN sched_debug.cfs_rq[7]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2014 ±  3%     +77.5%       3575 ±  8%  client7/autotest/performance-unixbench
      2014           +77.5%       3575        GEO-MEAN sched_debug.cfs_rq[5]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1985 ±  4%     +77.5%       3523 ±  8%  client7/autotest/performance-unixbench
      1985           +77.5%       3523        GEO-MEAN sched_debug.cfs_rq[5]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       229 ±  1%     -42.8%        131 ± 10%  client7/autotest/performance-unixbench
       229           -42.8%        131        GEO-MEAN sched_debug.cfs_rq[10]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     10535 ±  1%     -42.4%       6068 ± 10%  client7/autotest/performance-unixbench
     10535           -42.4%       6068        GEO-MEAN sched_debug.cfs_rq[10]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        25 ± 15%     +62.7%         41 ± 17%  client7/autotest/performance-unixbench
        25           +62.7%         41        GEO-MEAN sched_debug.cpu#1.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     54292 ± 16%     +61.8%      87856 ±  5%  client7/autotest/performance-unixbench
     54291           +61.8%      87856        GEO-MEAN sched_debug.cpu#7.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2985 ± 29%    +176.8%       8262 ±  9%  ivb42/unixbench/performance-execl
      2985          +176.8%       8262        GEO-MEAN sched_debug.cpu#1.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2734 ± 18%    +201.9%       8257 ±  9%  ivb42/unixbench/performance-execl
      2734          +201.9%       8257        GEO-MEAN sched_debug.cpu#0.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1884 ±  4%     +66.9%       3146 ± 16%  client7/autotest/performance-unixbench
      1884           +66.9%       3146        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1862 ±  4%     +66.7%       3104 ± 16%  client7/autotest/performance-unixbench
      1862           +66.7%       3104        GEO-MEAN sched_debug.cfs_rq[0]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2016 ±  4%     +56.1%       3147 ±  9%  client7/autotest/performance-unixbench
      2016           +56.1%       3147        GEO-MEAN sched_debug.cfs_rq[4]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2047 ±  3%     +56.1%       3196 ±  9%  client7/autotest/performance-unixbench
      2046           +56.1%       3196        GEO-MEAN sched_debug.cfs_rq[4]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    224.65 ± 47%    +269.2%     829.38 ±  8%  ivb42/unixbench/performance-execl
    224.65          +269.2%     829.38        GEO-MEAN sched_debug.cfs_rq[21]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        57 ± 10%     -62.5%         21 ± 28%  client7/autotest/performance-unixbench
        57           -62.5%         21        GEO-MEAN sched_debug.cpu#11.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    107353 ±  1%     -25.9%      79520 ±  7%  client7/autotest/performance-unixbench
        95 ± 38%   +3152.0%       3089 ± 34%  ivb42/unixbench/performance-execl
      3193          +390.8%      15673        GEO-MEAN sched_debug.cpu#13.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    106243 ±  0%     -20.5%      84484 ±  1%  client7/autotest/performance-unixbench
    106243           -20.5%      84484        GEO-MEAN sched_debug.cpu#12.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1980 ±  4%     +84.2%       3648 ± 10%  client7/autotest/performance-unixbench
      1980           +84.2%       3648        GEO-MEAN sched_debug.cfs_rq[2]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1946 ±  4%     +84.3%       3587 ± 10%  client7/autotest/performance-unixbench
      1946           +84.3%       3587        GEO-MEAN sched_debug.cfs_rq[2]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1234 ± 42%    +257.7%       4416 ± 36%  ivb42/unixbench/performance-execl
      1234          +257.7%       4416        GEO-MEAN sched_debug.cfs_rq[21]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     71775 ±  0%     +11.9%      80325 ±  1%  client7/autotest/performance-unixbench
     71774           +11.9%      80325        GEO-MEAN sched_debug.cpu#8.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       419 ± 14%    +248.4%       1462 ± 20%  ivb42/unixbench/performance-execl
       419          +248.4%       1462        GEO-MEAN sched_debug.cfs_rq[26]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5109 ± 36%    +266.4%      18721 ± 15%  ivb42/unixbench/performance-execl
      5109          +266.4%      18721        GEO-MEAN sched_debug.cpu#19.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4630 ± 32%    +194.7%      13648 ± 15%  ivb42/unixbench/performance-execl
      4630          +194.7%      13647        GEO-MEAN sched_debug.cpu#38.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4886 ± 44%    +225.4%      15901 ± 10%  ivb42/unixbench/performance-execl
      4886          +225.4%      15901        GEO-MEAN sched_debug.cpu#10.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  54269.57 ± 33%     +84.8%  100296.87 ± 20%  client7/autotest/performance-unixbench
    267.61 ± 43%    +334.0%    1161.48 ±  8%  ivb42/unixbench/performance-execl
   3810.89          +183.2%   10793.19        GEO-MEAN sched_debug.cfs_rq[7]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         1 ±  0%    +280.0%          3 ± 30%  client7/autotest/performance-unixbench
         1          +280.0%          3        GEO-MEAN sched_debug.cfs_rq[6]:/.nr_spread_over

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    822656 ±  3%     -10.1%     739652 ±  3%  client7/autotest/performance-unixbench
      1192 ± 22%    +372.1%       5630 ± 37%  ivb42/unixbench/performance-execl
     31323          +106.0%      64535        GEO-MEAN sched_debug.cfs_rq[13]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1763 ± 37%    +135.3%       4148 ± 13%  ivb42/unixbench/performance-execl
      1763          +135.3%       4148        GEO-MEAN sched_debug.cfs_rq[44]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3334 ± 27%    +165.8%       8862 ± 18%  ivb42/unixbench/performance-execl
      3333          +165.8%       8862        GEO-MEAN sched_debug.cpu#16.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         9 ± 46%    +171.1%         24 ± 15%  client7/autotest/performance-unixbench
         9          +171.1%         24        GEO-MEAN sched_debug.cpu#7.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5423 ± 43%    +268.6%      19991 ± 30%  ivb42/unixbench/performance-execl
      5423          +268.6%      19991        GEO-MEAN sched_debug.cpu#17.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       958 ± 28%     -62.8%        356 ± 36%  ivb42/unixbench/performance-execl
       958           -62.8%        356        GEO-MEAN sched_debug.cfs_rq[26]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2537 ± 36%    +229.8%       8369 ± 15%  ivb42/unixbench/performance-execl
      2537          +229.8%       8368        GEO-MEAN sched_debug.cpu#19.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     59716 ±  9%     +26.5%      75569 ±  3%  client7/autotest/performance-unixbench
     59716           +26.5%      75569        GEO-MEAN sched_debug.cfs_rq[8]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        56 ± 13%     +80.9%        102 ± 15%  client7/autotest/performance-unixbench
        56           +80.9%        101        GEO-MEAN sched_debug.cfs_rq[7]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1461 ± 13%    +215.2%       4607 ± 17%  ivb42/unixbench/performance-execl
      1461          +215.2%       4607        GEO-MEAN sched_debug.cfs_rq[45]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2429 ± 45%    +189.9%       7042 ±  9%  ivb42/unixbench/performance-execl
      2429          +189.9%       7042        GEO-MEAN sched_debug.cpu#10.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    104379 ± 15%     +21.2%     126507 ± 14%  client7/autotest/performance-unixbench
       225 ± 14%    +302.6%        906 ± 12%  ivb42/unixbench/performance-execl
      4846          +120.9%      10707        GEO-MEAN sched_debug.cfs_rq[6]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       392 ± 10%    +211.8%       1225 ± 33%  ivb42/unixbench/performance-execl
       392          +211.8%       1225        GEO-MEAN sched_debug.cfs_rq[3]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       934 ± 29%     -62.9%        347 ± 33%  ivb42/unixbench/performance-execl
       934           -62.9%        347        GEO-MEAN sched_debug.cfs_rq[26]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2241 ± 32%    +105.1%       4596 ± 26%  ivb42/unixbench/performance-execl
      2241          +105.1%       4596        GEO-MEAN sched_debug.cfs_rq[42]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
 1.391e+08 ±  5%    +169.4%  3.746e+08 ± 10%  client7/autotest/performance-unixbench
 1.391e+08          +169.4%  3.746e+08        GEO-MEAN cpuidle.C1E-NHM.time

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       101 ±  5%     -62.3%         38 ±  4%  client7/autotest/performance-unixbench
       101           -62.3%         38        GEO-MEAN sched_debug.cpu#10.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5674 ± 25%    +197.9%      16903 ± 22%  ivb42/unixbench/performance-execl
      5673          +197.9%      16903        GEO-MEAN sched_debug.cpu#5.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2695 ± 43%    +222.1%       8680 ± 24%  ivb42/unixbench/performance-execl
      2694          +222.1%       8680        GEO-MEAN sched_debug.cpu#17.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     11309 ± 47%    +114.3%      24239 ± 19%  ivb42/unixbench/performance-execl
     11309          +114.3%      24239        GEO-MEAN sched_debug.cpu#16.sched_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        17 ± 33%    +122.5%         39 ± 20%  client7/autotest/performance-unixbench
        17          +122.5%         39        GEO-MEAN sched_debug.cfs_rq[13]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       104 ±  1%     -62.5%         39 ± 10%  client7/autotest/performance-unixbench
       103           -62.5%         38        GEO-MEAN sched_debug.cpu#11.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       307 ± 25%    +204.8%        938 ± 16%  ivb42/unixbench/performance-execl
       307          +204.8%        938        GEO-MEAN sched_debug.cfs_rq[4]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     49504 ±  9%     +99.6%      98817 ±  4%  client7/autotest/performance-unixbench
       675 ± 38%    +298.7%       2692 ± 21%  ivb42/unixbench/performance-execl
      5781          +182.1%      16310        GEO-MEAN sched_debug.cpu#1.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3018 ± 33%    +141.0%       7273 ± 30%  ivb42/unixbench/performance-execl
      3018          +141.0%       7273        GEO-MEAN sched_debug.cpu#5.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      6012 ± 28%    +195.9%      17793 ± 13%  ivb42/unixbench/performance-execl
      6012          +195.9%      17793        GEO-MEAN sched_debug.cpu#16.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2626 ± 13%     +79.7%       4719 ± 15%  client7/autotest/performance-unixbench
      2626           +79.7%       4719        GEO-MEAN sched_debug.cfs_rq[7]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       102 ±  2%     -62.0%         39 ± 11%  client7/autotest/performance-unixbench
       102           -62.0%         38        GEO-MEAN sched_debug.cfs_rq[11]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1436 ± 46%    +151.1%       3606 ± 11%  ivb42/unixbench/performance-execl
      1435          +151.1%       3605        GEO-MEAN sched_debug.cpu#38.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       104 ±  6%     -63.7%         38 ±  8%  client7/autotest/performance-unixbench
       104           -63.7%         37        GEO-MEAN sched_debug.cfs_rq[10]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        18 ± 43%     +70.0%         30 ±  7%  ivb42/unixbench/performance-execl
        17           +70.0%         30        GEO-MEAN sched_debug.cfs_rq[27]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       867 ± 43%     +68.2%       1459 ±  7%  ivb42/unixbench/performance-execl
       867           +68.2%       1459        GEO-MEAN sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    450012 ± 20%     +64.2%     738924 ±  9%  client7/autotest/performance-unixbench
    450012           +64.2%     738924        GEO-MEAN sched_debug.cfs_rq[7]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        19 ± 24%    +102.0%         39 ± 20%  client7/autotest/performance-unixbench
        19          +102.0%         39        GEO-MEAN sched_debug.cpu#13.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3640 ± 12%    +205.4%      11117 ± 28%  ivb42/unixbench/performance-execl
      3640          +205.4%      11117        GEO-MEAN sched_debug.cpu#15.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        59 ±  9%     -59.5%         24 ± 23%  client7/autotest/performance-unixbench
        59           -59.5%         24        GEO-MEAN sched_debug.cpu#11.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7898 ± 11%    +128.2%      18021 ± 17%  ivb42/unixbench/performance-execl
      7898          +128.2%      18021        GEO-MEAN sched_debug.cpu#15.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1997 ± 24%    +111.1%       4217 ±  9%  ivb42/unixbench/performance-execl
      1997          +111.1%       4217        GEO-MEAN sched_debug.cfs_rq[32]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       110 ± 42%    +174.4%        302 ± 33%  ivb42/unixbench/performance-execl
       110          +174.4%        302        GEO-MEAN sched_debug.cfs_rq[47]:/.tg_load_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       110 ± 42%    +168.2%        295 ± 36%  ivb42/unixbench/performance-execl
       110          +168.2%        295        GEO-MEAN sched_debug.cfs_rq[47]:/.blocked_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     48605 ±  8%     +84.7%      89750 ±  5%  client7/autotest/performance-unixbench
       815 ± 37%    +242.0%       2787 ± 38%  ivb42/unixbench/performance-execl
      6293          +151.3%      15817        GEO-MEAN sched_debug.cpu#5.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        16 ± 16%     -59.5%          6 ± 28%  client7/autotest/performance-unixbench
        16           -59.5%          6        GEO-MEAN sched_debug.cfs_rq[11]:/.nr_spread_over

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2160 ± 19%    +138.2%       5146 ± 24%  ivb42/unixbench/performance-execl
      2160          +138.2%       5146        GEO-MEAN sched_debug.cfs_rq[29]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2817 ± 25%    +164.6%       7455 ± 20%  ivb42/unixbench/performance-execl
      2817          +164.6%       7454        GEO-MEAN sched_debug.cpu#5.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3085 ± 41%    +187.0%       8856 ± 35%  ivb42/unixbench/performance-execl
      3085          +187.0%       8856        GEO-MEAN sched_debug.cpu#19.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2986 ± 28%    +167.6%       7991 ± 14%  ivb42/unixbench/performance-execl
      2985          +167.6%       7991        GEO-MEAN sched_debug.cpu#16.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2292 ± 17%    +132.5%       5331 ± 24%  ivb42/unixbench/performance-execl
      2292          +132.5%       5331        GEO-MEAN sched_debug.cfs_rq[30]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        12 ± 19%    +112.7%         26 ± 18%  client7/autotest/performance-unixbench
        12          +112.7%         26        GEO-MEAN sched_debug.cfs_rq[0]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    232162 ±  2%     -46.4%     124451 ± 17%  client7/autotest/performance-unixbench
       260 ± 36%    +271.2%        967 ± 18%  ivb42/unixbench/performance-execl
      7780           +41.1%      10975        GEO-MEAN sched_debug.cfs_rq[10]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5168 ±  6%     -53.9%       2382 ± 18%  client7/autotest/performance-unixbench
      5167           -53.9%       2382        GEO-MEAN sched_debug.cpu#11.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3908 ± 11%     +99.8%       7809 ± 15%  ivb42/unixbench/performance-execl
      3908           +99.8%       7809        GEO-MEAN sched_debug.cpu#15.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5455 ±  7%     -55.2%       2443 ±  6%  client7/autotest/performance-unixbench
      5455           -55.2%       2443        GEO-MEAN sched_debug.cpu#10.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    101631 ± 10%     +52.1%     154574 ± 23%  client7/autotest/performance-unixbench
       300 ± 36%    +214.7%        946 ± 15%  ivb42/unixbench/performance-execl
      5528          +118.8%      12095        GEO-MEAN sched_debug.cfs_rq[9]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        65 ± 10%     -51.4%         32 ±  9%  client7/autotest/performance-unixbench
        65           -51.4%         32        GEO-MEAN sched_debug.cfs_rq[10]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4052 ±  6%    +129.8%       9312 ±  6%  ivb42/unixbench/performance-execl
      4052          +129.8%       9312        GEO-MEAN sched_debug.cpu#47.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       972 ± 13%    +127.9%       2216 ± 11%  ivb42/unixbench/performance-execl
       972          +127.9%       2216        GEO-MEAN sched_debug.cfs_rq[47]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        64 ±  7%     -55.2%         29 ± 17%  client7/autotest/performance-unixbench
        64           -55.2%         29        GEO-MEAN sched_debug.cpu#11.cpu_load[2]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        26 ± 29%    +116.8%         56 ± 15%  client7/autotest/performance-unixbench
        26          +116.8%         56        GEO-MEAN sched_debug.cfs_rq[2]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       931 ± 21%     +94.7%       1813 ± 25%  client7/autotest/performance-unixbench
       931           +94.7%       1813        GEO-MEAN sched_debug.cpu#0.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     10323 ± 12%    +120.7%      22785 ± 12%  ivb42/unixbench/performance-execl
     10322          +120.7%      22785        GEO-MEAN sched_debug.cpu#0.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        20 ± 15%    +118.3%         45 ±  5%  client7/autotest/performance-unixbench
        20          +118.3%         45        GEO-MEAN sched_debug.cpu#3.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   1424033 ±  2%     -41.4%     834195 ±  7%  client7/autotest/performance-unixbench
      1214 ± 44%    +259.0%       4359 ± 34%  ivb42/unixbench/performance-execl
     41582           +45.0%      60304        GEO-MEAN sched_debug.cfs_rq[10]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        61 ±  9%     -48.2%         32 ± 15%  client7/autotest/performance-unixbench
        61           -48.2%         32        GEO-MEAN sched_debug.cfs_rq[11]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4845 ±  5%    +106.9%      10024 ±  7%  ivb42/unixbench/performance-execl
      4845          +106.9%      10024        GEO-MEAN sched_debug.cpu#40.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      8430 ± 43%    +234.3%      28182 ± 48%  ivb42/unixbench/performance-execl
      8430          +234.3%      28182        GEO-MEAN sched_debug.cpu#21.sched_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4805 ±  5%    +116.2%      10387 ±  8%  ivb42/unixbench/performance-execl
      4805          +116.2%      10387        GEO-MEAN sched_debug.cpu#36.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        26 ± 30%    +113.6%         56 ± 17%  client7/autotest/performance-unixbench
        26          +113.6%         56        GEO-MEAN sched_debug.cpu#2.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4996 ±  5%    +104.8%      10234 ±  3%  ivb42/unixbench/performance-execl
      4996          +104.8%      10234        GEO-MEAN sched_debug.cpu#31.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5039 ±  5%    +109.8%      10576 ±  3%  ivb42/unixbench/performance-execl
      5039          +109.8%      10576        GEO-MEAN sched_debug.cpu#39.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4489 ±  6%    +107.8%       9330 ±  7%  ivb42/unixbench/performance-execl
      4489          +107.8%       9330        GEO-MEAN sched_debug.cpu#46.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        19 ± 15%    +143.3%         47 ± 11%  client7/autotest/performance-unixbench
        19          +143.3%         47        GEO-MEAN sched_debug.cfs_rq[3]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1.14 ± 20%     +72.9%       1.97 ± 13%  client7/autotest/performance-unixbench
      1.14           +72.9%       1.97        GEO-MEAN turbostat.%pc3

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4506 ±  5%    +112.0%       9556 ±  6%  ivb42/unixbench/performance-execl
      4506          +112.0%       9556        GEO-MEAN sched_debug.cpu#44.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4575 ±  5%    +116.9%       9922 ±  9%  ivb42/unixbench/performance-execl
      4575          +116.9%       9921        GEO-MEAN sched_debug.cpu#43.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     44590 ± 13%    +105.5%      91634 ±  4%  client7/autotest/performance-unixbench
     44589          +105.5%      91634        GEO-MEAN sched_debug.cpu#2.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4958 ±  4%    +104.5%      10138 ±  7%  ivb42/unixbench/performance-execl
      4958          +104.5%      10138        GEO-MEAN sched_debug.cpu#24.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4671 ±  5%    +131.7%      10826 ± 25%  ivb42/unixbench/performance-execl
      4671          +131.7%      10826        GEO-MEAN sched_debug.cpu#41.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       505 ±  9%     -49.6%        254 ±  4%  ivb42/unixbench/performance-execl
       505           -49.6%        254        GEO-MEAN slabinfo.kmalloc-32.active_slabs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       505 ±  9%     -49.6%        254 ±  4%  ivb42/unixbench/performance-execl
       505           -49.6%        254        GEO-MEAN slabinfo.kmalloc-32.num_slabs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4474 ±  5%     +99.3%       8917 ±  6%  ivb42/unixbench/performance-execl
      4474           +99.3%       8917        GEO-MEAN sched_debug.cpu#45.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    670199 ±  1%     -50.1%     334352 ±  2%  client7/autotest/performance-unixbench
    670199           -50.1%     334352        GEO-MEAN cpuidle.C1E-NHM.usage

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     42580 ± 10%    +112.1%      90323 ±  2%  client7/autotest/performance-unixbench
      1370 ± 19%    +126.8%       3109 ± 36%  ivb42/unixbench/performance-execl
      7639          +119.3%      16758        GEO-MEAN sched_debug.cpu#3.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      8459 ±  9%    +118.4%      18473 ± 19%  ivb42/unixbench/performance-execl
      8458          +118.4%      18473        GEO-MEAN sched_debug.cpu#3.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2180 ± 41%     +83.4%       3997 ±  9%  ivb42/unixbench/performance-execl
      2180           +83.4%       3997        GEO-MEAN sched_debug.cpu#38.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      6695 ± 17%     +77.4%      11879 ±  6%  ivb42/unixbench/performance-execl
      6695           +77.4%      11879        GEO-MEAN sched_debug.cpu#22.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4682 ±  8%    +100.4%       9382 ±  9%  ivb42/unixbench/performance-execl
      4682          +100.4%       9382        GEO-MEAN sched_debug.cpu#42.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4827 ±  8%     +92.3%       9281 ± 10%  ivb42/unixbench/performance-execl
      4826           +92.3%       9281        GEO-MEAN sched_debug.cpu#33.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5061 ±  5%     +91.6%       9694 ±  7%  ivb42/unixbench/performance-execl
      5060           +91.6%       9694        GEO-MEAN sched_debug.cpu#28.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4768 ±  7%     +90.9%       9103 ±  4%  ivb42/unixbench/performance-execl
      4768           +90.9%       9103        GEO-MEAN sched_debug.cpu#35.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   1463083 ±  6%     -48.2%     758024 ±  2%  client7/autotest/performance-unixbench
   1463083           -48.2%     758024        GEO-MEAN sched_debug.cfs_rq[11]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4913 ±  5%    +100.6%       9858 ± 14%  ivb42/unixbench/performance-execl
      4913          +100.6%       9858        GEO-MEAN sched_debug.cpu#29.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2204 ± 44%     +89.4%       4174 ± 26%  ivb42/unixbench/performance-execl
      2204           +89.4%       4174        GEO-MEAN sched_debug.cfs_rq[16]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4913 ±  7%     +83.2%       9000 ±  5%  ivb42/unixbench/performance-execl
      4912           +83.2%       9000        GEO-MEAN sched_debug.cpu#32.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2.86 ± 19%     +97.8%       5.66 ± 13%  ivb42/unixbench/performance-execl
      2.86           +97.8%       5.66        GEO-MEAN turbostat.%pc2

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     48392 ±  8%     +82.4%      88281 ±  0%  client7/autotest/performance-unixbench
      1141 ± 34%    +101.4%       2299 ± 34%  ivb42/unixbench/performance-execl
      7433           +91.7%      14248        GEO-MEAN sched_debug.cpu#4.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       955 ± 23%     +93.1%       1845 ± 11%  client7/autotest/performance-unixbench
       955           +93.1%       1845        GEO-MEAN sched_debug.cpu#7.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    593481 ±  7%     +40.0%     830999 ±  4%  client7/autotest/performance-unixbench
      1805 ± 48%    +221.4%       5804 ± 28%  ivb42/unixbench/performance-execl
     32737          +112.1%      69452        GEO-MEAN sched_debug.cfs_rq[6]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        16 ± 24%    +125.0%         37 ± 20%  client7/autotest/performance-unixbench
        16          +125.0%         37        GEO-MEAN sched_debug.cpu#12.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        16 ± 32%    +117.9%         36 ± 15%  client7/autotest/performance-unixbench
        16          +117.9%         36        GEO-MEAN sched_debug.cfs_rq[12]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        78 ±  7%     -42.2%         45 ± 22%  client7/autotest/performance-unixbench
        78           -42.2%         45        GEO-MEAN sched_debug.cpu#5.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        16 ± 49%    +101.2%         33 ± 26%  ivb42/unixbench/performance-execl
        16          +101.2%         33        GEO-MEAN sched_debug.cfs_rq[28]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        73 ±  6%     -49.2%         37 ± 13%  client7/autotest/performance-unixbench
        73           -49.2%         37        GEO-MEAN sched_debug.cpu#11.cpu_load[1]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        17 ± 25%     +65.1%         28 ± 18%  client7/autotest/performance-unixbench
        17           +65.1%         28        GEO-MEAN sched_debug.cpu#0.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      6873 ± 26%     -44.8%       3792 ± 11%  ivb42/unixbench/performance-execl
      6873           -44.8%       3792        GEO-MEAN cpuidle.C1-IVT.usage

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2429 ± 17%     +89.7%       4609 ± 17%  ivb42/unixbench/performance-execl
      2429           +89.7%       4609        GEO-MEAN sched_debug.cfs_rq[28]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4918 ±  8%     +85.8%       9137 ±  7%  ivb42/unixbench/performance-execl
      4918           +85.8%       9137        GEO-MEAN sched_debug.cpu#34.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5427 ±  5%     +95.7%      10624 ± 15%  ivb42/unixbench/performance-execl
      5427           +95.7%      10624        GEO-MEAN sched_debug.cpu#27.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       813 ± 47%     +96.9%       1602 ± 25%  ivb42/unixbench/performance-execl
       813           +96.9%       1602        GEO-MEAN sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1572 ± 18%     +65.7%       2604 ± 30%  client7/autotest/performance-unixbench
      1572           +65.7%       2604        GEO-MEAN sched_debug.cpu#13.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1191 ± 12%     +49.3%       1778 ±  6%  client7/autotest/performance-unixbench
      1191           +49.3%       1778        GEO-MEAN sched_debug.cpu#3.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7291 ± 15%     +65.8%      12092 ±  8%  ivb42/unixbench/performance-execl
      7291           +65.8%      12092        GEO-MEAN sched_debug.cpu#18.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7729 ± 23%    +107.1%      16004 ± 15%  ivb42/unixbench/performance-execl
      7729          +107.1%      16004        GEO-MEAN sched_debug.cpu#4.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        15 ± 28%     +60.8%         25 ± 12%  client7/autotest/performance-unixbench
        15           +60.8%         25        GEO-MEAN sched_debug.cpu#5.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7235 ± 18%     +71.1%      12380 ±  6%  ivb42/unixbench/performance-execl
      7235           +71.1%      12380        GEO-MEAN sched_debug.cpu#20.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    399458 ±  6%     -49.2%     202852 ±  4%  client7/autotest/performance-unixbench
      6979 ± 14%     +64.3%      11469 ±  3%  ivb42/unixbench/performance-execl
     52802            -8.7%      48234        GEO-MEAN sched_debug.cpu#11.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4185 ±  9%     +89.8%       7945 ± 15%  ivb42/unixbench/performance-execl
      4185           +89.8%       7945        GEO-MEAN sched_debug.cpu#3.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1161 ± 13%     +59.7%       1855 ± 14%  ivb42/unixbench/performance-execl
      1161           +59.7%       1855        GEO-MEAN sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5762 ±  3%     +75.8%      10128 ± 12%  ivb42/unixbench/performance-execl
      5762           +75.8%      10128        GEO-MEAN sched_debug.cpu#26.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        24 ± 14%     +61.5%         39 ± 15%  ivb42/unixbench/performance-execl
        24           +61.5%         39        GEO-MEAN sched_debug.cfs_rq[38]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    586746 ±  8%     +70.4%    1000000 ±  0%  ivb42/unixbench/performance-execl
    586746           +70.4%     999999        GEO-MEAN sched_debug.cpu#25.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        58 ±  6%     -40.1%         35 ± 13%  client7/autotest/performance-unixbench
        58           -40.1%         34        GEO-MEAN sched_debug.cpu#10.cpu_load[4]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        25 ± 15%     +65.1%         41 ± 16%  client7/autotest/performance-unixbench
        25           +65.1%         41        GEO-MEAN sched_debug.cfs_rq[1]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        61 ±  6%     -38.4%         37 ± 14%  client7/autotest/performance-unixbench
        61           -38.4%         37        GEO-MEAN sched_debug.cpu#10.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7521 ± 23%     +63.0%      12255 ±  5%  ivb42/unixbench/performance-execl
      7521           +63.0%      12255        GEO-MEAN sched_debug.cpu#23.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      6965 ±  8%     +63.6%      11397 ± 25%  ivb42/unixbench/performance-execl
      6964           +63.6%      11397        GEO-MEAN sched_debug.cpu#0.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3842 ± 23%     +84.9%       7104 ± 15%  ivb42/unixbench/performance-execl
      3841           +84.9%       7103        GEO-MEAN sched_debug.cpu#4.sched_goidle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         3 ± 14%    +105.9%          7 ± 36%  client7/autotest/performance-unixbench
         3          +105.9%          6        GEO-MEAN sched_debug.cfs_rq[3]:/.nr_spread_over

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     14.19 ±  1%      -9.2%      12.88 ±  1%  client7/autotest/performance-unixbench
      5.54 ± 16%     -54.6%       2.52 ± 30%  ivb42/unixbench/performance-execl
      8.86           -35.8%       5.69        GEO-MEAN turbostat.%pc6

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        72 ±  7%     -38.5%         44 ± 18%  client7/autotest/performance-unixbench
        72           -38.5%         44        GEO-MEAN sched_debug.cfs_rq[5]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        19 ± 23%     +53.7%         29 ± 17%  client7/autotest/performance-unixbench
        18           +53.7%         29        GEO-MEAN sched_debug.cpu#6.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       798 ± 15%     +41.2%       1126 ± 20%  ivb42/unixbench/performance-execl
       798           +41.2%       1126        GEO-MEAN sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3774 ± 14%     +84.6%       6967 ± 31%  ivb42/unixbench/performance-execl
      3774           +84.6%       6967        GEO-MEAN sched_debug.cpu#3.ttwu_count

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        16 ± 16%     +43.9%         23 ± 20%  ivb42/unixbench/performance-execl
        16           +43.9%         23        GEO-MEAN sched_debug.cfs_rq[15]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    671065 ±  5%     +20.0%     804997 ±  5%  client7/autotest/performance-unixbench
    671065           +20.0%     804997        GEO-MEAN sched_debug.cfs_rq[5]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1514 ± 20%     +56.4%       2368 ± 24%  client7/autotest/performance-unixbench
      1514           +56.4%       2368        GEO-MEAN sched_debug.cpu#12.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       597 ± 23%     +85.9%       1110 ± 27%  ivb42/unixbench/performance-execl
       597           +85.9%       1110        GEO-MEAN sched_debug.cfs_rq[2]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        74 ±  8%     -39.3%         45 ± 14%  client7/autotest/performance-unixbench
        74           -39.3%         45        GEO-MEAN sched_debug.cpu#10.cpu_load[1]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    170819 ±  3%     +16.8%     199577 ±  5%  client7/autotest/performance-unixbench
      6864 ± 20%     +90.1%      13046 ±  3%  ivb42/unixbench/performance-execl
     34241           +49.0%      51027        GEO-MEAN sched_debug.cpu#13.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7604 ± 21%     +57.1%      11947 ±  5%  ivb42/unixbench/performance-execl
      7604           +57.1%      11947        GEO-MEAN sched_debug.cpu#21.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        15 ± 31%     +89.6%         29 ± 18%  client7/autotest/performance-unixbench
        15           +89.6%         29        GEO-MEAN sched_debug.cfs_rq[12]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    402973 ±  0%     -40.7%     239098 ±  7%  client7/autotest/performance-unixbench
      7507 ± 13%     +53.9%      11556 ±  6%  ivb42/unixbench/performance-execl
     55002            -4.4%      52564        GEO-MEAN sched_debug.cpu#10.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        87 ±  7%     -40.7%         51 ± 13%  client7/autotest/performance-unixbench
        87           -40.7%         51        GEO-MEAN sched_debug.cpu#11.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7734 ± 10%     +59.5%      12336 ±  7%  ivb42/unixbench/performance-execl
      7734           +59.5%      12336        GEO-MEAN sched_debug.cpu#16.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     16604 ± 17%     +41.9%      23555 ± 14%  ivb42/unixbench/performance-execl
     16604           +41.9%      23555        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7405 ± 14%     +67.3%      12390 ±  7%  ivb42/unixbench/performance-execl
      7405           +67.3%      12390        GEO-MEAN sched_debug.cpu#19.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     23622 ±  5%     -10.3%      21198 ±  7%  client7/autotest/performance-unixbench
     64567 ±  9%     -49.5%      32618 ±  4%  ivb42/unixbench/performance-execl
     39054           -32.7%      26295        GEO-MEAN slabinfo.kmalloc-32.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     23804 ±  5%      -9.6%      21510 ±  7%  client7/autotest/performance-unixbench
     64715 ±  9%     -49.6%      32618 ±  4%  ivb42/unixbench/performance-execl
     39249           -32.5%      26488        GEO-MEAN slabinfo.kmalloc-32.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        66 ±  7%     -39.0%         40 ± 13%  client7/autotest/performance-unixbench
        66           -39.0%         40        GEO-MEAN sched_debug.cpu#10.cpu_load[2]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        68 ±  7%     +48.7%        101 ± 17%  client7/autotest/performance-unixbench
        68           +48.7%        101        GEO-MEAN sched_debug.cfs_rq[0]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3166 ±  7%     +48.3%       4694 ± 17%  client7/autotest/performance-unixbench
      3166           +48.3%       4694        GEO-MEAN sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      8114 ±  6%     +54.6%      12544 ± 11%  ivb42/unixbench/performance-execl
      8114           +54.6%      12543        GEO-MEAN sched_debug.cpu#15.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       540 ± 12%     +60.4%        867 ± 11%  ivb42/unixbench/performance-execl
       540           +60.4%        866        GEO-MEAN slabinfo.mnt_cache.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       540 ± 12%     +60.4%        867 ± 11%  ivb42/unixbench/performance-execl
       540           +60.4%        866        GEO-MEAN slabinfo.mnt_cache.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        38 ± 14%     +57.6%         60 ± 12%  client7/autotest/performance-unixbench
        38           +57.6%         60        GEO-MEAN sched_debug.cpu#7.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        45 ±  7%     -38.2%         28 ± 28%  client7/autotest/performance-unixbench
        45           -38.2%         28        GEO-MEAN sched_debug.cfs_rq[15]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    170701 ±  6%     +58.3%     270227 ± 12%  client7/autotest/performance-unixbench
      7726 ± 17%     +55.1%      11979 ±  7%  ivb42/unixbench/performance-execl
     36316           +56.7%      56896        GEO-MEAN sched_debug.cpu#9.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       287 ± 13%     +67.8%        482 ±  5%  client7/autotest/performance-unixbench
       714 ± 10%     +51.2%       1079 ±  6%  ivb42/unixbench/performance-execl
       453           +59.3%        721        GEO-MEAN slabinfo.RAW.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       287 ± 13%     +67.8%        482 ±  5%  client7/autotest/performance-unixbench
       714 ± 10%     +51.2%       1079 ±  6%  ivb42/unixbench/performance-execl
       453           +59.3%        721        GEO-MEAN slabinfo.RAW.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        91 ± 10%     -38.7%         56 ± 19%  client7/autotest/performance-unixbench
        91           -38.7%         56        GEO-MEAN sched_debug.cpu#10.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7499 ± 15%     +74.9%      13115 ± 20%  ivb42/unixbench/performance-execl
      7499           +74.9%      13115        GEO-MEAN sched_debug.cpu#17.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1228 ± 20%     +47.7%       1814 ±  4%  ivb42/unixbench/performance-execl
      1228           +47.7%       1814        GEO-MEAN sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3258 ±  9%     -31.5%       2231 ± 12%  client7/autotest/performance-unixbench
      3258           -31.5%       2231        GEO-MEAN sched_debug.cpu#15.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
         4 ±  9%     +85.7%          7 ± 40%  client7/autotest/performance-unixbench
         4           +85.7%          7        GEO-MEAN sched_debug.cfs_rq[0]:/.nr_spread_over

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        25 ± 20%     +48.8%         38 ±  4%  ivb42/unixbench/performance-execl
        25           +48.8%         38        GEO-MEAN sched_debug.cfs_rq[39]:/.tg_runnable_contrib

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     77564 ± 14%     +45.8%     113067 ± 12%  client7/autotest/performance-unixbench
     77564           +45.8%     113067        GEO-MEAN sched_debug.cfs_rq[0]:/.exec_clock

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2916 ± 19%     +51.7%       4422 ±  9%  ivb42/unixbench/performance-execl
      2916           +51.7%       4422        GEO-MEAN sched_debug.cfs_rq[40]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        29 ± 12%     +40.7%         40 ± 13%  client7/autotest/performance-unixbench
        29           +40.7%         40        GEO-MEAN sched_debug.cpu#2.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    199089 ±  7%     +43.0%     284760 ±  4%  client7/autotest/performance-unixbench
      7976 ± 10%     +60.7%      12814 ±  9%  ivb42/unixbench/performance-execl
     39848           +51.6%      60407        GEO-MEAN sched_debug.cpu#0.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7883 ±  9%     +54.0%      12139 ± 12%  ivb42/unixbench/performance-execl
      7882           +54.0%      12139        GEO-MEAN sched_debug.cpu#5.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2924 ± 32%     +73.2%       5064 ± 15%  ivb42/unixbench/performance-execl
      2924           +73.2%       5064        GEO-MEAN sched_debug.cfs_rq[47]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7.63 ±  2%     +48.1%      11.29 ±  1%  client7/autotest/performance-unixbench
      7.63           +48.1%      11.29        GEO-MEAN turbostat.%c3

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    131628 ±  4%     +37.0%     180310 ±  2%  client7/autotest/performance-unixbench
      7964 ± 20%     +44.9%      11541 ±  5%  ivb42/unixbench/performance-execl
     32378           +40.9%      45617        GEO-MEAN sched_debug.cpu#8.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       529 ±  3%     -23.8%        403 ± 16%  client7/autotest/performance-unixbench
       529           -23.8%        403        GEO-MEAN slabinfo.xfs_buf.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        39 ±  6%     -30.8%         27 ±  8%  client7/autotest/performance-unixbench
        39           -30.8%         27        GEO-MEAN sched_debug.cfs_rq[8]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       529 ±  3%     -23.8%        403 ± 16%  client7/autotest/performance-unixbench
       529           -23.8%        403        GEO-MEAN slabinfo.xfs_buf.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        78 ±  5%     -26.3%         57 ± 17%  client7/autotest/performance-unixbench
        78           -26.3%         57        GEO-MEAN sched_debug.cpu#4.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     10001 ±  3%     -27.0%       7298 ±  8%  client7/autotest/performance-unixbench
     10001           -27.0%       7298        GEO-MEAN slabinfo.kmalloc-192.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    399521 ±  8%     +49.5%     597137 ±  1%  ivb42/unixbench/performance-execl
    399521           +49.5%     597137        GEO-MEAN cpuidle.C6-IVT.usage

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      6691 ± 16%     +46.3%       9790 ±  8%  ivb42/unixbench/performance-execl
      6691           +46.3%       9790        GEO-MEAN sched_debug.cpu#38.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     92567 ±  0%     -13.2%      80343 ±  0%  client7/autotest/performance-unixbench
      1350 ± 15%    +102.1%       2729 ± 26%  ivb42/unixbench/performance-execl
     11178           +32.5%      14807        GEO-MEAN sched_debug.cpu#15.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     16946 ± 16%     +33.7%      22663 ± 12%  ivb42/unixbench/performance-execl
     16946           +33.7%      22663        GEO-MEAN sched_debug.cfs_rq[1]:/.tg_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     10196 ±  2%     -26.6%       7486 ±  7%  client7/autotest/performance-unixbench
     10195           -26.6%       7486        GEO-MEAN slabinfo.kmalloc-192.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    567017 ±  6%     +41.7%     803670 ±  3%  client7/autotest/performance-unixbench
    567017           +41.7%     803670        GEO-MEAN sched_debug.cfs_rq[0]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        45 ± 10%     -30.6%         31 ± 22%  client7/autotest/performance-unixbench
        45           -30.6%         31        GEO-MEAN sched_debug.cfs_rq[15]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    240910 ±  8%     +26.7%     305311 ±  5%  client7/autotest/performance-unixbench
      8061 ± 19%     +43.3%      11552 ±  4%  ivb42/unixbench/performance-execl
     44070           +34.8%      59388        GEO-MEAN sched_debug.cpu#6.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        38 ±  5%     +40.9%         54 ± 14%  client7/autotest/performance-unixbench
        38           +40.9%         54        GEO-MEAN sched_debug.cfs_rq[7]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        22 ± 21%     +49.1%         34 ±  8%  client7/autotest/performance-unixbench
        22           +49.1%         34        GEO-MEAN sched_debug.cpu#4.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        14 ± 29%     +48.6%         22 ± 13%  client7/autotest/performance-unixbench
        14           +48.6%         22        GEO-MEAN sched_debug.cpu#5.cpu_load[1]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    226918 ±  8%     +29.5%     293865 ±  3%  client7/autotest/performance-unixbench
      8569 ±  7%     +51.2%      12952 ± 11%  ivb42/unixbench/performance-execl
     44096           +39.9%      61695        GEO-MEAN sched_debug.cpu#3.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    180321 ±  6%     +17.9%     212650 ±  3%  client7/autotest/performance-unixbench
      7462 ± 19%     +70.8%      12741 ± 10%  ivb42/unixbench/performance-execl
     36681           +41.9%      52052        GEO-MEAN sched_debug.cpu#12.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    192619 ± 14%     +42.5%     274465 ±  8%  client7/autotest/performance-unixbench
      8830 ± 24%     +41.2%      12469 ±  4%  ivb42/unixbench/performance-execl
     41241           +41.9%      58500        GEO-MEAN sched_debug.cpu#7.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1511 ± 12%     +32.2%       1998 ± 12%  client7/autotest/performance-unixbench
      1511           +32.2%       1998        GEO-MEAN sched_debug.cpu#4.curr->pid

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    612413 ±  7%     +32.4%     810895 ±  4%  client7/autotest/performance-unixbench
    612413           +32.4%     810895        GEO-MEAN sched_debug.cfs_rq[3]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1023 ±  4%     +30.1%       1332 ±  7%  ivb42/unixbench/performance-execl
      1023           +30.1%       1332        GEO-MEAN slabinfo.mm_struct.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1023 ±  4%     +30.1%       1332 ±  7%  ivb42/unixbench/performance-execl
      1023           +30.1%       1332        GEO-MEAN slabinfo.mm_struct.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    653230 ±  5%     +38.2%     902600 ±  7%  client7/autotest/performance-unixbench
    653230           +38.2%     902600        GEO-MEAN sched_debug.cfs_rq[2]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        25 ± 26%     +29.6%         32 ± 10%  client7/autotest/performance-unixbench
        24           +29.6%         32        GEO-MEAN sched_debug.cpu#4.cpu_load[3]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        47 ±  7%     -32.1%         32 ± 21%  client7/autotest/performance-unixbench
        47           -32.1%         32        GEO-MEAN sched_debug.cpu#15.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        24 ± 23%     +33.9%         33 ±  9%  client7/autotest/performance-unixbench
        24           +33.9%         33        GEO-MEAN sched_debug.cpu#4.cpu_load[2]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      8774 ± 10%     +35.7%      11908 ±  8%  ivb42/unixbench/performance-execl
      8774           +35.7%      11908        GEO-MEAN sched_debug.cpu#4.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       113 ±  3%     -24.2%         85 ±  6%  client7/autotest/performance-unixbench
       113           -24.2%         85        GEO-MEAN sched_debug.cpu#13.nr_uninterruptible

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    251517 ±  6%     +15.0%     289276 ±  4%  client7/autotest/performance-unixbench
      7919 ±  9%     +58.6%      12563 ±  5%  ivb42/unixbench/performance-execl
     44630           +35.1%      60284        GEO-MEAN sched_debug.cpu#1.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
 3.665e+09 ±  0%     +33.4%  4.889e+09 ±  1%  client7/autotest/performance-unixbench
 3.665e+09           +33.4%  4.889e+09        GEO-MEAN cpuidle.C3-NHM.time

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        38 ± 15%     +26.9%         49 ± 10%  client7/autotest/performance-unixbench
        38           +26.9%         48        GEO-MEAN sched_debug.cpu#12.cpu_load[0]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    756792 ± 11%     +25.3%     948522 ±  4%  ivb42/unixbench/performance-execl
    756792           +25.3%     948522        GEO-MEAN sched_debug.cpu#14.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     13492 ±  8%     +34.2%      18107 ± 18%  ivb42/unixbench/performance-execl
     13492           +34.2%      18107        GEO-MEAN sched_debug.cpu#2.nr_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     63611 ±  9%     +43.6%      91355 ±  4%  client7/autotest/performance-unixbench
      4064 ±  4%     +39.5%       5672 ± 22%  ivb42/unixbench/performance-execl
     16080           +41.6%      22763        GEO-MEAN sched_debug.cpu#0.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        24 ± 21%     +38.3%         33 ±  7%  client7/autotest/performance-unixbench
        24           +38.3%         33        GEO-MEAN sched_debug.cpu#4.cpu_load[1]

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        41 ±  8%     -22.0%         32 ±  8%  client7/autotest/performance-unixbench
        41           -22.0%         32        GEO-MEAN sched_debug.cpu#8.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    724304 ±  7%     +36.9%     991722 ±  0%  ivb42/unixbench/performance-execl
    724304           +36.9%     991722        GEO-MEAN sched_debug.cpu#37.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        16 ± 25%     +43.8%         23 ± 14%  client7/autotest/performance-unixbench
        15           +43.8%         23        GEO-MEAN sched_debug.cfs_rq[4]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        14 ±  5%     +29.6%         18 ±  5%  client7/autotest/performance-unixbench
        14           +29.6%         18        GEO-MEAN numa-numastat.node0.other_node

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    252858 ±  7%     +33.4%     337348 ±  6%  client7/autotest/performance-unixbench
     10508 ±  3%     +21.3%      12744 ± 10%  ivb42/unixbench/performance-execl
     51546           +27.2%      65569        GEO-MEAN sched_debug.cpu#2.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        41 ±  6%     -19.8%         33 ±  6%  client7/autotest/performance-unixbench
        41           -19.8%         33        GEO-MEAN sched_debug.cfs_rq[8]:/.load

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2161 ±  2%     +23.7%       2673 ±  5%  ivb42/unixbench/performance-execl
      2161           +23.7%       2672        GEO-MEAN slabinfo.kmalloc-2048.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3736 ±  4%     +28.6%       4803 ±  1%  ivb42/unixbench/performance-execl
      3736           +28.6%       4803        GEO-MEAN slabinfo.kmalloc-96.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3772 ±  4%     +28.3%       4839 ±  1%  ivb42/unixbench/performance-execl
      3772           +28.3%       4839        GEO-MEAN slabinfo.kmalloc-96.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
 2.552e+08 ±  6%     +32.0%  3.368e+08 ± 15%  client7/autotest/performance-unixbench
 2.552e+08           +32.0%  3.368e+08        GEO-MEAN cpuidle.C1-NHM.time

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        73 ±  5%     +32.0%         96 ±  9%  client7/autotest/performance-unixbench
        73           +32.0%         96        GEO-MEAN sched_debug.cpu#9.nr_uninterruptible

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7641 ± 10%     +39.7%      10674 ±  6%  client7/autotest/performance-unixbench
     12833 ±  7%     +15.5%      14825 ±  4%  ivb42/unixbench/performance-execl
      9902           +27.0%      12579        GEO-MEAN slabinfo.anon_vma.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     22311 ±  9%     +22.2%      27261 ±  5%  ivb42/unixbench/performance-execl
     22311           +22.2%      27261        GEO-MEAN slabinfo.vm_area_struct.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     22445 ±  9%     +21.5%      27279 ±  5%  ivb42/unixbench/performance-execl
     22445           +21.5%      27279        GEO-MEAN slabinfo.vm_area_struct.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  12867359 ±  2%     -20.1%   10282559 ±  0%  ivb42/unixbench/performance-execl
  12867359           -20.1%   10282558        GEO-MEAN proc-vmstat.pgfree

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  12867752 ±  2%     -20.1%   10283113 ±  0%  ivb42/unixbench/performance-execl
  12867752           -20.1%   10283113        GEO-MEAN proc-vmstat.pgalloc_normal

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       509 ±  9%     +21.5%        619 ±  5%  ivb42/unixbench/performance-execl
       509           +21.5%        619        GEO-MEAN slabinfo.vm_area_struct.active_slabs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       509 ±  9%     +21.5%        619 ±  5%  ivb42/unixbench/performance-execl
       509           +21.5%        619        GEO-MEAN slabinfo.vm_area_struct.num_slabs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2307 ±  2%     +21.5%       2803 ±  4%  ivb42/unixbench/performance-execl
      2307           +21.5%       2803        GEO-MEAN slabinfo.kmalloc-2048.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   6409789 ±  1%     -19.8%    5139255 ±  0%  ivb42/unixbench/performance-execl
   6409788           -19.8%    5139255        GEO-MEAN numa-numastat.node1.local_node

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   6409802 ±  1%     -19.8%    5139268 ±  0%  ivb42/unixbench/performance-execl
   6409802           -19.8%    5139268        GEO-MEAN numa-numastat.node1.numa_hit

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  12799106 ±  2%     -19.8%   10263087 ±  0%  ivb42/unixbench/performance-execl
  12799106           -19.8%   10263087        GEO-MEAN proc-vmstat.numa_hit

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  12799085 ±  2%     -19.8%   10263069 ±  0%  ivb42/unixbench/performance-execl
  12799084           -19.8%   10263069        GEO-MEAN proc-vmstat.numa_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   3267835 ±  2%     -19.3%    2635752 ±  1%  ivb42/unixbench/performance-execl
   3267835           -19.3%    2635752        GEO-MEAN numa-vmstat.node0.numa_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  16505318 ±  2%     -19.4%   13296822 ±  0%  ivb42/unixbench/performance-execl
  16505318           -19.4%   13296822        GEO-MEAN proc-vmstat.pgfault

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   6393689 ±  2%     -19.8%    5129432 ±  0%  ivb42/unixbench/performance-execl
   6393688           -19.8%    5129432        GEO-MEAN numa-numastat.node0.local_node

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   6393697 ±  2%     -19.8%    5129439 ±  0%  ivb42/unixbench/performance-execl
   6393696           -19.8%    5129439        GEO-MEAN numa-numastat.node0.numa_hit

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7.94 ±  4%     +22.4%       9.71 ±  4%  ivb42/unixbench/performance-execl
      7.94           +22.4%       9.71        GEO-MEAN turbostat.%c1

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   3301870 ±  2%     -18.7%    2685983 ±  0%  ivb42/unixbench/performance-execl
   3301870           -18.7%    2685983        GEO-MEAN numa-vmstat.node0.numa_hit

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      7862 ± 10%     +37.0%      10769 ±  6%  client7/autotest/performance-unixbench
     12951 ±  7%     +14.5%      14825 ±  4%  ivb42/unixbench/performance-execl
     10091           +25.2%      12635        GEO-MEAN slabinfo.anon_vma.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   3291343 ±  2%     -18.6%    2678738 ±  0%  ivb42/unixbench/performance-execl
   3291343           -18.6%    2678738        GEO-MEAN numa-vmstat.node1.numa_hit

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   3248233 ±  2%     -18.4%    2651644 ±  0%  ivb42/unixbench/performance-execl
   3248233           -18.4%    2651644        GEO-MEAN numa-vmstat.node1.numa_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1468 ±  8%     +25.0%       1836 ±  8%  ivb42/unixbench/performance-execl
      1468           +25.0%       1836        GEO-MEAN slabinfo.sock_inode_cache.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1468 ±  8%     +25.0%       1836 ±  8%  ivb42/unixbench/performance-execl
      1468           +25.0%       1836        GEO-MEAN slabinfo.sock_inode_cache.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    170096 ±  8%     +20.0%     204181 ±  3%  client7/autotest/performance-unixbench
     10037 ± 10%     +20.1%      12053 ±  7%  ivb42/unixbench/performance-execl
     41319           +20.1%      49608        GEO-MEAN sched_debug.cpu#14.nr_load_updates

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4102 ±  0%     -13.6%       3545 ±  4%  client7/autotest/performance-unixbench
      4102           -13.6%       3545        GEO-MEAN slabinfo.kmalloc-256.num_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3862 ±  2%     -14.4%       3306 ±  4%  client7/autotest/performance-unixbench
      3861           -14.4%       3305        GEO-MEAN slabinfo.kmalloc-256.active_objs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      4147 ± 11%     +19.1%       4941 ±  8%  client7/autotest/performance-unixbench
      4147           +19.1%       4941        GEO-MEAN sched_debug.cfs_rq[5]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     77070 ±  5%     -13.7%      66499 ±  5%  ivb42/unixbench/performance-execl
     77070           -13.7%      66499        GEO-MEAN softirqs.RCU

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
        38 ± 12%     -19.8%         30 ± 14%  client7/autotest/performance-unixbench
        38           -19.8%         30        GEO-MEAN sched_debug.cfs_rq[14]:/.runnable_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    797923 ± 16%     +20.1%     958095 ±  3%  ivb42/unixbench/performance-execl
    797923           +20.1%     958095        GEO-MEAN sched_debug.cpu#15.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2137 ±  6%     -12.4%       1871 ±  2%  client7/autotest/performance-unixbench
      2137           -12.4%       1871        GEO-MEAN numa-meminfo.node1.KernelStack

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    723678 ± 10%     +17.5%     850484 ±  5%  client7/autotest/performance-unixbench
    723678           +17.5%     850484        GEO-MEAN sched_debug.cfs_rq[1]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     93332 ± 11%     -15.6%      78792 ±  7%  ivb42/unixbench/performance-execl
     93332           -15.6%      78792        GEO-MEAN meminfo.Committed_AS

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     90569 ±  1%     -12.2%      79510 ±  1%  client7/autotest/performance-unixbench
     90569           -12.2%      79510        GEO-MEAN sched_debug.cpu#14.ttwu_local

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   6542800 ±  5%     -12.1%    5754258 ±  2%  client7/autotest/performance-unixbench
   6542800           -12.1%    5754258        GEO-MEAN cpuidle.C3-NHM.usage

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    745623 ±  5%     +14.0%     849979 ±  3%  client7/autotest/performance-unixbench
    745623           +14.0%     849979        GEO-MEAN sched_debug.cfs_rq[4]:/.min_vruntime

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     16701 ± 15%     -13.8%      14401 ±  5%  ivb42/unixbench/performance-execl
     16701           -13.8%      14401        GEO-MEAN sched_debug.cfs_rq[25]:/.tg_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2756 ±  3%     +10.2%       3037 ±  1%  ivb42/unixbench/performance-execl
      2756           +10.2%       3037        GEO-MEAN meminfo.PageTables

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    767213 ±  1%     +11.1%     851994 ±  1%  client7/autotest/performance-unixbench
    767213           +11.1%     851994        GEO-MEAN sched_debug.cpu#5.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     15581 ±  3%      -7.0%      14483 ±  4%  ivb42/unixbench/performance-execl
     15580            -7.0%      14483        GEO-MEAN sched_debug.cfs_rq[32]:/.tg_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    833110 ±  0%     +11.0%     924454 ±  0%  client7/autotest/performance-unixbench
    833110           +11.0%     924454        GEO-MEAN sched_debug.cpu#11.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
    869770 ±  5%      +8.5%     943718 ±  4%  ivb42/unixbench/performance-execl
    869770            +8.5%     943718        GEO-MEAN sched_debug.cpu#2.avg_idle

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     15656 ±  3%      -7.2%      14527 ±  4%  ivb42/unixbench/performance-execl
     15656            -7.2%      14527        GEO-MEAN sched_debug.cfs_rq[33]:/.tg_load_avg

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      5013 ± 13%     +16.4%       5836 ±  7%  client7/autotest/performance-unixbench
      5013           +16.4%       5836        GEO-MEAN sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     92323 ±  3%     -10.4%      82728 ±  2%  ivb42/unixbench/performance-execl
     92323           -10.4%      82728        GEO-MEAN softirqs.SCHED

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       697 ±  2%     +10.0%        766 ±  1%  ivb42/unixbench/performance-execl
       697           +10.0%        766        GEO-MEAN proc-vmstat.nr_page_table_pages

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      2014 ±  0%      -4.0%       1933 ±  0%  client7/autotest/performance-unixbench
      2028 ± 12%     -34.6%       1325 ±  4%  ivb42/unixbench/performance-execl
      2021           -20.8%       1600        GEO-MEAN vmstat.system.in

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
 3.701e+08 ±  0%      -4.9%  3.522e+08 ±  0%  client7/autotest/performance-unixbench
  16100636 ±  2%     -20.0%   12874053 ±  0%  ivb42/unixbench/performance-execl
  77195276           -12.8%   67332341        GEO-MEAN time.minor_page_faults

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
   4170804 ±  0%      -5.1%    3956976 ±  0%  client7/autotest/performance-unixbench
    340385 ±  2%     -19.3%     274568 ±  0%  ivb42/unixbench/performance-execl
   1191503           -12.5%    1042334        GEO-MEAN time.involuntary_context_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
     41415 ±  0%      -2.4%      40434 ±  0%  client7/autotest/performance-unixbench
     12983 ±  1%     +13.8%      14775 ±  0%  ivb42/unixbench/performance-execl
     23188            +5.4%      24442        GEO-MEAN vmstat.system.cs

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      9.26 ±  0%      -3.2%       8.96 ±  0%  client7/autotest/performance-unixbench
      9.26            -3.2%       8.96        GEO-MEAN turbostat.%c0

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      3319 ±  0%      -3.2%       3214 ±  0%  client7/autotest/performance-unixbench
      3319            -3.2%       3214        GEO-MEAN time.system_time

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
       138 ±  0%      -2.7%        135 ±  0%  client7/autotest/performance-unixbench
       138            -2.7%        135        GEO-MEAN time.percent_of_cpu_this_job_got

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
  33537415 ±  0%      -2.7%   32644695 ±  0%  client7/autotest/performance-unixbench
  33537415            -2.7%   32644695        GEO-MEAN time.voluntary_context_switches

442bf3aaf55a91eb  83a0a96a5f26d974580fd72510  
----------------  --------------------------  
      1099 ±  0%      -1.4%       1084 ±  0%  client7/autotest/performance-unixbench
      1099            -1.4%       1084        GEO-MEAN time.user_time

ivb42: Ivytown Ivy Bridge-EP
Memory: 64G

client7: Nehalem EP
Memory: 48G



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

--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

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
commit: f114040e3ea6e07372334ade75d1ee0775c355e1
model: Grantley Haswell
nr_cpu: 16
memory: 16G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
unixbench:
  test:
  - shell1
enqueue_time: 2014-10-19 23:24:55.533131700 +08:00
testbox: lituya
tbox_group: lituya
kconfig: x86_64-rhel
head_commit: 560bf8f63166af45e80fed1aa82aea772e7f3a12
base_commit: f114040e3ea6e07372334ade75d1ee0775c355e1
branch: linux-devel/devel-hourly-2014102019
kernel: "/kernel/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/vmlinuz-3.18.0-rc1-gf114040"
user: lkp
queue: cyclic
result_root: "/result/lituya/unixbench/powersave-shell1/debian-x86_64.cgz/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/0"
job_file: "/lkp/scheduled/lituya/cyclic_unixbench-powersave-shell1-x86_64-rhel-BASE-f114040e3ea6e07372334ade75d1ee0775c355e1-0.yaml"
dequeue_time: 2014-10-20 19:19:55.265992088 +08:00
job_state: finished
loadavg: 18.37 10.49 4.27 1/183 25334
start_time: '1413804034'
end_time: '1413804412'
version: "/lkp/lkp/.src-20141020-180135"

--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo powersave > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
./Run shell1

--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--qVyHzDF4yf4A8jkR--
