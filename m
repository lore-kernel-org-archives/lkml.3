Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaGDJxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:53:13 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:48338 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaGDJxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
References: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
Date: Fri, 4 Jul 2014 15:23:10 +0530
Message-ID: <CAK5sBcFKwR5hYTq9uUYtR0DRN=hZLVWN_HmOU7P7+6-70R=BFw@mail.gmail.com>
Subject: Re: [PATCH] iommu/exynos: Select ARM_DMA_USE_IOMMU
From: Sachin Kamat <spk.linux@gmail.com>
To: Tushar Behera <tushar.b@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org,
        pullip.cho@samsung.com, shaik.ameer@samsung.com,
        Tushar Behera <trblinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On Fri, Jul 4, 2014 at 3:01 PM, Tushar Behera <tushar.b@samsung.com> wrote:
> For IOMMU to use on Exynos platforms, we need to enable ARM_DMA_USE_IOMMU. It
> would be better to select it by default when EXYNOS_IOMMU is enabled.
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> ---
>  drivers/iommu/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index d260605..54f3ad1a 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -180,6 +180,7 @@ config EXYNOS_IOMMU
>         bool "Exynos IOMMU Support"
>         depends on ARCH_EXYNOS
>         select IOMMU_API
> +       select ARM_DMA_USE_IOMMU
>         help
>           Support for the IOMMU (System MMU) of Samsung Exynos application
>           processor family. This enables H/W multimedia accelerators to see
> --

Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>

-- 
Regards,
Sachin.
