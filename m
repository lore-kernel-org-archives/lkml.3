Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaBFQoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:44:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53346 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaBFQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:44:07 -0500
Date: Thu, 6 Feb 2014 17:43:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 6/6] cpu/idle.c: move to sched/idle.c
Message-ID: <20140206164336.GU2936@laptop.programming.kicks-ass.net>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
 <1391017513-12995-7-git-send-email-nicolas.pitre@linaro.org>
 <20140130152500.GB5002@laptop.programming.kicks-ass.net>
 <alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr>
 <20140130162753.GF5002@laptop.programming.kicks-ass.net>
 <alpine.LFD.2.11.1402061152550.1906@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1402061152550.1906@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:09:59PM +0000, Nicolas Pitre wrote:
> Hi Peter,
> 
> Did you merge those patches in your tree? 

tree, tree, what's in a word. Its in my patch stack yes. I should get
some of that into tip I suppose, been side-tracked a bit this week.
Sorry for the delay.

> If so, is it published somewhere?  

http://programming.kicks-ass.net/sekrit/patches.tar.bz2

It is of varying quality at best.

> That would be a good idea if that could appear in linux-next 
> so to prevent people from adding more calls to cpuidle_idle_call() from 
> architecture code.  I'm sending you 2 additional patches right away to 
> remove those that appeared in v3.14-rc1.

Yeah, once they land in tip they'll end up in -next automagically. I'll
try and get that sorted tomorrow somewhere.
