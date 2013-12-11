Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LKOFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:05:10 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38304 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LKOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:05:07 -0500
Date: Wed, 11 Dec 2013 15:05:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL RESEND2] clocksource/clockevents fixes for 3.13
Message-ID: <20131211140503.GA3846@gmail.com>
References: <52A767CB.3010501@linaro.org>
 <20131210194852.GB21814@gmail.com>
 <52A87077.1030800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A87077.1030800@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> On 12/10/2013 08:48 PM, Ingo Molnar wrote:
> 
> [ ... ]
> 
> >>
> >>  drivers/clocksource/Kconfig              |    1 +
> >>  drivers/clocksource/clksrc-of.c          |    1 -
> >>  drivers/clocksource/dw_apb_timer_of.c    |    7 ++++---
> >>  drivers/clocksource/sun4i_timer.c        |    3 +++
> >>  drivers/clocksource/time-armada-370-xp.c |   10 +++++-----
> >>  5 files changed, 13 insertions(+), 9 deletions(-)
> >
> >Pulled into tip:timers/urgent, thanks a lot Daniel!
> 
> Thanks to you for helping me to be a better maintainer. All you
> comments and advices were very valuable.

You are welcome!

Thanks,

	Ingo
