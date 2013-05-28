Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab3E1M17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:27:59 -0400
Received: from 8bytes.org ([85.214.48.195]:59015 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933818Ab3E1M15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:27:57 -0400
Date: Tue, 28 May 2013 14:27:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: ohad@wizery.com, joerg.roedel@amd.com, davidb@codeaurora.org,
        LKML <linux-kernel@vger.kernel.org>, Varun.Sethi@freescale.com,
        iommu@lists.linux-foundation.org, mingo@kernel.org, ddutile@redhat.com
Subject: Re: [PATCH] msm: iommu: fix leak and invalid access
Message-ID: <20130528122754.GD2575@8bytes.org>
References: <51931347.7020600@huawei.com>
 <519C5E8F.7060006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519C5E8F.7060006@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 28 14:27:56 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51a4a2cc20865721246468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:58:39PM +0800, Libo Chen wrote:
> > 
> > This patch merge two patch that I sended before:
> > 1. msm: iommu: add missing platform_device_unregister() in err case
> > 2. msm: iommu: no need kfree before kzalloc successful
> > 
> > It fixes two obvious problems:
> > 1. We have registered msm_iommu_driver first, and need unregister it when
> > registered msm_iommu_ctx_driver fail
> > 
> > 2. We don`t need to kfree drvdata before kzalloc successful
> > 
> > Signed-off-by: Libo Chen <libo.chen@huawei.com>
> > ---
> >  drivers/iommu/msm_iommu_dev.c |   11 +++++------
> >  1 files changed, 5 insertions(+), 6 deletions(-)

Has this patch already been handled? If not please resend it to me and I
will take care of it.


	Joerg


