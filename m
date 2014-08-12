Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHLO60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:58:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47238 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaHLO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:58:24 -0400
Date: Tue, 12 Aug 2014 16:58:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 05/33] perf record: Allow the user to disable time stamps
Message-ID: <20140812145819.GA7737@gmail.com>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
 <1407169064-25625-6-git-send-email-acme@kernel.org>
 <20140805060856.GA9453@gmail.com>
 <20140805133347.GH13375@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805133347.GH13375@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Tue, Aug 05, 2014 at 08:08:56AM +0200, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
>  
> > This patch looks dangerous and misleading to me.
> 
> I took it more from the angle: hey, it fixes a regression, i.e. 
> -T/--time somehow became a noop, and also it doesn't change any 
> default.
> 
> It also states that you will get misaccounting, why that would 
> happen, althought wording could've been better, as mmaps won't be 
> "missing", i.e. they will be there as this governs just 
> PERF_SAMPLE_TIME, not perf_event_attr.mmap, so it MMAPs may come 
> after samples for its maps.
> 
> So, I took it.
> 
> How should we proceed?

I'd be fine with applying the patch and fixing the misleading 
changelog.

Thanks,

	Ingo
