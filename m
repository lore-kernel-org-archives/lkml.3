Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaESJYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:24:06 -0400
Received: from 8bytes.org ([85.214.48.195]:52890 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaESJYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:24:03 -0400
Date: Mon, 19 May 2014 11:23:58 +0200
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
Subject: Re: [Patch Part3 V2 00/21] Enable support of Intel DMAR device
 hotplug
Message-ID: <20140519092358.GB17056@8bytes.org>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 19 11:24:01 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5379cdb120861355511003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey David,

On Tue, May 06, 2014 at 03:05:11PM +0800, Jiang Liu wrote:
> Patch 1-13 are bugfixes and code improvement for current drivers.
> Patch 14-17 enhances DMAR framework to support hotplug
> Patch 18 enhances Intel interrupt remapping driver to support hotplug
> Patch 19 enhances error handling in Intel IR driver
> Patch 20 enhance Intel IOMMU to support hotplug
> Patch 21 enhance ACPI pci_root driver to handle DMAR units

Have you had a chance to look into this patch-set? I'll wonder whether
it should be merged for 3.16.


	Joerg


