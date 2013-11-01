Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3KARJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:09:22 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33059 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3KARJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:09:18 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: Re: [PATCH v2 4/4] ARM: dts: Add initial device tree support for EXYNOS5410
Date: Fri, 01 Nov 2013 18:09:18 +0100
Message-ID: <3553642.XBQjgGGvxT@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1381763305-7085-5-git-send-email-v.tyrtov@samsung.com>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com> <1381763305-7085-5-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 of October 2013 19:08:25 Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/boot/dts/Makefile                |   1 +
>  arch/arm/boot/dts/exynos5410-smdk5410.dts |  65 ++++++++++
>  arch/arm/boot/dts/exynos5410.dtsi         | 209
> ++++++++++++++++++++++++++++++ 3 files changed, 275 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>  create mode 100644 arch/arm/boot/dts/exynos5410.dtsi

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

