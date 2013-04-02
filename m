Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab3DBQXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:23:17 -0400
Received: from 8bytes.org ([85.214.48.195]:54085 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760564Ab3DBQXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:23:15 -0400
Date: Tue, 2 Apr 2013 18:23:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: stuart.yoder@freescale.com, scottwood@freescale.com,
        iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/5 v11] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Message-ID: <20130402162310.GJ15687@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 18:23:14 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515b05f223675883760883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 01:23:57AM +0530, Varun Sethi wrote:
> This patchset provides the Freescale PAMU (Peripheral Access Management Unit) driver
> and the corresponding IOMMU API implementation. PAMU is the IOMMU present on Freescale
> QorIQ platforms. PAMU can authorize memory access, remap the memory address, and remap 
> the I/O transaction type.
> 
> This set consists of the following patches:
> 1.  Make iova dma_addr_t in the iommu_iova_to_phys API.
> 2. Addition of new field in the device (powerpc) archdata structure for storing iommu domain information
>    pointer.
> 3. Add window permission flags in the iommu_domain_window_enable API.
> 4. Add domain attributes for FSL PAMU driver.
> 5. PAMU driver and IOMMU API implementation.

Okay, I am about to apply patches 1 and 3 to a new ppc/pamu branch in my
tree.

As a general question, how did you test the IOMMU driver and what will
you do in the future to avoid regressions?


	Joerg


