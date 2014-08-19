Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaHSE37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 00:29:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:42264 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaHSE36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 00:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,891,1400050800"; 
   d="scan'208";a="578545736"
Date: Tue, 19 Aug 2014 12:30:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: lkp@01.org, LKML <linux-kernel@vger.kernel.org>
Subject: [writeback] 952648324b9: xfstests.xfs.026.fail
Message-ID: <20140819043006.GA11419@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

We find more xfstests changes on "writeback: Per-sb dirty tracking".

008 seems improved, the others are regressions.
063 failure is not 100% reproducible.

df3be46bdbab23e  952648324b969f3fc22d3a2a7  
---------------  -------------------------  
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.026.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.027.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.061.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.281.fail
         0           +Inf%          0 ±200%  TOTAL xfstests.xfs.063.fail
         0 ±489%    -100.0%          0 ± 0%  TOTAL xfstests.xfs.008.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.056.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.059.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.060.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.266.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.282.fail
         0           +Inf%          1 ± 0%  TOTAL xfstests.xfs.283.fail

Thanks,
Fengguang
