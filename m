Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3LXFKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 00:10:42 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55922 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3LXFKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 00:10:40 -0500
Message-ID: <52B91747.7090309@ozlabs.ru>
Date: Tue, 24 Dec 2013 16:10:31 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org
CC: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: Add empty stub for iommu_group_get_by_id()
References: <1385016074-17026-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1385016074-17026-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 05:41 PM, Alexey Kardashevskiy wrote:
> Almost every function in include/linux/iommu.h has an empty stub
> but the iommu_group_get_by_id() did not get one by mistake.
> 
> This adds an empty stub for iommu_group_get_by_id() for IOMMU_API
> disabled config.

Ping?


> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  include/linux/iommu.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 7ea319e..3c7903d 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -245,6 +245,11 @@ static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
>  	return NULL;
>  }
>  
> +static inline struct iommu_group *iommu_group_get_by_id(int id)
> +{
> +	return NULL;
> +}
> +
>  static inline void iommu_domain_free(struct iommu_domain *domain)
>  {
>  }
> 


-- 
Alexey
