Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774Ab3HNJsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:48:10 -0400
Received: from 8bytes.org ([85.214.48.195]:50130 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3HNJsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:48:09 -0400
Date: Wed, 14 Aug 2013 11:48:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        galak@kernel.crashing.org, alex.williamson@redhat.com,
        stuart.yoder@freescale.com, scottwood@freescale.com
Subject: Re: [PATCH 1/3] powerpc: Add iommu domain pointer to device archdata
Message-ID: <20130814094802.GC4491@8bytes.org>
References: <1373863857-27239-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373863857-27239-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 11:48:07 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b525720862074367239
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:20:55AM +0530, Varun Sethi wrote:
> Add an iommu domain pointer to device (powerpc) archdata.  Devices
> are attached to iommu domains and this pointer provides a mechanism
> to correlate between a device and the associated iommu domain.  This
> field is set when a device is attached to a domain.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> Acked-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> - rebased patch to 3.11-rc1
>  arch/powerpc/include/asm/device.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Okay, I applied these patches to my ppc/pamu branch. But before I merge
it to my next branch (so that it can go upstream) I want to have a
compile-test-case first. Can you send me a working .config which
includes this driver?

Thanks,

	Joerg


