Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3FDKNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:13:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3FDKNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:13:41 -0400
Date: Tue, 4 Jun 2013 12:14:36 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH RFC -tip 0/6] perf: IRQ-bound performance events
Message-ID: <20130604101436.GA22914@dhcp-26-207.brq.redhat.com>
References: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
 <20130603133618.GK30878@dhcp-26-207.brq.redhat.com>
 <20130604093802.GK8923@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604093802.GK8923@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:38:02AM +0200, Peter Zijlstra wrote:
> > Oops, the most interesting part did not make it in. Very sorry :) Here:
> > 
> > # ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
> > Mon 03 Jun 2013 09:32:49 AM EDT  -0.719514 seconds
> > 
> >  Performance counter stats for process id '8':
> > 
> >                447 L1-dcache-load-misses                                       
> 
> I think that is very much expected; except in the case where you spend
> _all_ your time in IRQ handlers, they'll pretty much always miss l1
> cache.

The emphasis was on the fact it indeed could be measured for a particular ISR ;)

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
