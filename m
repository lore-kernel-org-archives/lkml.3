Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaBJMu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:50:58 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:39152 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaBJMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:50:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Bolle <pebolle@tiscali.nl>, Simon Horman <horms+renesas@verge.net.au>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: shmobile: depend on ARCH_SHMOBILE
Date: Mon, 10 Feb 2014 13:51:56 +0100
Message-ID: <2633349.EWmK6n4A5k@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1391894514.19595.5.camel@x220>
References: <1391894514.19595.5.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Saturday 08 February 2014 22:21:54 Paul Bolle wrote:
> Commit 78a2e12f51d9 ("iommu: shmobile: Enable driver compilation with
> COMPILE_TEST") added an optional dependency on SH_MOBILE. But that
> Kconfig symbol doesn't exist. It seems ARCH_SHMOBILE was intended. Use
> that.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Joerg, could you please pick this patch up ?

> ---
> Completely untested.
> 
>  drivers/iommu/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 79bbc21..df56e4c 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -207,7 +207,7 @@ config SHMOBILE_IOMMU
>  	bool "IOMMU for Renesas IPMMU/IPMMUI"
>  	default n
>  	depends on ARM
> -	depends on SH_MOBILE || COMPILE_TEST
> +	depends on ARCH_SHMOBILE || COMPILE_TEST
>  	select IOMMU_API
>  	select ARM_DMA_USE_IOMMU
>  	select SHMOBILE_IPMMU

-- 
Regards,

Laurent Pinchart

