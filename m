Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBIUIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:08:18 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61361 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbaBIUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:08:17 -0500
Message-ID: <1391976496.25855.19.camel@x220>
Subject: Re: [PATCH 04/28] Remove EXYNOS_DEV_SYSMMU
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Joerg Roedel <joro@8bytes.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:08:16 +0100
In-Reply-To: <1391971686-9517-5-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-5-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:08:16.0103 (UTC) FILETIME=[AB1A6F70:01CF25D2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/iommu/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 79bbc21..20d062d 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -178,7 +178,7 @@ config TEGRA_IOMMU_SMMU
>  
>  config EXYNOS_IOMMU
>  	bool "Exynos IOMMU Support"
> -	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> +	depends on ARCH_EXYNOS
>  	select IOMMU_API
>  	help
>  	  Support for the IOMMU(System MMU) of Samsung Exynos application

I noted this one about a year ago (see
https://lkml.org/lkml/2013/3/5/401 ). By now I wonder whether
EXYNOS_IOMMU (and everything depending on it) shouldn't be removed. That
code has been unbuildable for at least a year now  (I have not checked
how much code is involved).


Paul Bolle

