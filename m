Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaBYGQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:16:37 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:43112 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaBYGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:16:34 -0500
Date: Tue, 25 Feb 2014 14:16:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com, davem@davemloft.net
Subject: Re: [PATCH 0/9 v7] crypto:s5p-sss: Add DT and Exynos support
Message-ID: <20140225061630.GA9934@gondor.apana.org.au>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:14:26PM +0530, Naveen Krishna Chatradhi wrote:
> SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
> features to the one on S5PV210. However with minor changes the s5p-sss.c
> driver can be reused to support SSS modules on Exynos4 and 5 SoCs.
> 
> This patch set
> 1. Adds device tree support to the s5p-sss.c driver and Documentation
> 2. Adds code to support SSS module on Exynos4 and 5 SoCs
> 3. Adds device tree node to Exynos5250 and Exynos5420
> 4. Adds variant struct to handle the differences in SSS modules
> 5. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver
> 
> Note: Compatible "exynos4210-secss" should work for Exynos4412 and
>       Exynos5260 (Exynos5260, for which ARCH code is under review)
> I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
> test with addition of DT node and clocks support.
> 
> Naveen Krishna Ch (7): [crypto-2.6.git]
>   crypto:s5p-sss: Use platform_get_irq() instead of _byname()
>   crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
>   crypto:s5p-sss: Look for the next request in the queue
>   crypto:s5p-sss: Add device tree support
>   crypto:s5p-sss: Add support for SSS module on Exynos
>   crypto:s5p-sss: validate iv before memcpy
>   crypto:s5p-sss: Use clk_prepare/clk_unprepare

FWIW these patches are fine by me.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
