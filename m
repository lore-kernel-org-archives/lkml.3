Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaJAHuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:50:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:60182 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaJAHu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:50:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,630,1406617200"; 
   d="yaml'?scan'208";a="599182344"
Date: Wed, 1 Oct 2014 15:50:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dirk Brandewie <dirk.j.brandewie@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [intel_pstate] adacdf3f2b8: +119.9% aim9.shell_rtns_3.ops_per_sec,
 +51.6% turbostat.Pkg_W
Message-ID: <20141001075020.GB21294@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Dirk,

FYI, we noticed the below changes on commit
adacdf3f2b8e65aa441613cf61c4f598e9042690 ("intel_pstate: Remove C0 tracking")

test case: brickland3/aim9/300s-shell_rtns_3

      v3.15-rc8  adacdf3f2b8e65aa441613cf6 
---------------  ------------------------- 
       125 ± 5%    +119.9%        275 ± 1%  TOTAL aim9.shell_rtns_3.ops_per_sec
     96.81 ± 3%     +51.6%     146.77 ± 5%  TOTAL turbostat.Pkg_W
     36.74 ± 9%    +121.4%      81.34 ±10%  TOTAL turbostat.Cor_W
     38.36 ± 1%     +63.6%      62.76 ± 0%  TOTAL turbostat.RAM_W
    -13794 ±-5%     -13.4%     -11946 ±-6%  TOTAL sched_debug.cfs_rq[1]:/.spread0
    -10828 ±-8%     -34.7%      -7069 ±-20%  TOTAL sched_debug.cfs_rq[34]:/.spread0
    -14141 ±-8%     -19.1%     -11441 ±-19%  TOTAL sched_debug.cfs_rq[24]:/.spread0
    -13819 ±-7%     -13.6%     -11944 ±-6%  TOTAL sched_debug.cfs_rq[7]:/.spread0
      6006 ± 8%     -71.6%       1703 ±21%  TOTAL sched_debug.cpu#33.ttwu_local
      6281 ±36%     -68.3%       1988 ±49%  TOTAL sched_debug.cpu#7.ttwu_count
      3177 ±47%    +235.5%      10660 ± 6%  TOTAL cpuidle.C1-IVT-4S.usage
       268 ±45%     -68.5%         84 ±31%  TOTAL sched_debug.cpu#45.ttwu_local
      6658 ±34%     -66.1%       2260 ±30%  TOTAL sched_debug.cpu#21.ttwu_count
       292 ±44%     -71.7%         82 ±11%  TOTAL sched_debug.cpu#23.ttwu_local
      5351 ± 6%     -61.8%       2045 ±29%  TOTAL sched_debug.cpu#48.ttwu_local
      2395 ±29%     -62.9%        888 ±14%  TOTAL sched_debug.cpu#37.ttwu_count
      2269 ±11%    +144.0%       5537 ±26%  TOTAL sched_debug.cfs_rq[91]:/.blocked_load_avg
      2040 ±17%    +154.5%       5192 ±14%  TOTAL sched_debug.cfs_rq[106]:/.blocked_load_avg
      1.24 ± 6%    +154.8%       3.15 ± 0%  TOTAL turbostat.GHz
      2417 ±10%    +135.2%       5685 ±25%  TOTAL sched_debug.cfs_rq[91]:/.tg_load_contrib
        69 ±29%     -52.4%         33 ±36%  TOTAL sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
      4422 ±29%     -57.6%       1875 ± 9%  TOTAL sched_debug.cpu#3.ttwu_local
      2210 ±14%    +140.9%       5324 ±14%  TOTAL sched_debug.cfs_rq[106]:/.tg_load_contrib
      1445 ±16%    +126.6%       3276 ±14%  TOTAL sched_debug.cfs_rq[3]:/.blocked_load_avg
      1448 ±16%    +127.4%       3293 ±14%  TOTAL sched_debug.cfs_rq[3]:/.tg_load_contrib
    561248 ± 4%    +145.3%    1376953 ± 0%  TOTAL cpuidle.C6-IVT-4S.usage
      4975 ±28%     -63.7%       1805 ±13%  TOTAL sched_debug.cpu#4.ttwu_local
      1348 ±19%    +137.8%       3206 ±12%  TOTAL sched_debug.cfs_rq[48]:/.blocked_load_avg
      1696 ±13%    +106.7%       3507 ±15%  TOTAL sched_debug.cfs_rq[32]:/.tg_load_contrib
      1684 ±13%    +106.6%       3478 ±15%  TOTAL sched_debug.cfs_rq[32]:/.blocked_load_avg
      1619 ±22%    +118.1%       3532 ±13%  TOTAL sched_debug.cfs_rq[17]:/.blocked_load_avg
      1626 ±22%    +117.4%       3537 ±13%  TOTAL sched_debug.cfs_rq[17]:/.tg_load_contrib
      1354 ±19%    +137.0%       3209 ±12%  TOTAL sched_debug.cfs_rq[48]:/.tg_load_contrib
     21314 ± 5%    +125.6%      48083 ± 2%  TOTAL sched_debug.cfs_rq[85]:/.tg_load_avg
     21409 ± 5%    +125.1%      48199 ± 1%  TOTAL sched_debug.cfs_rq[83]:/.tg_load_avg
     21340 ± 5%    +125.8%      48193 ± 1%  TOTAL sched_debug.cfs_rq[84]:/.tg_load_avg
     21291 ± 5%    +125.7%      48060 ± 2%  TOTAL sched_debug.cfs_rq[86]:/.tg_load_avg
     21191 ± 6%    +126.2%      47929 ± 1%  TOTAL sched_debug.cfs_rq[102]:/.tg_load_avg
     21266 ± 5%    +126.0%      48058 ± 2%  TOTAL sched_debug.cfs_rq[90]:/.tg_load_avg
     21289 ± 5%    +125.7%      48054 ± 2%  TOTAL sched_debug.cfs_rq[89]:/.tg_load_avg
     21186 ± 6%    +126.2%      47929 ± 1%  TOTAL sched_debug.cfs_rq[101]:/.tg_load_avg
     21314 ± 6%    +125.8%      48131 ± 1%  TOTAL sched_debug.cfs_rq[113]:/.tg_load_avg
     21266 ± 5%    +126.1%      48083 ± 2%  TOTAL sched_debug.cfs_rq[91]:/.tg_load_avg
     21298 ± 6%    +125.3%      47981 ± 1%  TOTAL sched_debug.cfs_rq[106]:/.tg_load_avg
     21309 ± 6%    +125.0%      47953 ± 1%  TOTAL sched_debug.cfs_rq[105]:/.tg_load_avg
     21178 ± 6%    +126.4%      47953 ± 1%  TOTAL sched_debug.cfs_rq[100]:/.tg_load_avg
     21236 ± 6%    +126.5%      48095 ± 1%  TOTAL sched_debug.cfs_rq[93]:/.tg_load_avg
     21271 ± 5%    +126.0%      48077 ± 1%  TOTAL sched_debug.cfs_rq[88]:/.tg_load_avg
     21286 ± 5%    +126.0%      48096 ± 2%  TOTAL sched_debug.cfs_rq[87]:/.tg_load_avg
     21269 ± 6%    +126.1%      48093 ± 1%  TOTAL sched_debug.cfs_rq[92]:/.tg_load_avg
     21291 ± 6%    +125.2%      47956 ± 1%  TOTAL sched_debug.cfs_rq[104]:/.tg_load_avg
     21303 ± 6%    +125.3%      48005 ± 1%  TOTAL sched_debug.cfs_rq[107]:/.tg_load_avg
     21247 ± 6%    +125.7%      47957 ± 1%  TOTAL sched_debug.cfs_rq[94]:/.tg_load_avg
     21350 ± 6%    +125.7%      48185 ± 1%  TOTAL sched_debug.cfs_rq[119]:/.tg_load_avg
     21357 ± 6%    +125.3%      48108 ± 1%  TOTAL sched_debug.cfs_rq[114]:/.tg_load_avg
     21263 ± 6%    +125.6%      47968 ± 1%  TOTAL sched_debug.cfs_rq[103]:/.tg_load_avg
     21362 ± 6%    +125.4%      48154 ± 1%  TOTAL sched_debug.cfs_rq[118]:/.tg_load_avg
     21470 ± 5%    +124.6%      48223 ± 1%  TOTAL sched_debug.cfs_rq[82]:/.tg_load_avg
      1513 ±24%    +122.0%       3358 ±16%  TOTAL sched_debug.cfs_rq[47]:/.blocked_load_avg
     21170 ± 6%    +126.4%      47936 ± 1%  TOTAL sched_debug.cfs_rq[98]:/.tg_load_avg
     21216 ± 6%    +126.0%      47943 ± 1%  TOTAL sched_debug.cfs_rq[95]:/.tg_load_avg
     21183 ± 6%    +126.3%      47936 ± 1%  TOTAL sched_debug.cfs_rq[97]:/.tg_load_avg
     21351 ± 6%    +125.3%      48106 ± 1%  TOTAL sched_debug.cfs_rq[115]:/.tg_load_avg
     21194 ± 6%    +126.2%      47952 ± 1%  TOTAL sched_debug.cfs_rq[96]:/.tg_load_avg
     21181 ± 6%    +126.3%      47929 ± 1%  TOTAL sched_debug.cfs_rq[99]:/.tg_load_avg
     21366 ± 6%    +125.1%      48101 ± 1%  TOTAL sched_debug.cfs_rq[116]:/.tg_load_avg
     21352 ± 6%    +125.5%      48145 ± 1%  TOTAL sched_debug.cfs_rq[112]:/.tg_load_avg
     21381 ± 6%    +125.1%      48131 ± 1%  TOTAL sched_debug.cfs_rq[117]:/.tg_load_avg
     21507 ± 5%    +124.3%      48244 ± 1%  TOTAL sched_debug.cfs_rq[81]:/.tg_load_avg
     21346 ± 6%    +125.5%      48126 ± 1%  TOTAL sched_debug.cfs_rq[111]:/.tg_load_avg
     22339 ± 4%    +124.5%      50156 ± 1%  TOTAL sched_debug.cfs_rq[5]:/.tg_load_avg
     21569 ± 5%    +123.7%      48256 ± 1%  TOTAL sched_debug.cfs_rq[80]:/.tg_load_avg
     21343 ± 6%    +125.0%      48018 ± 1%  TOTAL sched_debug.cfs_rq[108]:/.tg_load_avg
      1528 ±23%    +120.8%       3373 ±16%  TOTAL sched_debug.cfs_rq[47]:/.tg_load_contrib
     21616 ± 5%    +123.2%      48245 ± 2%  TOTAL sched_debug.cfs_rq[78]:/.tg_load_avg
     21595 ± 4%    +124.7%      48525 ± 1%  TOTAL sched_debug.cfs_rq[41]:/.tg_load_avg
     21622 ± 5%    +123.4%      48294 ± 2%  TOTAL sched_debug.cfs_rq[77]:/.tg_load_avg
     21571 ± 4%    +123.7%      48245 ± 2%  TOTAL sched_debug.cfs_rq[79]:/.tg_load_avg
     22460 ± 4%    +124.3%      50377 ± 1%  TOTAL sched_debug.cfs_rq[4]:/.tg_load_avg
     22257 ± 5%    +124.2%      49910 ± 1%  TOTAL sched_debug.cfs_rq[8]:/.tg_load_avg
     22291 ± 5%    +124.0%      49922 ± 1%  TOTAL sched_debug.cfs_rq[7]:/.tg_load_avg
     22586 ± 4%    +123.3%      50430 ± 1%  TOTAL sched_debug.cfs_rq[3]:/.tg_load_avg
     22236 ± 5%    +124.1%      49831 ± 1%  TOTAL sched_debug.cfs_rq[9]:/.tg_load_avg
     21599 ± 4%    +124.4%      48473 ± 1%  TOTAL sched_debug.cfs_rq[42]:/.tg_load_avg
     22118 ± 6%    +123.8%      49501 ± 1%  TOTAL sched_debug.cfs_rq[12]:/.tg_load_avg
     21591 ± 4%    +124.8%      48544 ± 1%  TOTAL sched_debug.cfs_rq[40]:/.tg_load_avg
     21348 ± 6%    +125.3%      48090 ± 1%  TOTAL sched_debug.cfs_rq[110]:/.tg_load_avg
     21636 ± 4%    +123.4%      48331 ± 1%  TOTAL sched_debug.cfs_rq[43]:/.tg_load_avg
     22170 ± 5%    +123.5%      49543 ± 1%  TOTAL sched_debug.cfs_rq[11]:/.tg_load_avg
     22117 ± 6%    +123.8%      49505 ± 1%  TOTAL sched_debug.cfs_rq[13]:/.tg_load_avg
     21656 ± 5%    +122.8%      48260 ± 1%  TOTAL sched_debug.cfs_rq[44]:/.tg_load_avg
     22206 ± 5%    +123.4%      49613 ± 1%  TOTAL sched_debug.cfs_rq[10]:/.tg_load_avg
     22307 ± 4%    +124.3%      50042 ± 1%  TOTAL sched_debug.cfs_rq[6]:/.tg_load_avg
      1438 ±22%    +123.8%       3218 ±13%  TOTAL sched_debug.cfs_rq[18]:/.blocked_load_avg
     21389 ± 6%    +124.7%      48064 ± 1%  TOTAL sched_debug.cfs_rq[109]:/.tg_load_avg
      1438 ±22%    +124.0%       3222 ±13%  TOTAL sched_debug.cfs_rq[18]:/.tg_load_contrib
     21612 ± 4%    +124.6%      48541 ± 1%  TOTAL sched_debug.cfs_rq[39]:/.tg_load_avg
       103 ±15%     -56.4%         45 ±32%  TOTAL sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum
     22746 ± 4%    +122.6%      50626 ± 0%  TOTAL sched_debug.cfs_rq[2]:/.tg_load_avg
     22689 ± 4%    +122.6%      50512 ± 0%  TOTAL sched_debug.cfs_rq[1]:/.tg_load_avg
      1498 ±12%    +118.2%       3271 ±16%  TOTAL sched_debug.cfs_rq[33]:/.tg_load_contrib
     21710 ± 5%    +122.1%      48223 ± 1%  TOTAL sched_debug.cfs_rq[45]:/.tg_load_avg
     21675 ± 5%    +123.9%      48522 ± 1%  TOTAL sched_debug.cfs_rq[68]:/.tg_load_avg
     22702 ± 4%    +123.0%      50638 ± 1%  TOTAL sched_debug.cfs_rq[0]:/.tg_load_avg
     21791 ± 5%    +120.8%      48114 ± 1%  TOTAL sched_debug.cfs_rq[47]:/.tg_load_avg
     21768 ± 5%    +122.1%      48352 ± 1%  TOTAL sched_debug.cfs_rq[57]:/.tg_load_avg
     21611 ± 4%    +123.9%      48393 ± 1%  TOTAL sched_debug.cfs_rq[72]:/.tg_load_avg
     21668 ± 4%    +124.2%      48578 ± 1%  TOTAL sched_debug.cfs_rq[38]:/.tg_load_avg
     21661 ± 5%    +123.5%      48416 ± 1%  TOTAL sched_debug.cfs_rq[71]:/.tg_load_avg
     21653 ± 5%    +123.0%      48291 ± 2%  TOTAL sched_debug.cfs_rq[76]:/.tg_load_avg
     21748 ± 5%    +122.7%      48426 ± 1%  TOTAL sched_debug.cfs_rq[62]:/.tg_load_avg
     21770 ± 5%    +121.2%      48162 ± 1%  TOTAL sched_debug.cfs_rq[46]:/.tg_load_avg
     21688 ± 5%    +122.7%      48295 ± 2%  TOTAL sched_debug.cfs_rq[75]:/.tg_load_avg
     21651 ± 5%    +123.5%      48392 ± 1%  TOTAL sched_debug.cfs_rq[74]:/.tg_load_avg
    101524 ± 6%    +122.3%     225684 ± 4%  TOTAL proc-vmstat.pgalloc_dma32
     21758 ± 5%    +122.5%      48417 ± 1%  TOTAL sched_debug.cfs_rq[63]:/.tg_load_avg
     21721 ± 5%    +123.2%      48488 ± 1%  TOTAL sched_debug.cfs_rq[67]:/.tg_load_avg
      2057 ±10%    +137.4%       4885 ±18%  TOTAL sched_debug.cfs_rq[61]:/.blocked_load_avg
     21704 ± 5%    +123.2%      48439 ± 1%  TOTAL sched_debug.cfs_rq[64]:/.tg_load_avg
     21695 ± 5%    +123.2%      48422 ± 1%  TOTAL sched_debug.cfs_rq[70]:/.tg_load_avg
     21706 ± 5%    +123.1%      48428 ± 1%  TOTAL sched_debug.cfs_rq[69]:/.tg_load_avg
     21837 ± 5%    +121.2%      48294 ± 1%  TOTAL sched_debug.cfs_rq[56]:/.tg_load_avg
     21761 ± 4%    +122.3%      48370 ± 1%  TOTAL sched_debug.cfs_rq[61]:/.tg_load_avg
     21769 ± 4%    +123.2%      48581 ± 1%  TOTAL sched_debug.cfs_rq[37]:/.tg_load_avg
     21704 ± 5%    +123.4%      48479 ± 1%  TOTAL sched_debug.cfs_rq[66]:/.tg_load_avg
     21643 ± 5%    +123.5%      48365 ± 1%  TOTAL sched_debug.cfs_rq[73]:/.tg_load_avg
     21693 ± 5%    +123.5%      48480 ± 1%  TOTAL sched_debug.cfs_rq[65]:/.tg_load_avg
      1498 ±12%    +117.5%       3260 ±16%  TOTAL sched_debug.cfs_rq[33]:/.blocked_load_avg
     21762 ± 4%    +122.0%      48313 ± 1%  TOTAL sched_debug.cfs_rq[58]:/.tg_load_avg
     21873 ± 5%    +120.1%      48132 ± 1%  TOTAL sched_debug.cfs_rq[48]:/.tg_load_avg
     21778 ± 4%    +123.3%      48623 ± 1%  TOTAL sched_debug.cfs_rq[36]:/.tg_load_avg
     21887 ± 3%    +122.3%      48647 ± 1%  TOTAL sched_debug.cfs_rq[35]:/.tg_load_avg
     22106 ± 6%    +123.1%      49330 ± 1%  TOTAL sched_debug.cfs_rq[14]:/.tg_load_avg
     21743 ± 5%    +122.5%      48382 ± 1%  TOTAL sched_debug.cfs_rq[60]:/.tg_load_avg
     21761 ± 5%    +122.2%      48362 ± 1%  TOTAL sched_debug.cfs_rq[59]:/.tg_load_avg
     21933 ± 3%    +121.8%      48653 ± 1%  TOTAL sched_debug.cfs_rq[34]:/.tg_load_avg
     22003 ± 3%    +121.9%      48833 ± 1%  TOTAL sched_debug.cfs_rq[29]:/.tg_load_avg
     21927 ± 5%    +119.2%      48069 ± 1%  TOTAL sched_debug.cfs_rq[49]:/.tg_load_avg
     21970 ± 4%    +123.1%      49009 ± 2%  TOTAL sched_debug.cfs_rq[22]:/.tg_load_avg
     21979 ± 5%    +123.1%      49045 ± 1%  TOTAL sched_debug.cfs_rq[21]:/.tg_load_avg
     22033 ± 5%    +123.1%      49153 ± 1%  TOTAL sched_debug.cfs_rq[19]:/.tg_load_avg
     21979 ± 5%    +118.8%      48084 ± 1%  TOTAL sched_debug.cfs_rq[52]:/.tg_load_avg
     22059 ± 3%    +121.2%      48794 ± 1%  TOTAL sched_debug.cfs_rq[28]:/.tg_load_avg
     21984 ± 4%    +122.9%      48996 ± 2%  TOTAL sched_debug.cfs_rq[23]:/.tg_load_avg
     21965 ± 4%    +119.1%      48128 ± 1%  TOTAL sched_debug.cfs_rq[53]:/.tg_load_avg
     22037 ± 3%    +121.4%      48784 ± 1%  TOTAL sched_debug.cfs_rq[30]:/.tg_load_avg
     22069 ± 3%    +121.1%      48793 ± 1%  TOTAL sched_debug.cfs_rq[31]:/.tg_load_avg
     21957 ± 4%    +119.6%      48208 ± 1%  TOTAL sched_debug.cfs_rq[54]:/.tg_load_avg
     21954 ± 5%    +118.8%      48030 ± 1%  TOTAL sched_debug.cfs_rq[50]:/.tg_load_avg
     22117 ± 6%    +122.8%      49277 ± 1%  TOTAL sched_debug.cfs_rq[15]:/.tg_load_avg
     21978 ± 5%    +118.6%      48046 ± 1%  TOTAL sched_debug.cfs_rq[51]:/.tg_load_avg
     21963 ± 4%    +119.7%      48246 ± 1%  TOTAL sched_debug.cfs_rq[55]:/.tg_load_avg
     22012 ± 3%    +121.3%      48712 ± 1%  TOTAL sched_debug.cfs_rq[32]:/.tg_load_avg
     22037 ± 3%    +121.6%      48838 ± 1%  TOTAL sched_debug.cfs_rq[27]:/.tg_load_avg
     22029 ± 3%    +122.0%      48908 ± 1%  TOTAL sched_debug.cfs_rq[26]:/.tg_load_avg
     21990 ± 4%    +122.3%      48891 ± 1%  TOTAL sched_debug.cfs_rq[25]:/.tg_load_avg
     22010 ± 4%    +122.2%      48914 ± 1%  TOTAL sched_debug.cfs_rq[24]:/.tg_load_avg
     21985 ± 3%    +121.4%      48671 ± 1%  TOTAL sched_debug.cfs_rq[33]:/.tg_load_avg
     22023 ± 5%    +122.8%      49058 ± 2%  TOTAL sched_debug.cfs_rq[20]:/.tg_load_avg
     22054 ± 5%    +123.3%      49240 ± 1%  TOTAL sched_debug.cfs_rq[17]:/.tg_load_avg
     22112 ± 6%    +122.7%      49239 ± 1%  TOTAL sched_debug.cfs_rq[16]:/.tg_load_avg
     22058 ± 5%    +122.8%      49137 ± 1%  TOTAL sched_debug.cfs_rq[18]:/.tg_load_avg
      2237 ± 9%    +124.1%       5013 ±18%  TOTAL sched_debug.cfs_rq[61]:/.tg_load_contrib
     15018 ± 5%    +114.2%      32164 ± 0%  TOTAL sched_debug.cpu#61.ttwu_local
     15138 ± 5%    +113.2%      32273 ± 1%  TOTAL sched_debug.cpu#91.ttwu_local
     15141 ± 6%    +116.6%      32798 ± 4%  TOTAL sched_debug.cpu#106.ttwu_local
  13386019 ± 4%    +113.7%   28610387 ± 2%  TOTAL proc-vmstat.pgalloc_normal
  13484197 ± 4%    +113.8%   28830514 ± 2%  TOTAL proc-vmstat.pgfree
     76806 ± 5%    +111.6%     162514 ± 1%  TOTAL sched_debug.cpu#91.nr_switches
     76808 ± 5%    +111.8%     162667 ± 1%  TOTAL sched_debug.cpu#91.sched_count
  13084681 ± 4%    +113.2%   27900527 ± 2%  TOTAL proc-vmstat.numa_local
  13084697 ± 4%    +113.2%   27900563 ± 2%  TOTAL proc-vmstat.numa_hit
     76596 ± 6%    +112.9%     163099 ± 2%  TOTAL sched_debug.cpu#106.nr_switches
     30771 ± 6%    +111.9%      65201 ± 2%  TOTAL sched_debug.cpu#106.sched_goidle
     30881 ± 5%    +110.9%      65122 ± 2%  TOTAL sched_debug.cpu#91.sched_goidle
  18389572 ± 5%    +111.8%   38945748 ± 1%  TOTAL proc-vmstat.pgfault
   3250107 ± 5%    +111.8%    6885051 ± 1%  TOTAL numa-numastat.node1.local_node
   3250110 ± 5%    +111.8%    6885062 ± 1%  TOTAL numa-numastat.node1.numa_hit
   3262764 ± 5%    +115.3%    7024497 ± 4%  TOTAL numa-numastat.node2.numa_hit
   3262758 ± 5%    +115.3%    7024485 ± 4%  TOTAL numa-numastat.node2.local_node
   3279215 ± 4%    +113.9%    7015147 ± 4%  TOTAL numa-numastat.node0.numa_hit
   3279211 ± 4%    +113.9%    7015136 ± 4%  TOTAL numa-numastat.node0.local_node
     76121 ± 4%    +112.9%     162034 ± 1%  TOTAL sched_debug.cpu#61.nr_switches
     77527 ± 6%    +109.0%     162036 ± 1%  TOTAL sched_debug.cpu#61.sched_count
    243.30 ±33%     -51.6%     117.69 ±29%  TOTAL sched_debug.cfs_rq[92]:/.exec_clock
     30594 ± 4%    +112.1%      64904 ± 2%  TOTAL sched_debug.cpu#61.sched_goidle
   3281833 ± 4%    +109.8%    6886537 ± 1%  TOTAL numa-numastat.node3.local_node
   3281836 ± 4%    +109.8%    6886541 ± 1%  TOTAL numa-numastat.node3.numa_hit
     78218 ± 6%    +109.1%     163583 ± 3%  TOTAL sched_debug.cpu#106.sched_count
   1727502 ± 6%    +107.5%    3583823 ± 4%  TOTAL numa-vmstat.node2.numa_local
   1742994 ± 5%    +103.7%    3550217 ± 1%  TOTAL numa-vmstat.node3.numa_local
   1794367 ± 5%    +101.6%    3617858 ± 1%  TOTAL numa-vmstat.node1.numa_local
   1810000 ± 5%    +102.6%    3666376 ± 3%  TOTAL numa-vmstat.node2.numa_hit
   1825404 ± 5%     +99.0%    3632638 ± 1%  TOTAL numa-vmstat.node3.numa_hit
   1816414 ± 5%    +101.8%    3666109 ± 3%  TOTAL numa-vmstat.node0.numa_local
   1843627 ± 6%    +100.6%    3698703 ± 1%  TOTAL numa-vmstat.node1.numa_hit
      3135 ±12%     -46.7%       1672 ±15%  TOTAL sched_debug.cpu#34.ttwu_local
   1849929 ± 4%     +98.3%    3668167 ± 3%  TOTAL numa-vmstat.node0.numa_hit
      8992 ±13%     -50.9%       4418 ±41%  TOTAL sched_debug.cpu#30.sched_count
    241.28 ±24%     -40.6%     143.43 ±25%  TOTAL sched_debug.cfs_rq[11]:/.exec_clock
     18020 ±39%     -55.2%       8066 ±16%  TOTAL sched_debug.cpu#4.ttwu_count
       319 ±22%     +61.6%        516 ±13%  TOTAL cpuidle.C1E-IVT-4S.usage
      4156 ±15%     -47.6%       2176 ±41%  TOTAL sched_debug.cpu#30.sched_goidle
      8343 ±15%     -47.6%       4375 ±41%  TOTAL sched_debug.cpu#30.nr_switches
     29165 ± 1%     +76.4%      51461 ± 3%  TOTAL sched_debug.cpu#106.ttwu_count
     28980 ± 2%     +73.4%      50247 ± 1%  TOTAL sched_debug.cpu#61.ttwu_count
     29138 ± 1%     +74.5%      50853 ± 1%  TOTAL sched_debug.cpu#91.ttwu_count
     22537 ± 8%     +70.7%      38465 ±19%  TOTAL sched_debug.cpu#47.ttwu_count
      1641 ± 3%     +67.9%       2757 ± 1%  TOTAL proc-vmstat.pgactivate
       131 ±19%     -37.4%         82 ± 5%  TOTAL sched_debug.cpu#106.cpu_load[4]
     13130 ± 2%     +62.4%      21321 ± 8%  TOTAL sched_debug.cpu#47.sched_goidle
      7089 ±13%     +54.9%      10979 ±11%  TOTAL sched_debug.cpu#20.sched_goidle
     26562 ± 2%     +61.5%      42903 ± 7%  TOTAL sched_debug.cpu#47.nr_switches
     14233 ±13%     +54.5%      21991 ±11%  TOTAL sched_debug.cpu#20.nr_switches
        88 ±17%     +54.3%        135 ±25%  TOTAL sched_debug.cpu#107.ttwu_local
      4777 ±12%     +54.7%       7389 ±14%  TOTAL sched_debug.cfs_rq[34]:/.min_vruntime
       119 ±12%     -32.7%         80 ± 8%  TOTAL sched_debug.cpu#61.cpu_load[4]
       149 ±17%     -33.5%         99 ± 9%  TOTAL sched_debug.cpu#106.cpu_load[3]
     11071 ±17%     -26.7%       8120 ±22%  TOTAL sched_debug.cpu#34.ttwu_count
      3831 ± 6%     +42.6%       5463 ± 7%  TOTAL numa-meminfo.node2.KernelStack
      1712 ±11%     -43.0%        975 ±22%  TOTAL sched_debug.cpu#1.ttwu_local
       239 ± 6%     +41.7%        339 ± 7%  TOTAL numa-vmstat.node2.nr_kernel_stack
      3638 ±24%     -32.8%       2443 ±32%  TOTAL sched_debug.cpu#1.ttwu_count
       135 ± 7%     -37.0%         85 ±11%  TOTAL sched_debug.cpu#91.cpu_load[4]
      5131 ±18%     -21.3%       4038 ± 5%  TOTAL meminfo.AnonHugePages
       227 ±12%     -28.6%        162 ±18%  TOTAL sched_debug.cpu#91.cpu_load[0]
     66199 ± 6%     +49.7%      99076 ± 1%  TOTAL sched_debug.cpu#106.nr_load_updates
     31880 ± 6%     +41.2%      45012 ±10%  TOTAL sched_debug.cpu#47.sched_count
     13581 ± 3%     +47.7%      20066 ± 5%  TOTAL sched_debug.cpu#32.sched_goidle
     29309 ±12%     +41.2%      41372 ± 9%  TOTAL sched_debug.cpu#32.sched_count
     69667 ± 4%     +42.5%      99307 ± 1%  TOTAL sched_debug.cpu#91.nr_load_updates
       160 ±15%     -26.9%        117 ±18%  TOTAL sched_debug.cfs_rq[61]:/.load
     27436 ± 3%     +47.3%      40401 ± 5%  TOTAL sched_debug.cpu#32.nr_switches
     70549 ± 4%     +41.8%     100061 ± 1%  TOTAL sched_debug.cpu#61.nr_load_updates
     13693 ± 5%     +48.4%      20325 ± 6%  TOTAL sched_debug.cpu#17.sched_goidle
      3973 ± 6%     +41.4%       5619 ± 6%  TOTAL numa-meminfo.node3.KernelStack
     27719 ± 5%     +47.9%      40984 ± 6%  TOTAL sched_debug.cpu#17.nr_switches
       248 ± 6%     +40.7%        349 ± 6%  TOTAL numa-vmstat.node3.nr_kernel_stack
      6508 ± 1%     +49.1%       9705 ±22%  TOTAL sched_debug.cpu#35.sched_goidle
       138 ±14%     -27.4%        100 ±10%  TOTAL sched_debug.cpu#61.cpu_load[3]
     13073 ± 2%     +48.7%      19438 ±22%  TOTAL sched_debug.cpu#35.nr_switches
       666 ±14%     +50.7%       1004 ±17%  TOTAL cpuidle.C3-IVT-4S.usage
        80 ±33%     -45.9%         43 ±34%  TOTAL sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum
     19457 ± 7%     +31.6%      25610 ± 7%  TOTAL sched_debug.cpu#47.nr_load_updates
     21711 ±13%     +45.4%      31570 ±19%  TOTAL sched_debug.cpu#17.ttwu_count
     13418 ± 3%     +45.3%      19492 ±22%  TOTAL sched_debug.cpu#35.sched_count
     22622 ± 5%     +37.5%      31103 ±15%  TOTAL sched_debug.cpu#32.ttwu_count
        21 ± 9%     -19.6%         17 ±12%  TOTAL sched_debug.cpu#99.ttwu_local
       191 ±12%     -25.1%        143 ±10%  TOTAL sched_debug.cpu#91.cpu_load[1]
       154 ± 9%     -31.6%        105 ±11%  TOTAL sched_debug.cpu#91.cpu_load[3]
       160 ±15%     -27.2%        116 ±14%  TOTAL sched_debug.cpu#106.cpu_load[2]
     15464 ±15%     +43.3%      22163 ±11%  TOTAL sched_debug.cpu#20.sched_count
       176 ±14%     -24.4%        133 ±23%  TOTAL sched_debug.cpu#106.cpu_load[1]
       169 ±10%     -25.2%        126 ±10%  TOTAL sched_debug.cpu#91.cpu_load[2]
        20 ±10%     -15.5%         17 ± 8%  TOTAL sched_debug.cpu#74.ttwu_local
     87151 ±17%     +34.6%     117307 ± 3%  TOTAL sched_debug.cfs_rq[106]:/.spread0
     23131 ± 9%     -20.8%      18314 ±12%  TOTAL sched_debug.cpu#33.ttwu_count
      9097 ±11%     -23.5%       6955 ± 8%  TOTAL sched_debug.cfs_rq[0]:/.exec_clock
      1485 ± 2%     +25.6%       1866 ± 7%  TOTAL proc-vmstat.nr_kernel_stack
      1788 ± 2%     -20.6%       1419 ± 0%  TOTAL sched_debug.cfs_rq[106]:/.tg->runnable_avg
      1810 ± 2%     -20.6%       1436 ± 0%  TOTAL sched_debug.cfs_rq[119]:/.tg->runnable_avg
      1809 ± 2%     -20.7%       1435 ± 0%  TOTAL sched_debug.cfs_rq[118]:/.tg->runnable_avg
      1784 ± 2%     -20.6%       1417 ± 0%  TOTAL sched_debug.cfs_rq[105]:/.tg->runnable_avg
      1798 ± 2%     -20.7%       1426 ± 0%  TOTAL sched_debug.cfs_rq[111]:/.tg->runnable_avg
      1803 ± 2%     -20.5%       1433 ± 0%  TOTAL sched_debug.cfs_rq[115]:/.tg->runnable_avg
      1801 ± 2%     -20.5%       1431 ± 0%  TOTAL sched_debug.cfs_rq[114]:/.tg->runnable_avg
      1790 ± 2%     -20.6%       1421 ± 0%  TOTAL sched_debug.cfs_rq[107]:/.tg->runnable_avg
      1799 ± 2%     -20.6%       1428 ± 0%  TOTAL sched_debug.cfs_rq[112]:/.tg->runnable_avg
      1792 ± 2%     -20.6%       1423 ± 0%  TOTAL sched_debug.cfs_rq[108]:/.tg->runnable_avg
      1782 ± 2%     -20.5%       1415 ± 0%  TOTAL sched_debug.cfs_rq[104]:/.tg->runnable_avg
      1800 ± 2%     -20.6%       1430 ± 0%  TOTAL sched_debug.cfs_rq[113]:/.tg->runnable_avg
      1805 ± 2%     -20.6%       1434 ± 0%  TOTAL sched_debug.cfs_rq[116]:/.tg->runnable_avg
      1806 ± 2%     -20.6%       1435 ± 0%  TOTAL sched_debug.cfs_rq[117]:/.tg->runnable_avg
      1795 ± 2%     -20.7%       1424 ± 0%  TOTAL sched_debug.cfs_rq[109]:/.tg->runnable_avg
     95310 ± 4%     +23.7%     117875 ± 2%  TOTAL sched_debug.cfs_rq[91]:/.spread0
      1796 ± 2%     -20.7%       1425 ± 0%  TOTAL sched_debug.cfs_rq[110]:/.tg->runnable_avg
      1778 ± 2%     -20.5%       1414 ± 0%  TOTAL sched_debug.cfs_rq[103]:/.tg->runnable_avg
      1771 ± 2%     -20.3%       1411 ± 0%  TOTAL sched_debug.cfs_rq[100]:/.tg->runnable_avg
      1772 ± 2%     -20.3%       1413 ± 0%  TOTAL sched_debug.cfs_rq[101]:/.tg->runnable_avg
      1768 ± 2%     -20.3%       1410 ± 0%  TOTAL sched_debug.cfs_rq[99]:/.tg->runnable_avg
      1774 ± 2%     -20.3%       1413 ± 0%  TOTAL sched_debug.cfs_rq[102]:/.tg->runnable_avg
     97534 ± 4%     +21.8%     118768 ± 5%  TOTAL sched_debug.cfs_rq[61]:/.spread0
      1766 ± 2%     -20.2%       1408 ± 0%  TOTAL sched_debug.cfs_rq[98]:/.tg->runnable_avg
      1762 ± 2%     -20.1%       1407 ± 0%  TOTAL sched_debug.cfs_rq[97]:/.tg->runnable_avg
      1760 ± 2%     -20.1%       1405 ± 0%  TOTAL sched_debug.cfs_rq[96]:/.tg->runnable_avg
      1756 ± 2%     -20.0%       1405 ± 0%  TOTAL sched_debug.cfs_rq[95]:/.tg->runnable_avg
      1747 ± 2%     -19.8%       1400 ± 0%  TOTAL sched_debug.cfs_rq[92]:/.tg->runnable_avg
      1753 ± 2%     -19.9%       1404 ± 0%  TOTAL sched_debug.cfs_rq[94]:/.tg->runnable_avg
      1751 ± 2%     -19.9%       1402 ± 0%  TOTAL sched_debug.cfs_rq[93]:/.tg->runnable_avg
      1743 ± 2%     -19.8%       1398 ± 0%  TOTAL sched_debug.cfs_rq[91]:/.tg->runnable_avg
     23871 ± 2%     +24.3%      29667 ± 8%  TOTAL meminfo.KernelStack
      1739 ± 2%     -19.7%       1397 ± 0%  TOTAL sched_debug.cfs_rq[90]:/.tg->runnable_avg
      1734 ± 2%     -19.6%       1395 ± 0%  TOTAL sched_debug.cfs_rq[89]:/.tg->runnable_avg
      1729 ± 2%     -19.4%       1394 ± 0%  TOTAL sched_debug.cfs_rq[88]:/.tg->runnable_avg
      1725 ± 2%     -19.3%       1392 ± 0%  TOTAL sched_debug.cfs_rq[87]:/.tg->runnable_avg
      1724 ± 2%     -19.3%       1390 ± 0%  TOTAL sched_debug.cfs_rq[86]:/.tg->runnable_avg
      1721 ± 2%     -19.3%       1389 ± 0%  TOTAL sched_debug.cfs_rq[85]:/.tg->runnable_avg
      1718 ± 2%     -19.2%       1388 ± 0%  TOTAL sched_debug.cfs_rq[84]:/.tg->runnable_avg
    102757 ±13%     +28.2%     131768 ± 3%  TOTAL sched_debug.cfs_rq[106]:/.min_vruntime
      1699 ± 2%     -19.0%       1376 ± 0%  TOTAL sched_debug.cfs_rq[77]:/.tg->runnable_avg
      1701 ± 2%     -19.0%       1378 ± 0%  TOTAL sched_debug.cfs_rq[78]:/.tg->runnable_avg
      1692 ± 2%     -18.9%       1373 ± 0%  TOTAL sched_debug.cfs_rq[75]:/.tg->runnable_avg
      1695 ± 2%     -19.0%       1373 ± 0%  TOTAL sched_debug.cfs_rq[76]:/.tg->runnable_avg
      1715 ± 2%     -19.1%       1387 ± 0%  TOTAL sched_debug.cfs_rq[83]:/.tg->runnable_avg
     21038 ± 5%     +20.1%      25263 ± 5%  TOTAL sched_debug.cpu#17.nr_load_updates
      1683 ± 2%     -18.8%       1367 ± 0%  TOTAL sched_debug.cfs_rq[71]:/.tg->runnable_avg
      1709 ± 2%     -18.9%       1385 ± 0%  TOTAL sched_debug.cfs_rq[82]:/.tg->runnable_avg
      1701 ± 2%     -18.9%       1379 ± 0%  TOTAL sched_debug.cfs_rq[79]:/.tg->runnable_avg
      1686 ± 2%     -18.8%       1369 ± 0%  TOTAL sched_debug.cfs_rq[73]:/.tg->runnable_avg
      1681 ± 2%     -18.8%       1365 ± 0%  TOTAL sched_debug.cfs_rq[70]:/.tg->runnable_avg
      1705 ± 2%     -18.9%       1382 ± 0%  TOTAL sched_debug.cfs_rq[80]:/.tg->runnable_avg
      1683 ± 2%     -18.7%       1368 ± 0%  TOTAL sched_debug.cfs_rq[72]:/.tg->runnable_avg
      1672 ± 2%     -18.5%       1362 ± 0%  TOTAL sched_debug.cfs_rq[67]:/.tg->runnable_avg
      1688 ± 2%     -18.8%       1371 ± 0%  TOTAL sched_debug.cfs_rq[74]:/.tg->runnable_avg
      1663 ± 2%     -18.5%       1356 ± 0%  TOTAL sched_debug.cfs_rq[63]:/.tg->runnable_avg
      1679 ± 2%     -18.7%       1364 ± 0%  TOTAL sched_debug.cfs_rq[69]:/.tg->runnable_avg
      1670 ± 2%     -18.5%       1362 ± 0%  TOTAL sched_debug.cfs_rq[66]:/.tg->runnable_avg
      1675 ± 2%     -18.6%       1363 ± 0%  TOTAL sched_debug.cfs_rq[68]:/.tg->runnable_avg
      1665 ± 2%     -18.5%       1357 ± 0%  TOTAL sched_debug.cfs_rq[64]:/.tg->runnable_avg
      1707 ± 2%     -18.9%       1384 ± 0%  TOTAL sched_debug.cfs_rq[81]:/.tg->runnable_avg
      1667 ± 2%     -18.5%       1359 ± 0%  TOTAL sched_debug.cfs_rq[65]:/.tg->runnable_avg
       152 ±14%     -18.9%        123 ±12%  TOTAL sched_debug.cpu#61.cpu_load[2]
      1658 ± 2%     -18.3%       1355 ± 0%  TOTAL sched_debug.cfs_rq[62]:/.tg->runnable_avg
      1652 ± 2%     -18.1%       1353 ± 0%  TOTAL sched_debug.cfs_rq[61]:/.tg->runnable_avg
      1650 ± 2%     -18.0%       1352 ± 0%  TOTAL sched_debug.cfs_rq[60]:/.tg->runnable_avg
      1643 ± 2%     -17.9%       1348 ± 0%  TOTAL sched_debug.cfs_rq[57]:/.tg->runnable_avg
    113140 ± 4%     +17.8%     133227 ± 5%  TOTAL sched_debug.cfs_rq[61]:/.min_vruntime
      1648 ± 2%     -18.0%       1351 ± 0%  TOTAL sched_debug.cfs_rq[59]:/.tg->runnable_avg
    110916 ± 4%     +19.3%     132335 ± 2%  TOTAL sched_debug.cfs_rq[91]:/.min_vruntime
      1625 ± 1%     -17.2%       1346 ± 0%  TOTAL sched_debug.cfs_rq[55]:/.tg->runnable_avg
      1638 ± 2%     -17.8%       1347 ± 0%  TOTAL sched_debug.cfs_rq[56]:/.tg->runnable_avg
      1646 ± 2%     -17.9%       1350 ± 0%  TOTAL sched_debug.cfs_rq[58]:/.tg->runnable_avg
      1615 ± 1%     -17.0%       1340 ± 0%  TOTAL sched_debug.cfs_rq[51]:/.tg->runnable_avg
      1616 ± 1%     -17.0%       1341 ± 0%  TOTAL sched_debug.cfs_rq[52]:/.tg->runnable_avg
      1620 ± 1%     -17.1%       1343 ± 0%  TOTAL sched_debug.cfs_rq[53]:/.tg->runnable_avg
      1611 ± 1%     -17.0%       1337 ± 0%  TOTAL sched_debug.cfs_rq[50]:/.tg->runnable_avg
      1622 ± 1%     -17.1%       1345 ± 0%  TOTAL sched_debug.cfs_rq[54]:/.tg->runnable_avg
      1605 ± 1%     -16.8%       1335 ± 0%  TOTAL sched_debug.cfs_rq[49]:/.tg->runnable_avg
      1601 ± 1%     -16.9%       1331 ± 0%  TOTAL sched_debug.cfs_rq[48]:/.tg->runnable_avg
     14782 ± 5%     -18.7%      12017 ± 7%  TOTAL sched_debug.cfs_rq[91]:/.avg->runnable_avg_sum
      1595 ± 1%     -16.8%       1327 ± 0%  TOTAL sched_debug.cfs_rq[47]:/.tg->runnable_avg
       321 ± 5%     -18.9%        260 ± 7%  TOTAL sched_debug.cfs_rq[91]:/.tg_runnable_contrib
     17810 ±34%     +39.1%      24766 ± 4%  TOTAL sched_debug.cpu#2.nr_load_updates
      1590 ± 1%     -16.6%       1326 ± 0%  TOTAL sched_debug.cfs_rq[46]:/.tg->runnable_avg
      1587 ± 1%     -16.5%       1324 ± 0%  TOTAL sched_debug.cfs_rq[45]:/.tg->runnable_avg
      1581 ± 1%     -16.3%       1323 ± 0%  TOTAL sched_debug.cfs_rq[44]:/.tg->runnable_avg
     20364 ± 6%     +21.0%      24646 ± 5%  TOTAL sched_debug.cpu#32.nr_load_updates
     23451 ±11%     +16.0%      27201 ±10%  TOTAL sched_debug.cpu#18.nr_load_updates
      1576 ± 1%     -16.1%       1322 ± 0%  TOTAL sched_debug.cfs_rq[43]:/.tg->runnable_avg
      4393 ± 3%     +17.0%       5138 ± 2%  TOTAL slabinfo.signal_cache.num_objs
      1573 ± 1%     -16.0%       1321 ± 0%  TOTAL sched_debug.cfs_rq[42]:/.tg->runnable_avg
      1568 ± 1%     -15.9%       1319 ± 0%  TOTAL sched_debug.cfs_rq[41]:/.tg->runnable_avg
      1564 ± 1%     -15.7%       1318 ± 0%  TOTAL sched_debug.cfs_rq[40]:/.tg->runnable_avg
       296 ± 4%     -14.6%        253 ± 4%  TOTAL sched_debug.cfs_rq[61]:/.tg_runnable_contrib
      1560 ± 1%     -15.5%       1318 ± 0%  TOTAL sched_debug.cfs_rq[39]:/.tg->runnable_avg
      1554 ± 1%     -15.3%       1317 ± 0%  TOTAL sched_debug.cfs_rq[38]:/.tg->runnable_avg
     13680 ± 3%     -14.7%      11667 ± 4%  TOTAL sched_debug.cfs_rq[61]:/.avg->runnable_avg_sum
      1544 ± 1%     -14.8%       1315 ± 0%  TOTAL sched_debug.cfs_rq[37]:/.tg->runnable_avg
      3309 ± 5%     -17.4%       2734 ± 2%  TOTAL sched_debug.cfs_rq[32]:/.exec_clock
      1534 ± 1%     -14.6%       1310 ± 0%  TOTAL sched_debug.cfs_rq[34]:/.tg->runnable_avg
      1537 ± 1%     -14.6%       1312 ± 0%  TOTAL sched_debug.cfs_rq[35]:/.tg->runnable_avg
      1540 ± 1%     -14.7%       1314 ± 0%  TOTAL sched_debug.cfs_rq[36]:/.tg->runnable_avg
       553 ±43%     +59.0%        879 ± 3%  TOTAL numa-vmstat.node0.nr_kernel_stack
      1530 ± 1%     -14.5%       1308 ± 0%  TOTAL sched_debug.cfs_rq[33]:/.tg->runnable_avg
      1523 ± 1%     -14.3%       1306 ± 0%  TOTAL sched_debug.cfs_rq[32]:/.tg->runnable_avg
      8851 ±43%     +59.3%      14097 ± 3%  TOTAL numa-meminfo.node0.KernelStack
      1519 ± 1%     -14.1%       1306 ± 0%  TOTAL sched_debug.cfs_rq[31]:/.tg->runnable_avg
      1516 ± 1%     -14.0%       1304 ± 0%  TOTAL sched_debug.cfs_rq[30]:/.tg->runnable_avg
      1510 ± 1%     -14.0%       1300 ± 0%  TOTAL sched_debug.cfs_rq[28]:/.tg->runnable_avg
      1513 ± 1%     -14.0%       1302 ± 0%  TOTAL sched_debug.cfs_rq[29]:/.tg->runnable_avg
      1507 ± 1%     -13.9%       1297 ± 0%  TOTAL sched_debug.cfs_rq[27]:/.tg->runnable_avg
      1504 ± 1%     -13.8%       1296 ± 0%  TOTAL sched_debug.cfs_rq[26]:/.tg->runnable_avg
      1496 ± 1%     -13.6%       1293 ± 0%  TOTAL sched_debug.cfs_rq[24]:/.tg->runnable_avg
      1492 ± 1%     -13.5%       1292 ± 0%  TOTAL sched_debug.cfs_rq[23]:/.tg->runnable_avg
      1499 ± 1%     -13.6%       1295 ± 0%  TOTAL sched_debug.cfs_rq[25]:/.tg->runnable_avg
    795010 ± 3%     -10.6%     710653 ± 6%  TOTAL sched_debug.cpu#32.avg_idle
      1489 ± 1%     -13.3%       1291 ± 0%  TOTAL sched_debug.cfs_rq[22]:/.tg->runnable_avg
      1467 ± 1%     -12.9%       1278 ± 0%  TOTAL sched_debug.cfs_rq[17]:/.tg->runnable_avg
      1485 ± 1%     -13.2%       1290 ± 0%  TOTAL sched_debug.cfs_rq[21]:/.tg->runnable_avg
      1463 ± 1%     -12.8%       1276 ± 0%  TOTAL sched_debug.cfs_rq[16]:/.tg->runnable_avg
      1027 ± 6%     +16.2%       1194 ± 4%  TOTAL slabinfo.kmalloc-192.active_slabs
      1027 ± 6%     +16.2%       1194 ± 4%  TOTAL slabinfo.kmalloc-192.num_slabs
     43031 ± 6%     +16.3%      50041 ± 4%  TOTAL slabinfo.kmalloc-192.active_objs
     43170 ± 6%     +16.2%      50161 ± 4%  TOTAL slabinfo.kmalloc-192.num_objs
      1472 ± 1%     -12.9%       1282 ± 0%  TOTAL sched_debug.cfs_rq[18]:/.tg->runnable_avg
      1479 ± 1%     -13.0%       1287 ± 0%  TOTAL sched_debug.cfs_rq[20]:/.tg->runnable_avg
      1456 ± 1%     -12.5%       1273 ± 0%  TOTAL sched_debug.cfs_rq[15]:/.tg->runnable_avg
      1452 ± 1%     -12.3%       1273 ± 0%  TOTAL sched_debug.cfs_rq[14]:/.tg->runnable_avg
       862 ± 8%     -12.9%        750 ± 5%  TOTAL slabinfo.RAW.num_objs
       862 ± 8%     -12.9%        750 ± 5%  TOTAL slabinfo.RAW.active_objs
      1475 ± 1%     -12.9%       1284 ± 0%  TOTAL sched_debug.cfs_rq[19]:/.tg->runnable_avg
      4393 ± 3%     +14.5%       5028 ± 2%  TOTAL slabinfo.signal_cache.active_objs
      1446 ± 1%     -12.1%       1272 ± 0%  TOTAL sched_debug.cfs_rq[12]:/.tg->runnable_avg
      1448 ± 1%     -12.1%       1273 ± 0%  TOTAL sched_debug.cfs_rq[13]:/.tg->runnable_avg
      1442 ± 1%     -11.9%       1271 ± 0%  TOTAL sched_debug.cfs_rq[11]:/.tg->runnable_avg
      1439 ± 1%     -11.7%       1271 ± 0%  TOTAL sched_debug.cfs_rq[10]:/.tg->runnable_avg
      1437 ± 1%     -11.5%       1271 ± 0%  TOTAL sched_debug.cfs_rq[9]:/.tg->runnable_avg
      1431 ± 1%     -11.2%       1270 ± 0%  TOTAL sched_debug.cfs_rq[8]:/.tg->runnable_avg
      1428 ± 1%     -11.1%       1269 ± 0%  TOTAL sched_debug.cfs_rq[7]:/.tg->runnable_avg
      1423 ± 1%     -10.8%       1270 ± 0%  TOTAL sched_debug.cfs_rq[6]:/.tg->runnable_avg
      1421 ± 1%     -10.6%       1270 ± 0%  TOTAL sched_debug.cfs_rq[5]:/.tg->runnable_avg
      1418 ± 1%     -10.5%       1269 ± 0%  TOTAL sched_debug.cfs_rq[4]:/.tg->runnable_avg
      1417 ± 1%     -10.5%       1268 ± 0%  TOTAL sched_debug.cfs_rq[3]:/.tg->runnable_avg
      5041 ± 4%     +12.8%       5687 ± 1%  TOTAL slabinfo.task_xstate.active_objs
      5041 ± 4%     +12.8%       5687 ± 1%  TOTAL slabinfo.task_xstate.num_objs
        20 ±18%     -18.6%         16 ± 2%  TOTAL sched_debug.cpu#104.ttwu_local
     83828 ± 1%      +9.4%      91675 ± 3%  TOTAL slabinfo.kmalloc-64.active_objs
      1406 ± 1%     -10.1%       1264 ± 0%  TOTAL sched_debug.cfs_rq[2]:/.tg->runnable_avg
      1404 ± 1%     -10.1%       1262 ± 0%  TOTAL sched_debug.cfs_rq[1]:/.tg->runnable_avg
    109592 ± 4%      +6.3%     116546 ± 2%  TOTAL numa-meminfo.node1.FilePages
     27397 ± 4%      +6.3%      29136 ± 2%  TOTAL numa-vmstat.node1.nr_file_pages
        36 ± 2%      +8.3%         39 ± 2%  TOTAL turbostat.CTMP
      1382 ± 1%      -9.2%       1255 ± 0%  TOTAL sched_debug.cfs_rq[0]:/.tg->runnable_avg
     52240 ± 5%      +8.9%      56888 ± 4%  TOTAL numa-meminfo.node0.Slab
     31564 ± 7%     +14.9%      36254 ± 5%  TOTAL numa-meminfo.node1.Active
      1331 ± 0%      +8.1%       1439 ± 3%  TOTAL slabinfo.kmalloc-64.active_slabs
      1331 ± 0%      +8.1%       1439 ± 3%  TOTAL slabinfo.kmalloc-64.num_slabs
     85255 ± 0%      +8.1%      92172 ± 3%  TOTAL slabinfo.kmalloc-64.num_objs
    217201 ± 5%    +125.5%     489860 ± 0%  TOTAL time.voluntary_context_switches
  17206167 ± 5%    +118.8%   37639010 ± 1%  TOTAL time.minor_page_faults
    115930 ± 5%    +116.5%     251005 ± 1%  TOTAL time.involuntary_context_switches
      0.00 ± 9%    +121.4%       0.00 ±10%  TOTAL energy.energy-cores
      0.00 ± 1%     +63.6%       0.00 ± 0%  TOTAL energy.energy-ram
      0.00 ± 3%     +51.6%       0.00 ± 5%  TOTAL energy.energy-pkg
      7352 ± 1%     +39.9%      10285 ± 0%  TOTAL vmstat.system.cs
     89.70 ± 0%     -14.0%      77.11 ± 1%  TOTAL time.user_time
      1.06 ± 0%     -12.9%       0.92 ± 0%  TOTAL turbostat.%c0
       214 ± 0%      +5.9%        227 ± 0%  TOTAL time.system_time


                                 time.user_time

  95 ++---------------------------------------------------------------------+
     |                *..                                                   |
     |               :   *..  .*.                                           |
  90 *+.*..*..*.*..  :      *.   *..*..*..*..*                              |
     |              :                                                       |
     |             *                                                        |
  85 ++                                                                     |
     |                                                                      |
  80 ++                                                                     |
     |          O                                                     O     |
     |  O  O  O    O                                             O          O
  75 O+               O     O    O     O                   O  O    O     O  |
     |                   O     O    O     O  O  O O  O  O                   |
     |                                                                      |
  70 ++---------------------------------------------------------------------+


                                 time.system_time

  235 ++--------------------------------------------------------------------+
      |                                                                     |
      |                        O                                            |
  230 ++                          O  O  O O  O  O  O  O O                   |
      O                   O O                              O  O     O    O  |
      |  O  O O     O  O                                         O    O     O
  225 ++         O                                                          |
      |                                                                     |
  220 ++                                                                    |
      |                                                                     |
      |             *                                                       |
  215 ++           + :           .*..                                       |
      |           +   :   *.*..*.    *..*.*..*                              |
      *..*..*.*..*    : ..                                                  |
  210 ++---------------*----------------------------------------------------+


                           time.voluntary_context_switches

  500000 ++------------------------------------------------------O--O--O----O
         |                                                               O  |
  450000 ++                                                    O            |
         |                    O                             O               |
  400000 ++                 O    O  O O  O  O  O O  O  O O                  |
         |  O       O                                                       |
  350000 O+   O  O    O  O                                                  |
         |                                                                  |
  300000 ++                                                                 |
         |                                                                  |
  250000 ++                                                                 |
         *..*.*..*..*.          .*..*.     .*..                             |
  200000 ++           *..*..*.*.      *..*.    *                            |
         |                                                                  |
  150000 ++-----------------------------------------------------------------+


                                  energy.energy-cores

  2.5e-08 ++----------------------------------------------------------------+
          |                                                            O    |
          |                                                                 |
    2e-08 ++                                                                |
          |                                                      O  O    O  O
          |                                                    O            |
  1.5e-08 ++                   O                                            |
          |  O       O                    O                 O               |
    1e-08 O+   O  O    O  O O     O O  O    O  O  O O  O  O                 |
          |            *..*.*..*..*.*..*..*.*..*                            |
          |            :                                                    |
    5e-09 ++          :                                                     |
          |           :                                                     |
          |          :                                                      |
        0 *+-*-*--*--*------------------------------------------------------+


                                   energy.energy-pkg

    4e-08 ++----------------------------------------------------------------+
          |                                                            O    |
  3.5e-08 ++                                                                O
          |                                                    O O  O    O  |
    3e-08 ++                   O                                            |
  2.5e-08 ++ O       O      O     O O  O  O O  O  O O  O  O O               |
          O    O  O    O..O.*..*..*.*..*..*.*..*                            |
    2e-08 ++           :                                                    |
          |            :                                                    |
  1.5e-08 ++          :                                                     |
    1e-08 ++          :                                                     |
          |           :                                                     |
    5e-09 ++          :                                                     |
          |          :                                                      |
        0 *+-*-*--*--*------------------------------------------------------+


                           aim9.shell_rtns_3.ops_per_sec

  300 ++--------------------------------------------------------------------+
  280 ++                                                              O     |
      |                                                          O  O    O  O
  260 ++                                                      O             |
  240 ++                    O                              O                |
      |                   O    O  O  O  O O  O  O  O  O O                   |
  220 ++ O       O                                                          |
  200 O+    O O     O  O                                                    |
  180 ++                                                                    |
      |                                                                     |
  160 ++                                                                    |
  140 ++                                                                    |
      |                  .*.*..*..*..*..*.*..*                              |
  120 *+.*..*.*..*..*..*.                                                   |
  100 ++--------------------------------------------------------------------+


                                   turbostat.%c0

  1.12 ++-------------------------------------------------------------------+
   1.1 ++                 *..*                                              |
       |                 +    +                                             |
  1.08 ++   .*.        .*      +                                            |
  1.06 *+.*.   *..*..*.         *..*.*..*..*..*                             |
  1.04 ++                                                                   |
  1.02 ++                                                                   |
       |                                                                    |
     1 ++                                                                   |
  0.98 O+    O       O  O O          O                                      |
  0.96 ++ O    O  O          O  O  O    O  O  O O  O  O  O                  |
  0.94 ++                                                  O  O             |
       |                                                              O     |
  0.92 ++                                                        O  O    O  O
   0.9 ++-------------------------------------------------------------------+


                                  turbostat.Pkg_W

  170 ++--------------------------------------------------------------------+
      |                                                               O     |
  160 ++                                                                    |
  150 ++                                                                    |
      |                                                                     O
  140 ++                                                         O  O    O  |
      |                                                                     |
  130 ++                                                      O             |
      |                     O                                               |
  120 ++                                                                    |
  110 ++ O       O                      O                  O                |
      O     O O     O  O  O    O  O  O    O  O  O  O  O O                   |
  100 ++                                                                    |
      *..*..*.*..*..*..*..*.*..*..*..*..*.*..*                              |
   90 ++--------------------------------------------------------------------+


                                  turbostat.Cor_W

  100 ++--------------------------------------------------------------O-----+
      |                                                                     |
   90 ++                                                                    |
      |                                                                     |
   80 ++                                                                    O
      |                                                          O  O    O  |
   70 ++                                                      O             |
      |                     O                                               |
   60 ++                                                                    |
      |  O                                                                  |
   50 ++         O        O    O  O  O  O O  O  O  O  O O  O                |
      O     O O     O  O                                                    |
   40 ++                                                                    |
      *..*..*.*..*..*..*..*.*..*..*..*..*.*..*                              |
   30 ++--------------------------------------------------------------------+

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

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: aim9
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
model: Brickland Ivy Bridge-EX
nr_cpu: 120
memory: 512G
hdd_partitions: 
swap_partitions: 
aim9:
  testtime: 300s
  test:
  - shell_rtns_3
branch: linus/master
commit: 19583ca584d6f574384e17fe7613dfaeadcdc4a6
repeat_to: 3
enqueue_time: 2014-09-25 21:56:15.069539322 +08:00
testbox: brickland3
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/vmlinuz-3.16.0"
user: lkp
queue: wfg
result_root: "/result/brickland3/aim9/300s-shell_rtns_3/debian-x86_64.cgz/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/0"
job_file: "/lkp/scheduled/brickland3/wfg_aim9-300s-shell_rtns_3-x86_64-rhel-19583ca584d6f574384e17fe7613dfaeadcdc4a6-2.yaml"
dequeue_time: 2014-09-30 11:42:21.894696145 +08:00
history_time: 348.87
job_state: finished
loadavg: 0.84 0.66 0.31 1/967 52904
start_time: '1412048625'
end_time: '1412048925'
version: "/lkp/lkp/.src-20140929-152043"

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--NzB8fVQJ5HfG6fxh--
