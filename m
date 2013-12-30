Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3L3OSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:18:22 -0500
Received: from 8bytes.org ([85.214.48.195]:56644 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab3L3OSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:18:20 -0500
Date: Mon, 30 Dec 2013 15:18:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: Add empty stub for iommu_group_get_by_id()
Message-ID: <20131230141816.GD2799@8bytes.org>
References: <1385016074-17026-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385016074-17026-1-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec 30 15:18:19 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52c180ab20861216811321
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:41:14PM +1100, Alexey Kardashevskiy wrote:
> Almost every function in include/linux/iommu.h has an empty stub
> but the iommu_group_get_by_id() did not get one by mistake.
> 
> This adds an empty stub for iommu_group_get_by_id() for IOMMU_API
> disabled config.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Applied, thanks.


