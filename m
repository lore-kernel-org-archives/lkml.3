Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab3E1MmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:42:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25964 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206Ab3E1MmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:42:07 -0400
Message-ID: <51A4A51B.1050206@huawei.com>
Date: Tue, 28 May 2013 20:37:47 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <ohad@wizery.com>, <joerg.roedel@amd.com>, <davidb@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>, <Varun.Sethi@freescale.com>,
        <iommu@lists.linux-foundation.org>, <mingo@kernel.org>,
        <ddutile@redhat.com>
Subject: Re: [PATCH] msm: iommu: fix leak and invalid access
References: <51931347.7020600@huawei.com> <519C5E8F.7060006@huawei.com> <20130528122754.GD2575@8bytes.org>
In-Reply-To: <20130528122754.GD2575@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/28 20:27, Joerg Roedel wrote:
> On Wed, May 22, 2013 at 01:58:39PM +0800, Libo Chen wrote:
>>>
>>> This patch merge two patch that I sended before:
>>> 1. msm: iommu: add missing platform_device_unregister() in err case
>>> 2. msm: iommu: no need kfree before kzalloc successful
>>>
>>> It fixes two obvious problems:
>>> 1. We have registered msm_iommu_driver first, and need unregister it when
>>> registered msm_iommu_ctx_driver fail
>>>
>>> 2. We don`t need to kfree drvdata before kzalloc successful
>>>
>>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>>> ---
>>>  drivers/iommu/msm_iommu_dev.c |   11 +++++------
>>>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> Has this patch already been handled? If not please resend it to me and I
> will take care of it.
> 
> 

It should be included to -mm tree by Andrew Morton


Regards,

Libo

> 	Joerg
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


