Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3GYCS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:18:56 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47889 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3GYCSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:18:54 -0400
MIME-Version: 1.0
In-Reply-To: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
References: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
Date: Thu, 25 Jul 2013 10:18:53 +0800
Message-ID: <CACDNBm0Kj1Ny5hNiK=n5UUgAprmaoLx5QXQX_9J98HW7yPqFCw@mail.gmail.com>
Subject: Re: [PATCH V3 0/2] dma: mmp_pdma: Fix phy channels not protected issue
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Xiang Wang <wangxfdu@gmail.com>, cxie4@marvell.com,
        Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, maintainers
What's the status of this patch set V3? Sorry for pushing. Thanks!

2013/6/18 Xiang Wang <wangxfdu@gmail.com>:
> From: Xiang Wang <wangx@marvell.com>
>
> This patch set deals with the issues that 1) phy channels are not protected
> in mmp_pdma. 2) dma request<->channel mapping is not cleared when a phy chan
> is freed.
>
> Xiang Wang (2):
>   dma: mmp_pdma: add protect when alloc/free phy channels
>   dma: mmp_pdma: clear DRCMR when free a phy channel
>
>  drivers/dma/mmp_pdma.c |   48 ++++++++++++++++++++++++++++++++----------------
>  1 files changed, 32 insertions(+), 16 deletions(-)
>
> --
> 1.7.5.4
>



-- 
Regards,
Xiang
