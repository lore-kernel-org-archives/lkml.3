Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3EVWaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:30:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17107 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3EVWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:30:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,724,1363158000"; 
   d="scan'208";a="49865015"
Date: Wed, 22 May 2013 15:30:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msm: iommu: fix leak and invalid access
Message-ID: <20130522223009.GA11823@codeaurora.org>
References: <51931347.7020600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51931347.7020600@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 12:47:03PM +0800, Libo Chen wrote:

> This patch merge two patch that I sended before:
> 1. msm: iommu: add missing platform_device_unregister() in err case
> 2. msm: iommu: no need kfree before kzalloc successful
> 
> It fixes two obvious problems:
> 1. We have registered msm_iommu_driver first, and need unregister it when
> registered msm_iommu_ctx_driver fail
> 
> 2. We don`t need to kfree drvdata before kzalloc successful
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/iommu/msm_iommu_dev.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
