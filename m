Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931Ab3HIPRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:17:00 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11547 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934081Ab3HIPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:16:59 -0400
X-IronPort-AV: E=Sophos;i="4.89,846,1367964000"; 
   d="scan'208";a="28941801"
Date: Fri, 9 Aug 2013 17:16:41 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Richard Genoud <richard.genoud@gmail.com>
cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: convert comma to semicolon
In-Reply-To: <CACQ1gAg__bY9pCnGnkf2QGHkBvssXXdS3bMJiuOJfh9e082jhA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1308091715310.2295@hadrien>
References: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr> <1375990372-19033-2-git-send-email-Julia.Lawall@lip6.fr> <CACQ1gAg__bY9pCnGnkf2QGHkBvssXXdS3bMJiuOJfh9e082jhA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Aug 2013, Richard Genoud wrote:
> > diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> > index 847cab6..8149b7b 100644
> > --- a/drivers/clocksource/time-armada-370-xp.c
> > +++ b/drivers/clocksource/time-armada-370-xp.c
> > @@ -175,10 +175,10 @@ static int armada_370_xp_timer_setup(struct clock_event_device *evt)
> >         evt->name               = "armada_370_xp_per_cpu_tick",
> There's one missed just here !                                  ^
>
> >         evt->features           = CLOCK_EVT_FEAT_ONESHOT |
> >                                   CLOCK_EVT_FEAT_PERIODIC;
> > -       evt->shift              = 32,
> > -       evt->rating             = 300,
> > -       evt->set_next_event     = armada_370_xp_clkevt_next_event,
> > -       evt->set_mode           = armada_370_xp_clkevt_mode,
> > +       evt->shift              = 32;
> > +       evt->rating             = 300;
> > +       evt->set_next_event     = armada_370_xp_clkevt_next_event;
> > +       evt->set_mode           = armada_370_xp_clkevt_mode;
> >         evt->irq                = armada_370_xp_clkevt_irq;
> >         evt->cpumask            = cpumask_of(cpu);
> >
> [snip]
>
> The rest looks good to me !

Thanks for the feedback.  I was going to try to make a patch that does
everything that this one does not, but it is not working out very well, so
I will make a new patch that does everything.

julia
