Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaGaEqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 00:46:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaGaEqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 00:46:49 -0400
Message-ID: <53D9CA35.1030800@suse.de>
Date: Thu, 31 Jul 2014 06:46:45 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
CC: Hakjoo Kim <ruppi.kim@hardkernel.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Humberto Naves <hsnaves@gmail.com>
Subject: Re: [RFC 0/5] ARM: EXYNOS: ODROID-XU DT and LEDs
References: <1406549892-5558-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1406549892-5558-1-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

Am 28.07.2014 14:18, schrieb Andreas Färber:
> Hello,
> 
> This series adds a dedicated ODROID-XU device tree and enhances it with 
> LED configuration, to match the downstream 3.14 based behavior.
> 
> It had turned out less trivial than I initially thought as the whole 
> pinctrl stuff is still missing. I thus cherry-pick two downstream commits.
> 
> Hakjoo, can you please reply with a Signed-off-by to your patches
> so that we can get them into upstream? Thanks in advance!

FTR, Hakjoo Kim did reply with signed off patches (thanks again!) and
updated their branch accordingly:

https://github.com/hardkernel/linux/commits/odroid-3.14.y-linaro
https://github.com/hardkernel/linux/commit/53edc3da0d1da287517681b47daf36679637b6ba
https://github.com/hardkernel/linux/commit/afdc310e47e4d1799719566bfb5a47c55141a7cb

> Andreas Färber (3):
>   ARM: dts: exynos5410: Clean up SMDK5410 indentation
>   ARM: dts: exynos5410: Prepare ODROID-XU device tree

The functional changes below haven't been reviewed yet, but could you
consider applying trivial patches 1-2?

Regards,
Andreas

>   ARM: dts: exynos5410: Add ODROID-XU LEDs
> 
> Hakjoo Kim (2):
>   pinctrl: exynos: add exynos5410 SoC specific data
>   ARM: dts: add pinctrl support to Exynos5410
> 
>  .../bindings/pinctrl/samsung-pinctrl.txt           |   1 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/exynos5410-odroidxu.dts          | 111 ++++++
>  arch/arm/boot/dts/exynos5410-pinctrl.dtsi          | 408 +++++++++++++++++++++
>  arch/arm/boot/dts/exynos5410-smdk5410.dts          |   6 +-
>  arch/arm/boot/dts/exynos5410.dtsi                  |  32 ++
>  drivers/pinctrl/pinctrl-exynos.c                   | 126 +++++++
>  drivers/pinctrl/pinctrl-samsung.c                  |   2 +
>  drivers/pinctrl/pinctrl-samsung.h                  |   1 +
>  9 files changed, 685 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/dts/exynos5410-odroidxu.dts
>  create mode 100644 arch/arm/boot/dts/exynos5410-pinctrl.dtsi
> 


-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
