Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaHEV3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:29:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:19573 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaHEV3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,807,1400050800"; 
   d="scan'208";a="572188863"
Date: Wed, 6 Aug 2014 05:29:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [sched] 36932a9e2b1: +121.2% boot-meminfo.SUnreclaim
Message-ID: <20140805212948.GE14042@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

FYI, we noticed the below changes on

git://internal_merge_and_test_tree devel-athens-alpha-201408042000
commit 36932a9e2b1043506d06414fa988cd5b9592841f ("sched: Fix finish_task_switch vs prev_state")

test case: vm-vp-1G/boot/1

11b4855f1d9f1cc  36932a9e2b1043506d06414fa 
---------------  ------------------------- 
      8524 ± 1%    +121.2%      18858 ± 0%  TOTAL boot-meminfo.SUnreclaim
      1321 ± 9%   +3196.6%      43568 ± 0%  TOTAL boot-meminfo.KernelStack
      8756 ± 0%     +29.8%      11363 ± 0%  TOTAL boot-slabinfo.num_pages
     34982 ± 0%     +29.5%      45311 ± 0%  TOTAL boot-meminfo.Slab
    535601 ± 0%      -9.9%     482375 ± 0%  TOTAL boot-meminfo.MemFree
    116621 ± 0%      +9.4%     127548 ± 0%  TOTAL boot-slabinfo.num_objs

Legend:
	±XX%    - stddev percent
	[+-]XX% - change percent

Thanks,
Fengguang
