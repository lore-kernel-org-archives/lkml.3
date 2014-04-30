Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbaD3LI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:08:29 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53375 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaD3LI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 30 Apr 2014 16:38:05 +0530
Message-ID: <CAHfPSqDc=WYzdkuJuCY6uQQbcZQQ5SuD+kOfy-aymFL1v7=csg@mail.gmail.com>
Subject: Re: [PATCH 0/7 v8] crypto:s5p-sss: Add Device tree and Exynos support
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 28 April 2014 16:14, Naveen Krishna Chatradhi <ch.naveen@samsung.com> wrote:
> SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
> features to the one on S5PV210. However with minor changes the s5p-sss.c
> driver can be reused to support SSS modules on Exynos4 and 5 SoCs.
>
> This patch set
> 1. Adds device tree support to the s5p-sss.c driver and Documentation
> 2. Adds code to support SSS module on Exynos4 and 5 SoCs
> 3. Adds variant struct to handle the differences in SSS modules
> 4. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver
>
> Note: Compatible "exynos4210-secss" should work for Exynos4412 and
>       Exynos5260 (Exynos5260, for which ARCH code is under review)
> I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
> test with addition of DT node and clocks support.
>
> These patches are under review at
> https://lkml.org/lkml/2014/2/17/124
>
> Naveen Krishna Chatradhi (7):
>   crypto:s5p-sss: Use platform_get_irq() instead of _byname()
>   crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
>   crypto:s5p-sss: Look for the next request in the queue
>   crypto:s5p-sss: Add device tree support
>   crypto:s5p-sss: Add support for SSS module on Exynos
>   crypto:s5p-sss: validate iv before memcpy
>   crypto:s5p-sss: Use clk_prepare/clk_unprepare
>
>  .../devicetree/bindings/crypto/samsung-sss.txt     |   35 +++++
>  drivers/crypto/Kconfig                             |    6 +-
>  drivers/crypto/s5p-sss.c                           |  145 +++++++++++++++-----
>  3 files changed, 150 insertions(+), 36 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

Can we get this series merged in.
Its has got reviewed and re-based several times and got acked by a
couple of seniors.

Thanks,
>
> --
> 1.7.9.5
>



-- 
Shine bright,
(: Nav :)
