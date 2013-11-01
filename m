Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3KAXCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 19:02:39 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:42562 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KAXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 19:02:35 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robherring2@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        "arm@kernel.org" <arm@kernel.org>, linux-samsung-soc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Ben Dooks <ben-linux@fluff.org>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Mike Turquette <mturquette@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 1/4] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Sat, 02 Nov 2013 00:02:36 +0100
Message-ID: <2801293.Bp2raaCeuk@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <527422AC.1050105@gmail.com>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com> <1381763305-7085-2-git-send-email-v.tyrtov@samsung.com> <527422AC.1050105@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Friday 01 of November 2013 16:52:44 Rob Herring wrote:
> On 10/14/2013 10:08 AM, Vyacheslav Tyrtov wrote:
> > From: Tarek Dakhran <t.dakhran@samsung.com>
> > 
> > EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
> > Add initial support for this SoC.
> 
> I think this entire patch is mostly unnecessary and this information
> should all be coming from DT. I'll leave it to arm-soc maintainers
> whether they want to accept this addition rather than see some clean-up
> here.

The clean-up here is already in plans, but this is much more than can be 
seen just from this patch, so it needs some time.

> 
> "samsung,exynos5410" does need to be documented though.

Right.

Best regards,
Tomasz

