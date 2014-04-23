Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaDWFgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:36:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:57812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaDWFgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:36:21 -0400
Date: Wed, 23 Apr 2014 07:36:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched / idle: Make cpuidle_idle_call() void
Message-ID: <20140423053618.GW26782@laptop.programming.kicks-ass.net>
References: <4717784.WmVEpDoliM@vostro.rjw.lan>
 <20140422114930.GH11182@twins.programming.kicks-ass.net>
 <107574725.ErYUTC83FZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <107574725.ErYUTC83FZ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 01:36:42AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 22, 2014 01:49:30 PM Peter Zijlstra wrote:
> > On Mon, Apr 21, 2014 at 01:26:58AM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > The only value ever returned by cpuidle_idle_call() is 0 and its
> > > only caller ignores that value anyway, so make it void.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Thanks!
> 
> OK, thanks, so should it go through my tree or through tip?

I'll take it through tip where there's more patches that touch this
code.
