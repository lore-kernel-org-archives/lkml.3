Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaAESEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:04:51 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60005 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaAESEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:04:49 -0500
Date: Sun, 5 Jan 2014 19:04:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>, 723180@bugs.debian.org,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: Disable IST stacks for debug/int 3/stack
 fault for PREEMPT_RT"
Message-ID: <20140105180446.GX20765@two.firstfloor.org>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
 <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
 <52AE0419.3050103@linutronix.de>
 <20140103135548.GA6327@linutronix.de>
 <20140104181807.GS20765@two.firstfloor.org>
 <1388897147.5342.36.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388897147.5342.36.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 05:45:47AM +0100, Mike Galbraith wrote:
> On Sat, 2014-01-04 at 19:18 +0100, Andi Kleen wrote: 
> > On Fri, Jan 03, 2014 at 02:55:48PM +0100, Sebastian Andrzej Siewior wrote:
> > > where do I start. Let me explain what is going on here. The code
> > > sequence
> > 
> > Yes the IST stacks are needed for correctness, even in more cases than
> > the example below. You cannot just disable them, just because you don't
> > like them.
> 
> You had a better reason than dislike.

Ah true it was me. Good point. I forgot all about that.

Probably it needs some form of the NMI style paranoid_* switch.

-Andi
