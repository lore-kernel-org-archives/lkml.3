Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3DOO6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:58:42 -0400
Received: from 8bytes.org ([85.214.48.195]:44031 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3DOO6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:58:41 -0400
Date: Mon, 15 Apr 2013 16:58:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: stuart.yoder@freescale.com, scottwood@freescale.com,
        iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org, bhelgaas@google.com
Subject: Re: [PATCH 1/3] iommu: Move swap_pci_ref function to pci.h.
Message-ID: <20130415145834.GR6858@8bytes.org>
References: <1365966722-1804-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365966722-1804-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Apr 15 16:58:37 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 516c159d23679559513842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:42:00AM +0530, Varun Sethi wrote:
> swap_pci_ref function is used by the IOMMU API code for swapping pci device
> pointers, while determining the iommu group for the device.
> Currently this function was being implemented for different IOMMU drivers.
> This patch moves the function to pci.h so that the implementation can be
> shared across various IOMMU drivers.

The function is only used in IOMMU code, so I think its fine to keep it
there (unless Bjorn disagrees and wants it in PCI code).


	Joerg


