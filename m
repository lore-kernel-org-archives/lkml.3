Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbaGDKg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:36:58 -0400
Received: from 8bytes.org ([85.214.48.195]:42286 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975AbaGDKg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:36:56 -0400
Date: Fri, 4 Jul 2014 12:36:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] iommu: Fix DMA alias problems
Message-ID: <20140704103653.GU26537@8bytes.org>
References: <20140703154428.8112.97562.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703154428.8112.97562.stgit@gimli.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 12:36:54 2014
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b683c620863354269530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 09:51:12AM -0600, Alex Williamson wrote:
> Alex Williamson (7):
>       iommu: Remove pci.h
>       iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
>       iommu/intel: Update to use PCI DMA aliases
>       iommu/intel: Use iommu_group_get_for_dev()
>       iommu/amd: Use iommu_group_get_for_dev()
>       iommu/amd: Update to use PCI DMA aliases
>       iommu: Create central IOMMU group lookup/creation interface
> 
> 
>  drivers/iommu/amd_iommu.c           |  214 +++++++-----------------
>  drivers/iommu/amd_iommu_types.h     |    1 
>  drivers/iommu/fsl_pamu_domain.c     |   66 --------
>  drivers/iommu/intel-iommu.c         |  307 +++++++++++++----------------------
>  drivers/iommu/intel_irq_remapping.c |   55 ++++--
>  drivers/iommu/iommu.c               |  182 +++++++++++++++++++++
>  drivers/iommu/pci.h                 |   29 ---
>  include/linux/iommu.h               |    1 
>  8 files changed, 398 insertions(+), 457 deletions(-)
>  delete mode 100644 drivers/iommu/pci.h

Applied to the core branch, thanks Alex.


