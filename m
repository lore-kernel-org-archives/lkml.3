Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaKRKZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:25:43 -0500
Received: from 8bytes.org ([81.169.241.247]:58867 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaKRKZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:25:41 -0500
Date: Tue, 18 Nov 2014 11:25:38 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part3 V7 0/8] Enable support of Intel DMAR device hotplug
Message-ID: <20141118102537.GB3762@8bytes.org>
References: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On Sun, Nov 09, 2014 at 10:47:55PM +0800, Jiang Liu wrote:
> Jiang Liu (8):
>   iommu/vt-d: Introduce helper function dmar_walk_resources()
>   iommu/vt-d: Dynamically allocate and free seq_id for DMAR units
>   iommu/vt-d: Implement DMAR unit hotplug framework
>   iommu/vt-d: Search for ACPI _DSM method for DMAR hotplug
>   iommu/vt-d: Enhance intel_irq_remapping driver to support DMAR unit
>     hotplug
>   iommu/vt-d: Enhance error recovery in function
>     intel_enable_irq_remapping()
>   iommu/vt-d: Enhance intel-iommu driver to support DMAR unit hotplug
>   pci, ACPI, iommu: Enhance pci_root to support DMAR device hotplug
> 
>  drivers/acpi/pci_root.c             |   16 +-
>  drivers/iommu/dmar.c                |  532 ++++++++++++++++++++++++++++-------
>  drivers/iommu/intel-iommu.c         |  297 ++++++++++++++-----
>  drivers/iommu/intel_irq_remapping.c |  249 ++++++++++++----
>  include/linux/dmar.h                |   50 +++-
>  5 files changed, 897 insertions(+), 247 deletions(-)

The patches look good, but I need an ack from PCI/ACPI for patch 8
before I can merge it. Patches 1-7 are applied.

Thanks,

	Joerg

