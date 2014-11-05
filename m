Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaKEJVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:21:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaKEJVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:21:01 -0500
Date: Wed, 5 Nov 2014 10:20:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kan Liang <kan.liang@intel.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com
Subject: Re: [PATCH V7 11/17] perf, core: expose LBR call stack to user perf
 tool
Message-ID: <20141105092056.GO10501@worktop.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-12-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415156173-10035-12-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:56:07PM -0500, Kan Liang wrote:
> From: Yan, Zheng <zheng.z.yan@intel.com>

Now for this patch I'm fairly sure Zheng didn't actually write it; his
last posting did something different IIRC.

> With LBR call stack feature enable, there are two call chain data

_three_, LBR is the 3rd.

> sources, traditional frame pointer and LBR call stack.
> This patch extends the perf_callchain_entry struct to mark the available
> call chain source.
> The frame pointer is still output as PERF_SAMPLE_CALLCHAIN data format.
> The LBR call stack data will be output as PERF_SAMPLE_BRANCH_STACK data
> format.

I'm not sure what this patch does?! Why do the FP based callchains need
_any_ changes?
