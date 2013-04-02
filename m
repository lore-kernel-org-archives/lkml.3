Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3DBPIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:08:49 -0400
Received: from 8bytes.org ([85.214.48.195]:53847 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab3DBPIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:08:48 -0400
Date: Tue, 2 Apr 2013 17:08:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: stuart.yoder@freescale.com, scottwood@freescale.com,
        iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device
 archdata
Message-ID: <20130402150842.GG15687@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 17:08:47 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515af47f23674274710299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 01:23:59AM +0530, Varun Sethi wrote:
> Add an iommu domain pointer to device (powerpc) archdata.  Devices
> are attached to iommu domains and this pointer provides a mechanism
> to correlate between a device and the associated iommu domain.  This
> field is set when a device is attached to a domain.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>

This patch needs to be Acked by the PPC maintainers.


