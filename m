Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKJKNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:13:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:57273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:13:37 -0500
Date: Mon, 10 Nov 2014 11:13:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kan Liang <kan.liang@intel.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com
Subject: Re: [PATCH V8 00/14] perf, x86: Haswell LBR call stack support
 (kernel)
Message-ID: <20141110101327.GG3337@twins.programming.kicks-ass.net>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:54:17AM -0500, Kan Liang wrote:
> Yan, Zheng (13):
>   perf, x86: Reduce lbr_sel_map size
>   perf, core: introduce pmu context switch callback
>   perf, x86: use context switch callback to flush LBR stack
>   perf, x86: Basic Haswell LBR call stack support
>   perf, core: pmu specific data for perf task context
>   perf, core: always switch pmu specific data during context switch
>   perf, x86: allocate space for storing LBR stack
>   perf, x86: track number of events that use LBR callstack
>   perf, x86: Save/resotre LBR stack during context switch
>   perf, core: simplify need branch stack check
>   perf, x86: re-organize code that implicitly enables LBR/PEBS
>   perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack  
>       mode
>   perf, x86: Discard zero length call entries in LBR call stack
> 
> Peter Zijlstra (Intel) (1):
>   perf, x86: expose LBR callstack to user space tool

So are these the exact same patches I already had, or did you change
anything else? Its not immediately clear, lemme try and figure out.
