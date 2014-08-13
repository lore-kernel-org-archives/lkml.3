Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbaHMFIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:08:18 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54773 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaHMFIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:08:17 -0400
Date: Wed, 13 Aug 2014 07:08:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 05/33] perf record: Allow the user to disable time stamps
Message-ID: <20140813050812.GA19464@gmail.com>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
 <1407169064-25625-6-git-send-email-acme@kernel.org>
 <20140805060856.GA9453@gmail.com>
 <20140805133347.GH13375@kernel.org>
 <20140812145819.GA7737@gmail.com>
 <20140812152953.GA9820@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812152953.GA9820@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Tue, Aug 12, 2014 at 04:58:19PM +0200, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > > Em Tue, Aug 05, 2014 at 08:08:56AM +0200, Ingo Molnar escreveu:
> > > > This patch looks dangerous and misleading to me.
> 
> > > I took it more from the angle: hey, it fixes a regression, i.e. 
> > > -T/--time somehow became a noop, and also it doesn't change any 
> > > default.
> 
> > > It also states that you will get misaccounting, why that would 
> > > happen, althought wording could've been better, as mmaps won't be 
> > > "missing", i.e. they will be there as this governs just 
> > > PERF_SAMPLE_TIME, not perf_event_attr.mmap, so it MMAPs may come 
> > > after samples for its maps.
> 
> > > So, I took it.
> 
> > > How should we proceed?
> 
> > I'd be fine with applying the patch and fixing the misleading 
> > changelog.
> 
> Done:
> 
> https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=8affc2b8c27bfc2d6e70827b746f490b62c44eaa
> 
> Consider now pulling the perf-core-for-mingo tag there, I updated it
> after updating the changelog for this specific commit, all the
> rest is the same as in the previous pull req.

Pulled into tip:perf/core, thanks a lot Arnaldo!

	Ingo
