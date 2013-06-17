Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3FQLmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:42:03 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:63150 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab3FQLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <1370485463-30731-1-git-send-email-wangxfdu@gmail.com>
References: <1370485463-30731-1-git-send-email-wangxfdu@gmail.com>
Date: Mon, 17 Jun 2013 19:41:57 +0800
Message-ID: <CACDNBm3X9_mPkDmYCFTVJhUtYwFqycp4MSArRx6Z9reN1Jp9VA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] dma: mmp_pdma: Fix phy channels not protected issue
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Xiang Wang <wangxfdu@gmail.com>, cxie4@marvell.com,
        Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/6 Xiang Wang <wangxfdu@gmail.com>:
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
Hi, all
Do you have any comments about this patch set? Thanks!

--
Regards,
Xiang
