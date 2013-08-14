Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3HNKUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:20:17 -0400
Received: from 8bytes.org ([85.214.48.195]:50203 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab3HNKUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:20:15 -0400
Date: Wed, 14 Aug 2013 12:20:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] amd_iommu: clean up unnecessary MSI/MSI-X
 capability find
Message-ID: <20130814102007.GE4491@8bytes.org>
References: <1375967556-6248-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375967556-6248-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 12:20:11 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b59db20861529417601
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 09:12:36PM +0800, Yijing Wang wrote:
> PCI core will initialize device MSI/MSI-X capability in
> pci_msi_init_pci_dev(). So device driver should use
> pci_dev->msi_cap/msix_cap to determine whether the device
> support MSI/MSI-X instead of using
> pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
> Access to PCIe device config space again will consume more time.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org

Applied to x86/amd, thanks.


