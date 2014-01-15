Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaAOMEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:04:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35245 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaAOMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:04:38 -0500
Date: Wed, 15 Jan 2014 13:04:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140115120418.GD31570@twins.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D64676.4040000@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 09:27:34AM +0100, Daniel Lezcano wrote:
> 
> Hi all,
> 
> I use the tip/sched/core branch.
> 
> After git pulling yesterday, my host is unresponsive after booting the OS.
> 
>  * It boots normally
>  * It sends info to the console
>  * The graphics does not work
>  * The terminals show the prompt, I can enter the username but after
> pressing enter, it does not give the password prompt
>  * sysrq works more or less, I can't get the process stack but it receives
> the command
> 
> It is like no new process can be created.
> 
> I have a dual Xeon processor E5325 (2 x 4 cores).
> 
> After git bisecting, the following patch seems to introduce the bug.
> 
> commit d50dde5a10f305253cbc3855307f608f8a3c5f73

OK, so my headless WSM-EP boots just fine. Obviously it cannot confirm
if graphics works, but I can ssh in and work on it without bother.

I can even log in on the serial console without problems.

I tried both tip/master and tip/sched/core.

Would you happen to have a .config for me to try?

