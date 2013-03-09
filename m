Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab3CISDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:03:19 -0500
Received: from 8bytes.org ([85.214.48.195]:50956 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3CISDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:03:18 -0500
Date: Sat, 9 Mar 2013 19:03:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd_iommu_init: remove __init from
 amd_iommu_erratum_746_workaround
Message-ID: <20130309180314.GB4876@8bytes.org>
References: <a6e63dc6f1bdc2d20f3d7d07a5d878e9c1b01d85.1361891160.git.npajkovs@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6e63dc6f1bdc2d20f3d7d07a5d878e9c1b01d85.1361891160.git.npajkovs@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Mar  9 19:03:17 2013
X-DSPAM-Confidence: 0.9986
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 513b796523678569620337
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 04:12:05PM +0100, Nikola Pajkovsky wrote:
> commit 318fe78 ("IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround")
> added amd_iommu_erratum_746_workaround and it's marked as __init, which is wrong
> 
> WARNING: drivers/iommu/built-in.o(.text+0x639c): Section mismatch in reference from the function iommu_init_pci() to the function .init.text:amd_iommu_erratum_746_workaround()
> The function iommu_init_pci() references
> the function __init amd_iommu_erratum_746_workaround().
> This is often because iommu_init_pci lacks a __init
> annotation or the annotation of amd_iommu_erratum_746_workaround is wrong.
> 
> Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>

Applied to iommu/fixes, thanks.


