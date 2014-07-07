Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaGGIkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:40:16 -0400
Received: from 8bytes.org ([85.214.48.195]:44645 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaGGIkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:40:14 -0400
Date: Mon, 7 Jul 2014 10:40:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iommu: Constify struct iommu_ops
Message-ID: <20140707084011.GB1958@8bytes.org>
References: <1403852592-10637-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403852592-10637-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jul  7 10:40:13 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53ba5ced20861949219570
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 09:03:12AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This structure is read-only data and should never be modified.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - add missing hunk from include/device.h
> 
>  drivers/iommu/amd_iommu.c       |  4 ++--
>  drivers/iommu/arm-smmu.c        |  2 +-
>  drivers/iommu/exynos-iommu.c    |  2 +-
>  drivers/iommu/fsl_pamu_domain.c |  2 +-
>  drivers/iommu/intel-iommu.c     |  4 ++--
>  drivers/iommu/iommu.c           | 19 ++++++++++++++-----
>  drivers/iommu/ipmmu-vmsa.c      |  2 +-
>  drivers/iommu/msm_iommu.c       |  2 +-
>  drivers/iommu/omap-iommu.c      |  2 +-
>  drivers/iommu/shmobile-iommu.c  |  2 +-
>  drivers/iommu/tegra-gart.c      |  2 +-
>  drivers/iommu/tegra-smmu.c      |  2 +-
>  include/linux/device.h          |  2 +-
>  include/linux/iommu.h           |  4 ++--
>  14 files changed, 30 insertions(+), 21 deletions(-)

Applied, thanks.


