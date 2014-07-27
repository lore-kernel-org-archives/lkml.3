Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaG0MZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 08:25:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbaG0MZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 08:25:33 -0400
Message-ID: <53D4EFBB.6000404@suse.de>
Date: Sun, 27 Jul 2014 14:25:31 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org
CC: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: EXYNOS: Fix Exynos5410 boot
References: <1406463725-4208-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1406463725-4208-1-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.07.2014 14:22, schrieb Andreas Färber:
> Hello,
> 
> This mini-series unbreaks booting on 5410 based ODROID-XU.
> 
> Since I do not have access to a TRM, the address is a guess based on 
> 5250 and 5410. Such a node was not present in the 3.14 downstream tree.

s/5410/5420/

> 
> Regards,
> Andreas
> 
> Andreas Färber (3):
>   Documentation: devicetree: Document exynos5410 PMU
>   ARM: dts: exynos: Add PMU to Exynos5410
>   ARM: EXYNOS: Add support for Exynos5410 PMU
> 
>  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>  arch/arm/boot/dts/exynos5410.dtsi                     | 5 +++++
>  arch/arm/mach-exynos/exynos.c                         | 1 +
>  3 files changed, 7 insertions(+)

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
