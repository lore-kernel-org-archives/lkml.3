Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaD0Tjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:39:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaD0Tjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:39:41 -0400
Date: Sun, 27 Apr 2014 21:39:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140427193928.GC17778@laptop.programming.kicks-ass.net>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <15044031.LGKXdkz8J7@vostro.rjw.lan>
 <20140426105537.GI26782@laptop.programming.kicks-ass.net>
 <2356289.56GzXmbvd0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2356289.56GzXmbvd0@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 03:54:32PM +0200, Rafael J. Wysocki wrote:
> On Saturday, April 26, 2014 12:55:37 PM Peter Zijlstra wrote:
> > On Sat, Apr 26, 2014 at 02:18:58AM +0200, Rafael J. Wysocki wrote:
> > > And why do we have to do things that we hate it when they are done by others?
> > 
> > Well, I'm assuming that these things that I dislike are actually useful
> > and liked by the majority (me not fitting that is nothing new). If
> > everybody hates these things, WTF are they still the default on pretty
> > much every OS out there, Windows and Mac OS do the same screen dimming
> > things when they loose AC last time I touched one of them.
> 
> Well, vendors have certain battery life targets for their products (you
> know, something for the marketing people to brag about) and tend to be
> quite aggressive about doing whatever they can to reach them.

Well, I was just hoping the industry wasn't _that_ rotten and there was
actual a majority of people liking this.

> We don't have such targets for the mainline kernel, though, do we? ;-)

No, for sure :-)
