Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaJGM3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:29:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57245 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJGM3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:29:41 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <1412587602-7763-2-git-send-email-pankaj.dubey@samsung.com>
References: <1412587602-7763-1-git-send-email-pankaj.dubey@samsung.com>
	<1412587602-7763-2-git-send-email-pankaj.dubey@samsung.com>
Date: Tue, 7 Oct 2014 14:29:40 +0200
Message-ID: <CABxcv=n3M0Td5GoqugSgk5P5juZsCFnuV7dD92WQjaQPpfesmQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] ARM: EXYNOS: Add platform driver support for
 Exynos PMU
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vikas Sajjan <vikas.sajjan@samsung.com>, naushad@samsung.com,
        thomas.ab@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pankaj,

On Mon, Oct 6, 2014 at 11:26 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> This patch modifies Exynos Power Management Unit (PMU) initialization
> implementation in following way:
>
> - Added platform driver support for Exynos PMU IP.
> - Added platform struct exynos_pmu_data to hold platform specific data.
> - For each SoC's PMU support now we can add platform data and statically
>   bind PMU configuration and SoC specific initialization function.
> - Separate each SoC's PMU initialization function and make it as part of
>   platform data.
> - It also removes uses of soc_is_exynosXYZ().
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig |    1 +
>  arch/arm/mach-exynos/pmu.c   |  171 +++++++++++++++++++++++++++++++-----------
>  2 files changed, 130 insertions(+), 42 deletions(-)
>

Suspend-to-RAM is working on my Exynos5420 Peach Pit Chromebook, so:

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
