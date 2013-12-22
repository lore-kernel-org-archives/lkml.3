Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3LVCaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 21:30:11 -0500
Received: from oker.escape.de ([194.120.234.254]:58466 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab3LVCaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 21:30:09 -0500
Date: Sun, 22 Dec 2013 03:25:23 +0100
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20131222022523.GD26013@pompeji.miese-zwerge.org>
References: <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
 <20130923164931.GC2322@pompeji.miese-zwerge.org>
 <20131206002614.GD15492@linux.vnet.ibm.com>
 <20131206135804.GI2208@pompeji.miese-zwerge.org>
 <20131206145441.GA24148@linux.vnet.ibm.com>
 <20131210112257.GJ2208@pompeji.miese-zwerge.org>
 <20131216224006.GA5919@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216224006.GA5919@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi!

On Mon, Dec 16, 2013 at 02:40:06PM -0800, Paul E. McKenney wrote:
> > > > > rcu: Kick CPU halfway to RCU CPU stall warning
[...]
> And you are quite right, there is a prerequisite commit.  I have attached
> both, please apply in numeric order.

Applies, compiles, and runs smoothly on top of 3.12.6. I'll send word
if anything odd shows up.

> Because patch.2 has not yet made it to mainline, it is not yet eligible
> for -stable.  I expect it to hit mainline in the 3.14 merge window,
> which will likely be coming up in a few weeks.

Ah, ok. Thanks for helping and informing!


Have a nice Christmas holiday,
Jochen.
