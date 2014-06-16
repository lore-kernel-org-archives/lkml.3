Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaFPOsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:48:05 -0400
Received: from 8bytes.org ([85.214.48.195]:40051 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaFPOsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:48:03 -0400
Date: Mon, 16 Jun 2014 16:47:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org, linux@horizon.com,
        eddy0596@gmail.com
Subject: Re: [PATCH v4 00/16] PCI/iommu: Fix DMA alias problems
Message-ID: <20140616144759.GC18986@8bytes.org>
References: <20140522230230.2856.40017.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 16 16:48:00 2014
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 539f03a020869010118446
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Thu, May 22, 2014 at 05:07:23PM -0600, Alex Williamson wrote:
> Alex Williamson (16):
>       PCI: Add DMA alias iterator
>       PCI: define pci_dev_flags as bit shifts
>       PCI: quirk pci_for_each_dma_alias()
>       PCI: quirk dma_alias_devfn for Ricoh devices
>       PCI: quirk dma_alias_devfn for Marvell devices
>       PCI: Quirk pci_for_each_dma_alias() for bridges
>       PCI: Add quirks for ASMedia and Tundra bridges
>       iommu: Create central IOMMU group lookup/creation interface
>       iommu/amd: Update to use PCI DMA aliases
>       iommu/amd: Use iommu_group_get_for_dev()
>       iommu/intel: Use iommu_group_get_for_dev()
>       iommu/intel: Update to use PCI DMA aliases
>       iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
>       iommu: Remove pci.h
>       PCI: Remove pci_find_upstream_pcie_bridge()
>       PCI: Remove pci_get_dma_source()

Sorry for the delay, I had a look at the generic IOMMU and the AMD part
now. It looks good to me so far, but I still have to review the VT-d
changes and give it all some testing on my machines. I really like the
code simplification in the IOMMU drivers and also feel more comfortable
when the IVRS table is still taken into consideration for getting
aliases.


	Joerg


