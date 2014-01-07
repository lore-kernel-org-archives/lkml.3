Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaAGArh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:47:37 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:61738 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaAGArf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:47:35 -0500
MIME-Version: 1.0
In-Reply-To: <1386204578-6018-1-git-send-email-nm@ti.com>
References: <1386204578-6018-1-git-send-email-nm@ti.com>
Date: Mon, 6 Jan 2014 18:47:33 -0600
X-Google-Sender-Auth: mFfLlu_cFP_v6PEmqEva7V1tsKU
Message-ID: <CAGo_u6o+Lcf0wzmsSir1APd4T3A4D+GPtdRmkBM79mjW2aEGHA@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] ARM: OMAP2+/dts: standardize SoC naming
From: Nishanth Menon <nm@ti.com>
To: Rob Herring <rob.herring@calxeda.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>
Cc: Mark Rutland <mark.rutland@arm.com>, dt list <devicetree@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        lkml <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit, Tony,

On Wed, Dec 4, 2013 at 6:49 PM, Nishanth Menon <nm@ti.com> wrote:
> Originally attempted partially in [1], the missing binding were
> reported as part of Rob's report in [2].

Would you like me to send this series again since I do not see this in:
https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.14/dts

patchwork links:
https://patchwork.kernel.org/patch/3286051/
https://patchwork.kernel.org/patch/3286061/

>
> So, here is take two of the series, lacking an standard causes issues
> that was fixed such as [3]. Ideally, we should never again introduce a
> board file without a exact compatible SoC match.
>
> I have stayed a bit away from updating board and SoC dts files yet
> to look at the direction we'd like to go here. If we feel things are
> good, I would gladly try to clean our mess up.
>
> Nishanth Menon (2):
>   Documentation: dt: OMAP: explicitly state SoC compatible strings
>   ARM: OMAP2+: board-generic: update SoC compatibility strings
>
>  .../devicetree/bindings/arm/omap/omap.txt          |   53 ++++++++++++++++++++
>  arch/arm/mach-omap2/board-generic.c                |    7 +++
>  2 files changed, 60 insertions(+)
>
> [1] https://patchwork.kernel.org/patch/2998201/
> [2] http://marc.info/?l=linux-arm-kernel&m=138378029113665&w=2
> [3] https://patchwork.kernel.org/patch/3279281/
>
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
