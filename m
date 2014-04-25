Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaDYNWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:22:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaDYNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:21:04 -0400
Date: Fri, 25 Apr 2014 15:20:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140425132055.GC11096@twins.programming.kicks-ass.net>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <535911DC.9050109@linaro.org>
 <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com>
 <2713863.BLQTYQm2Oa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2713863.BLQTYQm2Oa@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 01:46:53PM +0200, Rafael J. Wysocki wrote:

_trim_ emails!!! one of these days I'm going to write a bot to flame
your head of if there's excessive quoting.

> > I had a offline conversation with Daniel about this since there are
> > other triggers - thermal constraints and game-like apps being examples
> > - that might want to override the system policy. He intended
> > "performance" mode to mean the existing code paths and "power" mode to
> > mean *additional* new heuristics for energy-efficiency. The power
> > supply assumption is just the first one of those heuristics.
> 
> Well, so now the question is whether or not we relly want to always
> go to the "power" (or "energy efficiency" if you will) mode if the system
> is on battery.  That arguably may not be a good thing even for energy
> efficiency depending on how exactly the modes are defined.

Nobody is talking about always. But in general it seems a good enough
approach. Hell, many of the AC/BAT switches in todays power management
crap things are not always right.

Do I want it to dim the LCD further when I unplug the laptop -- mostly
no, but still it does. And the most annoying one is that it reduces the
screen blank time to something near 5 seconds or so.

Why would this be any different? If you know what you want you can turn
the knob.

> So in my opinion it's too early to add things like that at this point.

Meh.. 
