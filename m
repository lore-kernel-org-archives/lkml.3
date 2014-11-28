Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaK1L7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:59:38 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54277 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaK1L7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:59:36 -0500
MIME-Version: 1.0
In-Reply-To: <1416695185-5198-1-git-send-email-afaerber@suse.de>
References: <547104D5.4030803@suse.de>
	<1416695185-5198-1-git-send-email-afaerber@suse.de>
Date: Fri, 28 Nov 2014 12:59:35 +0100
Message-ID: <CACRpkdZie8JJGxSPkc8PPvC3qZkWhe5WqmpSKSoDFwqRd6tR_Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] pinctrl: exynos: add exynos5410 SoC specific data
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?B?6rmA7ZWZ7KO8?= <ruppi.kim@hardkernel.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:PIN CONTROL SUBSY..." <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 11:26 PM, Andreas Färber <afaerber@suse.de> wrote:

> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
>
> Add Samsung EXYNOS5410 SoC specific data to enable pinctrl
> support for all platforms based on EXYNOS5410.
>
> Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>
> [AF: Rebased onto Exynos5260 and irq_chip consolidation]
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v2 -> v3:
>  * Rebased (.svc, .{g,w}eint_{con,mask,pend} fields dropped)
>
>  v1 -> v2:
>  * Filled in Sob from Hakjoo Kim

Is this based on the pinctrl devel branch so I can apply it?

I'd like Tomasz ACK on it first though.

Yours,
Linus Walleij
