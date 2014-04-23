Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaDWKCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:02:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58884 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752401AbaDWKCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:02:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        daniel.lezcano@linaro.org, kgene.kim@samsung.com
Subject: Re: [Patch v2 0/4] add cpuidle support for Exynos5420
Date: Wed, 23 Apr 2014 12:18:24 +0200
Message-ID: <4517423.BmCv8cudjC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
References: <1398080958-21677-5-git-send-email-chander.kashyap@linaro.org> <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 02:55:50 PM Chander Kashyap wrote:
> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.
> 
> This patchset adds cpuidle support for Exynos5420 SoC based on
> generic big.little cpuidle driver.
> 
> Tested on SMDK5420.
> 
> This patch set depends on:
> 	1. [PATCH 0/5] MCPM backend for Exynos5420
> 	   http://www.spinics.net/lists/arm-kernel/msg321666.html
> 
> 	2. [PATCH v4] arm: exynos: generalize power register address calculation
> 	   http://www.spinics.net/lists/arm-kernel/msg324024.html
> 		
> Changelog is in respective patches.
> Chander Kashyap (4):
>   cpuidle: config: Add SOC_EXYNOS5420 entry to select
>     cpuidle-big-little driver
>   driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>   exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>   mcpm: exynos: populate suspend and powered_up callbacks
> 
>  arch/arm/mach-exynos/cpuidle.c       |    3 ++
>  arch/arm/mach-exynos/mcpm-exynos.c   |   53 ++++++++++++++++++++++++++++++++++
>  drivers/cpuidle/Kconfig.arm          |    2 +-
>  drivers/cpuidle/cpuidle-big_little.c |    3 +-
>  4 files changed, 59 insertions(+), 2 deletions(-)

I'm assuming that the Exynos maintainers will take care of this, correct?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
