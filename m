Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbaFRA6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:58:21 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:23808 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaFRA6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:58:20 -0400
Message-ID: <53A0E3DB.4010401@huawei.com>
Date: Wed, 18 Jun 2014 08:56:59 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] trivial cleanup for iommu/vt-d
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.53A0E3EA.0014,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 41e0b80c86a6f62065358914db3d07cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...

On 2014/5/20 20:37, Yijing Wang wrote:
> Some cleanup patches for iommu/vt-d.
> 
> Yijing Wang (6):
>   iommu/vt-d: Use list_for_each_safe() to simplify code
>   iommu/vt-d: move up no_iommu and dmar_disabled check
>   iommu/vt-d: clear the redundant assignment in dmar_enable_qi
>   iommu/vt-d: clear the redundant assignment for domain->nid
>   iommu/vt-d: use inline function dma_pte_superpage instead of macros
>   iommu/vt-d: fix reference count in iommu_prepare_isa
> 
>  drivers/iommu/dmar.c        |    3 ---
>  drivers/iommu/intel-iommu.c |   18 ++++++++----------
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

