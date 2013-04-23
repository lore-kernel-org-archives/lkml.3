Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3DWNim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:38:42 -0400
Received: from 8bytes.org ([85.214.48.195]:54381 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab3DWNil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:38:41 -0400
Date: Tue, 23 Apr 2013 15:38:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org, stuart.yoder@freescale.com,
        scottwood@freescale.com
Subject: Re: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Message-ID: <20130423133837.GG17148@8bytes.org>
References: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
 <1366691726-9023-2-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366691726-9023-2-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 23 15:38:39 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51768edf23679025111766
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:05:25AM +0530, Varun Sethi wrote:
> Added the following domain attributes for the FSL PAMU driver:
> 1. Added new iommu stash attribute, which allows setting of the
>    LIODN specific stash id parameter through IOMMU API.
> 2. Added an attribute for enabling/disabling DMA to a particular
>    memory window.
> 3. Added domain attribute to check for PAMUV1 specific constraints.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> v14 changes:
> - Add FSL prefix to PAMU attributes.
> v13 changes:
> - created a new file include/linux/fsl_pamu_stash.h for stash
> attributes.
> v12 changes:
> - Moved PAMU specifc stash ids and structures to PAMU header file.
> - no change in v11.
> - no change in v10.
>  include/linux/fsl_pamu_stash.h |   39 +++++++++++++++++++++++++++++++++++++++

Isn't asm/ for your architecture a better place for that header?


	Joerg


