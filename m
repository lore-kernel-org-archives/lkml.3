Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaFKCNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:13:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:2825 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaFKCNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:13:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,455,1400050800"; 
   d="scan'208";a="526568821"
Date: Wed, 11 Jun 2014 02:09:54 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 07/16 v3] Init Workload Consolidation flags in
 sched_domain
Message-ID: <20140610180954.GB5487@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-8-git-send-email-yuyang.du@intel.com>
 <20140603121416.GH30445@twins.programming.kicks-ass.net>
 <5395F541.60604@arm.com>
 <20140609211820.GA5361@intel.com>
 <5396F166.1030401@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5396F166.1030401@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:52:06PM +0100, Dietmar Eggemann wrote:

Hi Dietmar,

> Not in this sense but there is no functionality in the scheduler right
> now to check constantly if an sd flag has been set/unset via sysctl.

Sorry, I still don't understand. There are many "if (sd->flags & SD_XXX)"
in fair.c. What does it mean to you?

Probably you mean the SD_XX should be fixed in init and never changed via sysctl
thereafter. Ah... I don't know about this...

Overall, I think I should come up with a better way to implement the SD_WORKLOAD_CONSOLIDATION
policy (enabled or disabled) in load balancing (as is also pointed out by PeterZ).
But I just don't see the current implementation is any particular different than
any other SD_XX's.

Have you tried it on your platform?

Thanks a lot,
Yuyang
