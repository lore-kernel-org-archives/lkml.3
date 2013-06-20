Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab3FTOFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:05:16 -0400
Received: from 8bytes.org ([85.214.48.195]:35070 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965093Ab3FTOFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:05:14 -0400
Date: Thu, 20 Jun 2013 16:05:11 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org, stuart.yoder@freescale.com,
        scottwood@freescale.com
Subject: Re: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Message-ID: <20130620140511.GT2575@8bytes.org>
References: <1366803351-17429-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366803351-17429-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 16:05:13 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c30c1920866169210981
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Varun,

On Wed, Apr 24, 2013 at 05:05:50PM +0530, Varun Sethi wrote:
> Added the following domain attributes for the FSL PAMU driver:
> 1. Added new iommu stash attribute, which allows setting of the
>    LIODN specific stash id parameter through IOMMU API.
> 2. Added an attribute for enabling/disabling DMA to a particular
>    memory window.
> 3. Added domain attribute to check for PAMUV1 specific constraints.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>

Can you please rebase the driver tp v3.10-rc6 and resend asap? I will
give it another review then and request AlexW to look over the
iommu-group stuff. So we can probably get this merged for v3.11.


Thank,

	Joerg


