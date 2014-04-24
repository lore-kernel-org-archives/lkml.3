Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbaDXN1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:27:07 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:60234 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124AbaDXN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <1398335198-26555-1-git-send-email-geert+renesas@glider.be>
References: <1398335198-26555-1-git-send-email-geert+renesas@glider.be>
Date: Thu, 24 Apr 2014 15:26:53 +0200
Message-ID: <CAPDyKFqi_6L48je_0cazHHDtQGzuvSPfocZT5+eLzd1egUVYXw@mail.gmail.com>
Subject: Re: [PATCH 0/6] PM / clock_ops: Add helpers combining generic runtime
 and generic clock PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>, linux-sh@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 12:26, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> Several platform support codes combine pm_generic_runtime_suspend() and
> pm_clk_suspend(), resp. pm_clk_resume() and pm_generic_runtime_resume() in
> their .runtime_suspend resp. .runtime_resume callbacks.
>
> Create helpers to consolidate.
>
>   - [1/6] PM / clock_ops: Add helpers combining generic runtime and generic
>           clock PM

How about adding the code from the above patch into the generic power
domain instead?

>   - [2/6] ARM: davinci: Use generic runtime and clock helpers
>   - [3/6] ARM: keystone: Use generic runtime and clock helpers
>   - [4/6] ARM: omap: Use generic runtime and clock helpers
>   - [5/6] drivers: sh: Use generic runtime and clock helpers

Then convert the above power domains implementations to the generic
power domain? Would that work?

Kind regards
Ulf Hansson

>   - [6/6] of/clk: Use generic runtime and clock helpers
>
> Patches 5 and 6 have dependencies (listed in the individual patches),
> but they can be postponed and handled later.
>
> Thanks!
>
> Gr{oetje,eeting}s,
>
>                                                 Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                                             -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
