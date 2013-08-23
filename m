Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3HWNKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:10:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:39016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3HWNKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:10:16 -0400
Message-ID: <1377263403.14021.26.camel@jlt4.sipsolutions.net>
Subject: Re: [sched_delayed] sched: RT throttling activated
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, Theodore Tso <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 23 Aug 2013 15:10:03 +0200
In-Reply-To: <20130823130629.GZ31370@twins.programming.kicks-ass.net>
References: <521722EE.70209@fold.natur.cuni.cz>
	 <20130823100913.GQ31370@twins.programming.kicks-ass.net>
	 <52173BBD.3050803@fold.natur.cuni.cz>
	 <20130823110254.GU31370@twins.programming.kicks-ass.net>
	 <521748FC.10809@fold.natur.cuni.cz>
	 <20130823121004.GW31370@twins.programming.kicks-ass.net>
	 <1377261222.14021.23.camel@jlt4.sipsolutions.net>
	 <20130823130629.GZ31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-23 at 15:06 +0200, Peter Zijlstra wrote:

> > > >  2161  FF [irq/50-iwlwifi]

> > > And wow, why would that thing consume that much cpu. 
> > 
> > How much is "that much"?
> 
> 0.95s worth of time in the past 1s.

Huh, no, I have no idea how that can be. Any idea what it's doing?

johannes

