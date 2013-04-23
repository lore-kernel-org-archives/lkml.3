Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3DWNB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:01:59 -0400
Received: from 8bytes.org ([85.214.48.195]:54297 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab3DWNB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:01:58 -0400
Date: Tue, 23 Apr 2013 15:01:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org, stuart.yoder@freescale.com,
        scottwood@freescale.com
Subject: Re: [PATCH 1/3 v2] iommu: Move swap_pci_ref function to pci.h.
Message-ID: <20130423125827.GD2589@8bytes.org>
References: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 23 15:01:57 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5176864523671692835695
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:05:24AM +0530, Varun Sethi wrote:
> +#ifndef __PCI_H
> +#define __PCI_H

Using __PCI_H is not a wise choice, it has certainly a high risk of a
collision. Anyway, I changed it to __IOMMU_PCI_H and applied the patch.


	Joerg


