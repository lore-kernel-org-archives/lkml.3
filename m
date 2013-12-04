Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3LDLRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:17:33 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40042 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3LDLRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:17:32 -0500
MIME-Version: 1.0
In-Reply-To: <1386145275-27438-1-git-send-email-zhouqiao@marvell.com>
References: <1386145275-27438-1-git-send-email-zhouqiao@marvell.com>
Date: Wed, 4 Dec 2013 19:17:29 +0800
Message-ID: <CAN1soZzWUh74FHeKs3acLpfQYhQBNzES9nB1tJNvwV1h4zi1Lw@mail.gmail.com>
Subject: Re: [PATCH 0/2 V1] arm-mmp-build-sram-driver-alone
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: Miao Eric <eric.y.miao@gmail.com>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Chao Xie <chao.xie@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 4:21 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
> V1 -> V0:
> No need for help text for MMP_SRAM in Kconfig and move it into MMP_TDMA
> text in Kconfig.
>
> Qiao Zhou (2):
>   arm: mmp: build sram driver alone
>   dma: mmp-tdma: select sram driver
>
>  arch/arm/mach-mmp/Kconfig  |    3 +++
>  arch/arm/mach-mmp/Makefile |    3 ++-
>  drivers/dma/Kconfig        |    2 ++
>  3 files changed, 7 insertions(+), 1 deletions(-)
>

Dan indicated that you could pack these two patches into one. Whatever
it's also OK to use two patches.

Applied.

Thanks
Haojian
