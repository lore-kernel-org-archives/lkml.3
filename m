Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3HWNGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:06:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab3HWNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:06:35 -0400
Date: Fri, 23 Aug 2013 15:06:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, Theodore Tso <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched_delayed] sched: RT throttling activated
Message-ID: <20130823130629.GZ31370@twins.programming.kicks-ass.net>
References: <521722EE.70209@fold.natur.cuni.cz>
 <20130823100913.GQ31370@twins.programming.kicks-ass.net>
 <52173BBD.3050803@fold.natur.cuni.cz>
 <20130823110254.GU31370@twins.programming.kicks-ass.net>
 <521748FC.10809@fold.natur.cuni.cz>
 <20130823121004.GW31370@twins.programming.kicks-ass.net>
 <1377261222.14021.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377261222.14021.23.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 02:33:42PM +0200, Johannes Berg wrote:
> On Fri, 2013-08-23 at 14:10 +0200, Peter Zijlstra wrote:
> 
> > >  2161  FF [irq/50-iwlwifi]
> > 
> > Oh a threaded interrupt, I presume you're not using "threadiqrs" since
> > this is the only interrupt thread around and I see a
> > 'request_threaded_irq()' call in
> > drivers/net/wireless/iwlwifi/pcie/trans.c
> > 
> > And wow, why would that thing consume that much cpu. 
> 
> How much is "that much"?

0.95s worth of time in the past 1s.
