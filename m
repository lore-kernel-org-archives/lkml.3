Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3GCMLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:11:20 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:58051 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GCMLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
References: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
Date: Wed, 3 Jul 2013 20:11:18 +0800
Message-ID: <CACDNBm1NdERzf_MJ4Mm26uJ1Eeq8cg3rJVhkc7yNVfAFqe2OJA@mail.gmail.com>
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

Hi, all
Do you have any comments about this patch set? Thanks!

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
