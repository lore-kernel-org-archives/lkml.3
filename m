Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaJBFYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 01:24:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51586 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaJBFY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 01:24:29 -0400
Date: Thu, 2 Oct 2014 00:24:26 -0500
From: Andy Gross <agross@codeaurora.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Archit Taneja <architt@codeaurora.org>, vinod.koul@intel.com,
        galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dmaengine: qcom_bam_dma: Generalize BAM register
 offset calculations
Message-ID: <20141002052426.GB28494@qualcomm.com>
References: <1411037575-13153-1-git-send-email-architt@codeaurora.org>
 <1411965189-24499-1-git-send-email-architt@codeaurora.org>
 <20140929221406.GE11142@qualcomm.com>
 <542BB9C7.2000600@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542BB9C7.2000600@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 01:52:31PM +0530, Pramod Gurav wrote:
> Andy,
> With your change "dmaengine: qcom_bam_dma: Add v1.3.0 driver support"
> and enabling qcom_bam_dma driver i was seeing some crashes in the kernel
> on IFC6410. But after reverting you change and applying these changes
> from Vinod I see IFC6410 booting fine.

We're dropping my changes in favor of these.  So please do revert my change and
pull in this.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
