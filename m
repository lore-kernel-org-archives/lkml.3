Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3BMLOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:14:05 -0500
Received: from 8bytes.org ([85.214.48.195]:45863 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933708Ab3BMLOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:14:03 -0500
Date: Wed, 13 Feb 2013 12:13:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH 2/5] iommu: remove redundant NULL check before
 dma_ops_domain_free().
Message-ID: <20130213111357.GD25591@8bytes.org>
References: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
 <1360641713-24895-3-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360641713-24895-3-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 13 12:13:58 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 511b757622973015415003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 05:01:50AM +0100, Cyril Roelandt wrote:
> dma_ops_domain_free on a NULL pointer is a no-op, so the NULL check in
> amd_iommu_init_dma_ops() can be removed.
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/iommu/amd_iommu.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to x86/amd, Thanks.


