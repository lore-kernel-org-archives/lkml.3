Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaG2Ktg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:49:36 -0400
Received: from 8bytes.org ([81.169.241.247]:49918 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaG2Kte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:49:34 -0400
Date: Tue, 29 Jul 2014 12:49:32 +0200
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
Subject: Re: [Patch Part3 V4 00/21] Enable support of Intel DMAR device
 hotplug
Message-ID: <20140729104932.GC9809@8bytes.org>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:19:24PM +0800, Jiang Liu wrote:
> Patch 1-13 are bugfixes and code improvement for current drivers.

Okay, I applied these for now (1-13 only) so that you don't have to
rebase everything next time.

> Patch 14-17 enhances DMAR framework to support hotplug
> Patch 18 enhances Intel interrupt remapping driver to support hotplug
> Patch 19 enhances error handling in Intel IR driver
> Patch 20 enhance Intel IOMMU to support hotplug
> Patch 21 enhance ACPI pci_root driver to handle DMAR units

For these I'd like to see some reviews/acked-bys/tested-bys so that we
gain more confidence on them.


	Joerg

