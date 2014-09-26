Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaIZJsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:48:32 -0400
Received: from 8bytes.org ([81.169.241.247]:37273 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaIZJs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:48:29 -0400
Date: Fri, 26 Sep 2014 11:48:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, tech@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com, Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Thierry Reding <treding@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 02/26] iommu: add capability IOMMU_CAP_NOEXEC
Message-ID: <20140926094827.GE28786@8bytes.org>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-3-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411483586-29304-3-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:46:01PM +0200, Antonios Motakis wrote:
> Some IOMMUs accept an IOMMU_NOEXEC protection flag in addition to
> IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  include/linux/iommu.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index e1a644c..0433553 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -59,6 +59,7 @@ struct iommu_domain {
>  
>  #define IOMMU_CAP_CACHE_COHERENCY	0x1
>  #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
> +#define IOMMU_CAP_NOEXEC		0x3	/* IOMMU_NOEXEC flag */

This changed recently to an enum, please rebase to latest iommu/next
branch.


With that change:

	Acked-by: Joerg Roedel <jroedel@suse.de>

for patches 1 and 2.

