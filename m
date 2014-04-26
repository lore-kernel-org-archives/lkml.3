Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaDZKzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:55:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaDZKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:55:42 -0400
Date: Sat, 26 Apr 2014 12:55:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140426105537.GI26782@laptop.programming.kicks-ass.net>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <2713863.BLQTYQm2Oa@vostro.rjw.lan>
 <20140425132055.GC11096@twins.programming.kicks-ass.net>
 <15044031.LGKXdkz8J7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15044031.LGKXdkz8J7@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 02:18:58AM +0200, Rafael J. Wysocki wrote:
> And why do we have to do things that we hate it when they are done by others?

Well, I'm assuming that these things that I dislike are actually useful
and liked by the majority (me not fitting that is nothing new). If
everybody hates these things, WTF are they still the default on pretty
much every OS out there, Windows and Mac OS do the same screen dimming
things when they loose AC last time I touched one of them.

Also, whilst I dislike screen dimming with a passion, I wouldn't
actually dislike the power aware balancer (assuming it would actually
work). Then I'm on BAT I tend to not actually do much more than read
email/browse web and maybe write some code. But I rarely if ever compile
when on battery.
