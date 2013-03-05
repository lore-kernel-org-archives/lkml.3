Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3CEWes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:34:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab3CEWeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:34:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
Date: Tue, 5 Mar 2013 22:34:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>, Barry Song <baohua.song@csr.com>,
        Olof Johansson <olof@lixom.net>
References: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org> <512E9A39.3070207@wwwdotorg.org> <51354E35.1080804@codeaurora.org>
In-Reply-To: <51354E35.1080804@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303052234.32723.arnd@arndb.de>
X-Provags-ID: V02:K0:vQoTZYx2DzkpBYahKlTA9xKA66oQdVWlURc4tZ+gfNk
 XXUV3qhm7r1eOLvgx37NpBshAJHLUVHYYmgy9UMVFfOcfX7Q0R
 AvwHstNPw6OixboZ4H6fkJYSEHKc8rIY/0sCJzPSqfdTq5CIQ/
 0G6sKUYGzAurA3HaF0FL2GJNPwJ3E65AUDTTuG02YY32gqijpV
 qU5/5/hXfoLqPlXvzNiy/9LFB+WmdN0zOiUnz8Wz0XysHI/43P
 Mfip0uRx73FyWwXR0+0iQi6V9qgDLXs2j9q6T20TjIVU4Ei2Er
 Cp4epmhcv/aFCocZTItJSIjMn391as/6dQD5Xe7RjEXlhYh1sk
 tEif41UKbR3IojTnb3OI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Stephen Boyd wrote:
> On 02/27/13 15:43, Stephen Warren wrote:
> >
> > Seems simple enough it doesn't really need many, but for Tegra,
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> >
> > Which kernel is this going into? It's possible Tegra will get converted
> > to multi-platform in 3.10, which might move that main ARCH_TEGRA block
> > from arch/arm/Kconfig into arch/arm/mach-tegra/Kconfig, although I
> > suppose it doesn't have to move it. I think some/all(?) other
> > multi-platform conversions have moved their main Kconfig option like
> > that though.
> 
> Thanks. I'm hoping that Arnd/Olof can pick this up. I'm not sure which
> version it will go into.
> 

Hmm, it certainly looks useful to me. I think it should go into the next
cleanup branch as a base, so others can build on top of it. We will
also need it for the Exynos multiplatform patches that I hope can land
in 3.10 as well.

Sneaking it in through the fixes branch would make life easier for us,
but it doesn't feel right.

	Arnd
