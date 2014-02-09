Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaBIUcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:32:20 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55748 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaBIUcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:32:19 -0500
Message-ID: <1391977937.25855.29.camel@x220>
Subject: Re: [PATCH 10/28] Remove SH_MOBILE
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Joerg Roedel <joro@8bytes.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:32:17 +0100
In-Reply-To: <1391971686-9517-11-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-11-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:32:18.0132 (UTC) FILETIME=[069E9940:01CF25D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/iommu/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 20d062d..68b047a 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -206,8 +206,7 @@ config SHMOBILE_IPMMU_TLB
>  config SHMOBILE_IOMMU
>  	bool "IOMMU for Renesas IPMMU/IPMMUI"
>  	default n
> -	depends on ARM
> -	depends on SH_MOBILE || COMPILE_TEST
> +	depends on ARM || COMPILE_TEST

It seems ARCH_SHMOBILE was intended, see
https://lkml.org/lkml/2014/2/8/256 .

>  	select IOMMU_API
>  	select ARM_DMA_USE_IOMMU
>  	select SHMOBILE_IPMMU


Paul Bolle

