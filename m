Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaD0NiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 09:38:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60528 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752751AbaD0NiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 09:38:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Date: Sun, 27 Apr 2014 15:54:32 +0200
Message-ID: <2356289.56GzXmbvd0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140426105537.GI26782@laptop.programming.kicks-ass.net>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <15044031.LGKXdkz8J7@vostro.rjw.lan> <20140426105537.GI26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 26, 2014 12:55:37 PM Peter Zijlstra wrote:
> On Sat, Apr 26, 2014 at 02:18:58AM +0200, Rafael J. Wysocki wrote:
> > And why do we have to do things that we hate it when they are done by others?
> 
> Well, I'm assuming that these things that I dislike are actually useful
> and liked by the majority (me not fitting that is nothing new). If
> everybody hates these things, WTF are they still the default on pretty
> much every OS out there, Windows and Mac OS do the same screen dimming
> things when they loose AC last time I touched one of them.

Well, vendors have certain battery life targets for their products (you
know, something for the marketing people to brag about) and tend to be
quite aggressive about doing whatever they can to reach them.

We don't have such targets for the mainline kernel, though, do we? ;-)

> Also, whilst I dislike screen dimming with a passion, I wouldn't
> actually dislike the power aware balancer (assuming it would actually
> work). Then I'm on BAT I tend to not actually do much more than read
> email/browse web and maybe write some code. But I rarely if ever compile
> when on battery.

So the relative value of energy grows for you when going from AC to battery.
That may happen in other situations too (like when the cost of energy in
terms of money depends on the time of day which may be the case in some
geographies etc.), so "battery vs AC" is not really special.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
