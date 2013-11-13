Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3KMKgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:36:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51234 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3KMKgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:36:39 -0500
Date: Wed, 13 Nov 2013 11:36:32 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: 3.12 fixes
Message-ID: <20131113103632.GV14892@pengutronix.de>
References: <528234B9.7080402@linaro.org>
 <20131112183553.GQ14892@pengutronix.de>
 <alpine.DEB.2.02.1311122316270.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1311122316270.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, Nov 12, 2013 at 11:57:46PM +0100, Thomas Gleixner wrote:
> The whole misery starts that you decided to play maintainer and grab
> some patches from the mailinglist and then offering them via a pull
> request to me and others. Finally you tricked Daniel to take them,
>From my POV this isn't "playing maintainer". You stopped reacting on the
issue and I thought I make it easier for you (and others) to handle the
patches in case you didn't take because of being busy with other stuff.

> which is a different issue.
> 
> There is a reason why I ignored that pull request:
> 
>  I generally do not pull git trees from people who I'm not
>  trusting. And I have good reasons not to trust you at all.
> 
> Aside of that, I decided to give you a chance and actually pulled
> your tree into a temporary branch and found out that it's missing a
> stable annotation. Which made the whole exercise go into /dev/null
I didn't add that stable annotation because I didn't want to add it
without you being ok with it. And actually it's easy to get a patch into
stable that isn't annotated. The other way round is harder.
 
> Now Linus pulled my version way before Daniel pulled your tree into
> his. And you even commented on my commit that I forgot to add a
> tested-by tag. Yes, I missed that in favour of the stable annotation.
> 
> But instead of rebasing your tree or even just withdrawing it and
> resending the at91 patch, you let Daniel pull your thing.
To be fair Daniel said to take my pull request a few days before your
tip-bot told me that you finally took the patch. I could argue that it
was your turn to tell Daniel that you took a part of the patches that
were in my pull request. (But I don't as the situation it handled now
and even if not, the only bad thing that would have happend is that
another patch is duplicated in the history. shrug)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
