Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaAOMrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:47:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:44513 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaAOMrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:47:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,662,1384329600"; 
   d="scan'208";a="459180329"
Date: Wed, 15 Jan 2014 20:47:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: [sched] d50dde5a1: LTP sched_setparam* TFAILs
Message-ID: <20140115124739.GB19419@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dario,

We notice the below LTP failures since commit d50dde5a1 ("sched: Add
new scheduler syscalls to support an extended scheduling parameters
ABI") in tip tree's sched/core branch:

ltp.sched_setparam02.1.TFAIL
ltp.sched_setparam02.2.TFAIL
ltp.sched_setparam02.3.TFAIL
ltp.sched_setparam03.1.TFAIL

It seems that the LKP test failures are somehow expected due to the
change of ABI. However it does mean that these test cases will need to
be updated.

Thanks,
Fengguang
