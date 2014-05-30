Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaE3SWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:22:09 -0400
Received: from 8bytes.org ([85.214.48.195]:43603 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbaE3SWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:22:07 -0400
Date: Fri, 30 May 2014 20:22:04 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: guohanjun@huawei.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: msm: use devm_ioremap_resource to simplify code
Message-ID: <20140530182204.GL17056@8bytes.org>
References: <1401185922-6908-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401185922-6908-1-git-send-email-wangkefeng.wang@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri May 30 20:22:05 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5388cc4d20862581452563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 06:18:42PM +0800, Kefeng Wang wrote:
> Use devm_ioremap_resource() to make the code simpler, drop unused variable,
> redundant return value check, and error-handing code.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/iommu/msm_iommu_dev.c |   38 +++++++-------------------------------
>  1 files changed, 7 insertions(+), 31 deletions(-)

Applied to arm/msm, thanks.


