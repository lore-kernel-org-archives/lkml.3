Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3FXKel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:34:41 -0400
Received: from 8bytes.org ([85.214.48.195]:39164 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3FXKek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:34:40 -0400
Date: Mon, 24 Jun 2013 12:34:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: alex.williamson@redhat.com, Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        galak@kernel.crashing.org, stuart.yoder@freescale.com,
        scottwood@freescale.com, Timur Tabi <timur@tabi.org>
Subject: Re: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Message-ID: <20130624103435.GB2778@8bytes.org>
References: <1371744089-17780-1-git-send-email-Varun.Sethi@freescale.com>
 <1371744089-17780-2-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371744089-17780-2-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 24 12:34:38 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c820be20864298916055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:31:28PM +0530, Varun Sethi wrote:
> This patch provides the PAMU driver (fsl_pamu.c) and the corresponding IOMMU
> API implementation (fsl_pamu_domain.c). The PAMU hardware driver (fsl_pamu.c)
> has been derived from the work done by Ashish Kalra and Timur Tabi.

AlexW,

can you please have a look at the group-code again and ack the patch if
it looks right to you?

Thanks,

	Joerg


