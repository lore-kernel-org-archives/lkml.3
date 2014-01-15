Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaAOMY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:24:59 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37553 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaAOMY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:24:57 -0500
Date: Wed, 15 Jan 2014 13:24:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, raistlin@linux.it,
        juri.lelli@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140115122452.GA18311@gmail.com>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115120418.GD31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Jan 15, 2014 at 09:27:34AM +0100, Daniel Lezcano wrote:
> > 
> > Hi all,
> > 
> > I use the tip/sched/core branch.
> > 
> > After git pulling yesterday, my host is unresponsive after booting the OS.
> > 
> >  * It boots normally
> >  * It sends info to the console
> >  * The graphics does not work
> >  * The terminals show the prompt, I can enter the username but after
> > pressing enter, it does not give the password prompt
> >  * sysrq works more or less, I can't get the process stack but it receives
> > the command
> > 
> > It is like no new process can be created.
> > 
> > I have a dual Xeon processor E5325 (2 x 4 cores).
> > 
> > After git bisecting, the following patch seems to introduce the bug.
> > 
> > commit d50dde5a10f305253cbc3855307f608f8a3c5f73
> 
> OK, so my headless WSM-EP boots just fine. Obviously it cannot confirm
> if graphics works, but I can ssh in and work on it without bother.
> 
> I can even log in on the serial console without problems.
> 
> I tried both tip/master and tip/sched/core.

I too booted various sytems and have yet to notice similar oddity.

Thanks,

	Ingo
