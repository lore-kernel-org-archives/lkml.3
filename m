Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaJJLK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:10:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32984 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaJJLK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:10:57 -0400
Date: Fri, 10 Oct 2014 12:10:54 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 10/11] perf/x86/intel: Support task events with Intel CQM
Message-ID: <20141010111054.GX14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-11-git-send-email-matt@console-pimps.org>
 <20141008110743.GF4750@worktop.programming.kicks-ass.net>
 <20141010105425.GA3000@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010105425.GA3000@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct, at 12:54:25PM, Peter Zijlstra wrote:
> 
> As you rightly pointed out on IRC, the following (as found in patch 8):
> 
> +static struct pmu intel_cqm_pmu = {
> +       .attr_groups    = intel_cqm_attr_groups,
> +       .task_ctx_nr    = perf_sw_context,
> 
> Does indeed make it a software event, so then need to do all the
> scheduling outselves.

OK, I'll take a look at that.

-- 
Matt Fleming, Intel Open Source Technology Center
