Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaEHOBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:01:39 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:39098 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbaEHOBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:01:36 -0400
Date: Thu, 8 May 2014 22:01:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com, t.figa@samsung.com,
        davem@davemloft.net
Subject: Re: [PATCH 0/7 v8] crypto:s5p-sss: Add Device tree and Exynos support
Message-ID: <20140508140134.GC13769@gondor.apana.org.au>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:44:52AM +0000, Naveen Krishna Chatradhi wrote:
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

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
