Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3JGUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:34:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46779 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3JGUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:34:09 -0400
Date: Mon, 7 Oct 2013 22:33:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131007203348.GK3081@twins.programming.kicks-ass.net>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
 <1381162158-24329-2-git-send-email-eranian@google.com>
 <20131007175542.GB3363@tassilo.jf.intel.com>
 <20131007180810.GJ3081@twins.programming.kicks-ass.net>
 <20131007192258.GC3363@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007192258.GC3363@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:22:58PM -0700, Andi Kleen wrote:
> On Mon, Oct 07, 2013 at 08:08:10PM +0200, Peter Zijlstra wrote:
> > On Mon, Oct 07, 2013 at 10:55:42AM -0700, Andi Kleen wrote:
> > > This would in principle allow making it a module later (if perf ever
> > > supports that)
> > 
> > IIRC its a few EXPORTs away from being able to do that.
> 
> Great. With ~700k text that would be a good thing.
> After all most users don't develop.
> 
> Hopefully we can get there soon.
> 
> Is anyone actively working on it?

All of perf being a module; no and that's not actually going to happen.
PMU driver modules should be fairly simple though.

Dunno if anybody is working on that, I typically consider my .config
broken if its got =m in it.
