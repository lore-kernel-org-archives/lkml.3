Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbbAELvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:51:11 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbbAELvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:51:09 -0500
Date: Mon, 5 Jan 2015 12:50:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 0/3] sched: skip_clock_update madness
Message-ID: <20150105115054.GE3337@twins.programming.kicks-ass.net>
References: <20150105101809.860964488@infradead.org>
 <1420454949.5266.138.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420454949.5266.138.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:49:09AM +0100, Mike Galbraith wrote:
> On Mon, 2015-01-05 at 11:18 +0100, Peter Zijlstra wrote: 
> > Hi,
> > 
> > So the big lockup thread got me looking at the skip_clock_update stuff again
> > and here's what I came up with.
> > 
> > It seems to build a kernel without generating lockdep splats.
> > 
> > Mike can you see if it cures the wobblies you were seeing?
> 
> Nope, those hiccups were production IO beasts from hell staying in the
> kernel for ages at a time.  Watchdog being falsely credited with what is
> usually dinky wakeup -> switch delta throttled it effectively forever.

OK, It's Monday and I'm still trying to bootstrap my post xmas brain. Is
that: Nope - can't check, or: Nope - doesn't fix wobblies ?
