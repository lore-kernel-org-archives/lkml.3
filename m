Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967413AbaFTMXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:23:25 -0400
Received: from 8bytes.org ([85.214.48.195]:48561 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966074AbaFTMXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:23:23 -0400
Date: Fri, 20 Jun 2014 14:23:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] iommu/vt-d: fix bug in handling multiple RMRRs for the
 same PCI device
Message-ID: <20140620122320.GJ31771@8bytes.org>
References: <1403248086-13853-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403248086-13853-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 20 14:23:21 2014
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53a427b920861837270662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 03:08:06PM +0800, Jiang Liu wrote:
> Function dmar_iommu_notify_scope_dev() makes a wrong assumption that
> there's one RMRR for each PCI device at most, which causes DMA failure
> on some HP platforms. So enhance dmar_iommu_notify_scope_dev() to
> handle multiple RMRRs for the same PCI device.
> 
> Fixbug: https://bugzilla.novell.com/show_bug.cgi?id=879482
> 
> Cc: <stable@vger.kernel.org> # 3.15
> Reported-by: Tom Mingarelli <thomas.mingarelli@hp.com>
> Tested-by: Linda Knippers <linda.knippers@hp.com>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Applied to iommu/fixes, thans Jiang.


