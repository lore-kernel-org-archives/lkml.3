Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaBGLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:09:28 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:47435 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaBGLJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:09:27 -0500
Date: Fri, 7 Feb 2014 11:09:23 +0000 (GMT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Russell King <linux@arm.linux.org.uk>,
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
In-Reply-To: <20140206164336.GU2936@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1402071051140.1906@knanqh.ubzr>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org> <1391017513-12995-7-git-send-email-nicolas.pitre@linaro.org> <20140130152500.GB5002@laptop.programming.kicks-ass.net> <alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr>
 <20140130162753.GF5002@laptop.programming.kicks-ass.net> <alpine.LFD.2.11.1402061152550.1906@knanqh.ubzr> <20140206164336.GU2936@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Peter Zijlstra wrote:

> On Thu, Feb 06, 2014 at 02:09:59PM +0000, Nicolas Pitre wrote:
> > Hi Peter,
> > 
> > Did you merge those patches in your tree? 
> 
> tree, tree, what's in a word.

Something you may plant on a patch of grass?  "Merging" becomes a 
strange concept in that context though.  :-)

> Its in my patch stack yes. 

Quilt I suppose?? (yet another word.)

> I should get some of that into tip I suppose, been side-tracked a bit 
> this week. Sorry for the delay.

If you prefer we pile those patches (and future ones after revew) 
ourselves just let me know.  Future patches are likely to be more 
intimate with the scheduler so I just need to know who to upstream them 
through afterwards.


Nicolas
