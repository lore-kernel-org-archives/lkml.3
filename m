Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaIVUt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:49:56 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:55567 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaIVUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:49:53 -0400
Date: Mon, 22 Sep 2014 14:49:48 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] PCI: Remove dead code after DMA alias work
Message-ID: <20140922204948.GH1880@google.com>
References: <20140917163930.21584.69496.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917163930.21584.69496.stgit@gimli.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:41:01AM -0600, Alex Williamson wrote:
> v1: inopportune DNS failure blocked patches, resending
> 
> Now that IOMMU drivers have completed the DMA alias transition,
> remove the left behind dead code.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       PCI: Remove pci_get_dma_source()
>       PCI: Remove pci_find_upstream_pcie_bridge()

Applied to pci/virtualization for v3.18, thanks!

>  drivers/pci/quirks.c |   51 --------------------------------------------------
>  drivers/pci/search.c |   34 ---------------------------------
>  include/linux/pci.h  |   16 ----------------
>  3 files changed, 101 deletions(-)
