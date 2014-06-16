Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaFPPeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbaFPPeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:34:23 -0400
Message-ID: <1402932855.3707.40.camel@ul30vt.home>
Subject: Re: [PATCH v4 00/16] PCI/iommu: Fix DMA alias problems
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org, linux@horizon.com,
        eddy0596@gmail.com
Date: Mon, 16 Jun 2014 09:34:15 -0600
In-Reply-To: <20140616144759.GC18986@8bytes.org>
References: <20140522230230.2856.40017.stgit@bling.home>
	 <20140616144759.GC18986@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 16:47 +0200, Joerg Roedel wrote:
> Hi Alex,
> 
> On Thu, May 22, 2014 at 05:07:23PM -0600, Alex Williamson wrote:
> > Alex Williamson (16):
> >       PCI: Add DMA alias iterator
> >       PCI: define pci_dev_flags as bit shifts
> >       PCI: quirk pci_for_each_dma_alias()
> >       PCI: quirk dma_alias_devfn for Ricoh devices
> >       PCI: quirk dma_alias_devfn for Marvell devices
> >       PCI: Quirk pci_for_each_dma_alias() for bridges
> >       PCI: Add quirks for ASMedia and Tundra bridges
> >       iommu: Create central IOMMU group lookup/creation interface
> >       iommu/amd: Update to use PCI DMA aliases
> >       iommu/amd: Use iommu_group_get_for_dev()
> >       iommu/intel: Use iommu_group_get_for_dev()
> >       iommu/intel: Update to use PCI DMA aliases
> >       iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
> >       iommu: Remove pci.h
> >       PCI: Remove pci_find_upstream_pcie_bridge()
> >       PCI: Remove pci_get_dma_source()
> 
> Sorry for the delay, I had a look at the generic IOMMU and the AMD part
> now. It looks good to me so far, but I still have to review the VT-d
> changes and give it all some testing on my machines. I really like the
> code simplification in the IOMMU drivers and also feel more comfortable
> when the IVRS table is still taken into consideration for getting
> aliases.

Great, thanks Joerg.  Let me know if you'd like a new series with just
the IOMMU bits.  Thanks,

Alex

