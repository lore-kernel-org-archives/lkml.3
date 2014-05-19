Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaESFkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:40:39 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:48118 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaESFkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <1400227438-27155-1-git-send-email-chander.kashyap@linaro.org>
References: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com>
	<1400227438-27155-1-git-send-email-chander.kashyap@linaro.org>
Date: Mon, 19 May 2014 11:10:36 +0530
Message-ID: <CANuQgHH1_O-8XHhRREdu5WjOwz1oeASdVf7TQFdGxjr0WDSvhQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] add cpuidle support for Exynos5420
From: Chander Kashyap <chander.kashyap@linaro.org>
To: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chander Kashyap <chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel/Kgene,

On 16 May 2014 13:33, Chander Kashyap <chander.kashyap@linaro.org> wrote:
> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.
>
> This patchset adds cpuidle support for Exynos5420 SoC based on
> generic big.little cpuidle driver.
>
> Tested on SMDK5420.
>
> This patch set depends on:
>         1. [PATCH 0/5] MCPM backend for Exynos5420
>            http://www.spinics.net/lists/arm-kernel/msg331100.html
> Changelog is in respective patches.
> Chander Kashyap (5):
>   driver: cpuidle-big-little: add of_device_id structure
>   arm: exynos: add generic function to calculate cpu number
>   cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
>     driver
>   driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>   exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>   mcpm: exynos: populate suspend and powered_up callbacks
>
>  arch/arm/mach-exynos/exynos.c        |    4 +++-
>  arch/arm/mach-exynos/mcpm-exynos.c   |   36 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
>  drivers/cpuidle/Kconfig.arm          |    2 +-
>  drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
>  5 files changed, 60 insertions(+), 3 deletions(-)
>
> --
> 1.7.9.5
>

As dependency patches are merged. If their are no further comment, can
these patches be taken?

-- 
with warm regards,
Chander Kashyap
