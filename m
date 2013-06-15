Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3FOHwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 03:52:51 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33080 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3FOHwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 03:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <1371271908-29596-2-git-send-email-zhouqiao@marvell.com>
References: <1371271908-29596-1-git-send-email-zhouqiao@marvell.com>
	<1371271908-29596-2-git-send-email-zhouqiao@marvell.com>
Date: Sat, 15 Jun 2013 15:52:48 +0800
Message-ID: <CAMj5BkgQXxEV2Fu+HNgCpbiS=iXLK8uZY=ER5MRrfQZ0eaV4uA@mail.gmail.com>
Subject: Re: [PATCH V2] dma: mmp_tdma: disable irq when disabling dma channel
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: djbw@fb.com, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 12:51 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
> mask dma irq when disabling dma channel, so that interrupt status
> will not be set and interrupt won't come again.
>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>

Acked-by: Zhangfei Gao <zhangfei.gao@gmail.com>
