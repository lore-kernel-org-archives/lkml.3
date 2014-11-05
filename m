Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaKEJVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:21:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaKEJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:21:48 -0500
Date: Wed, 5 Nov 2014 10:21:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kan Liang <kan.liang@intel.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141105092145.GP10501@worktop.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415156173-10035-14-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:56:09PM -0500, Kan Liang wrote:
> From: Yan, Zheng <zheng.z.yan@intel.com>
> 
> Only enable LBR callstack when user requires fp callgraph. The feature
> is not available when PERF_SAMPLE_BRANCH_STACK or PERF_SAMPLE_STACK_USER
> is required.
> Also, this feature only affects how to get user callchain. The kernel
> callchain is always got by frame pointers.

Since FP callchains should not change, this doesn't appear to make any
sense either.
