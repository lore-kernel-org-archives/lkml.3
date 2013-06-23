Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3FWLti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:49:38 -0400
Received: from 8bytes.org ([85.214.48.195]:38241 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3FWLtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:49:36 -0400
Date: Sun, 23 Jun 2013 13:49:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: Fix compiler warning on pr_debug
Message-ID: <20130623114930.GA2557@8bytes.org>
References: <20130621153331.2881.35589.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621153331.2881.35589.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jun 23 13:49:34 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c6e0ce20861749710308
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 09:33:50AM -0600, Alex Williamson wrote:
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/iommu/iommu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 4b0b56b..ab1fa19 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -820,7 +820,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
>  		size_t pgsize = iommu_pgsize(domain, iova | paddr, size);
>  
>  		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize %lu\n", iova,
> -					(unsigned long)paddr, pgsize);
> +			 (unsigned long)paddr, (unsigned long)pgsize);
>  
>  		ret = domain->ops->map(domain, iova, paddr, pgsize, prot);
>  		if (ret)

Applied to core branch, thanks.


