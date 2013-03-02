Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab3CBEy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:54:26 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:56838 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBEyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:54:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHw7-LJx31poPqxn_GRfEDyfReqeYTPX7Fqwzi7vtC98UQ@mail.gmail.com>
References: <CAK9yfHw7-LJx31poPqxn_GRfEDyfReqeYTPX7Fqwzi7vtC98UQ@mail.gmail.com>
Date: Sat, 2 Mar 2013 10:24:24 +0530
Message-ID: <CAK9yfHyfmduqZtvzGnXT7Mf6JF6vZu8LVv51MNA5jmbNNvjm-w@mail.gmail.com>
Subject: Re: Boot failure on Origen board using latest kernel
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Padmavathi Venna <padma.v@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Koul, Vinod" <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Padma,

Here is the short boot log with earlyprintk enabled. This is in the non-dt case.

EXYNOS4210 PMU Initialize
EXYNOS: Initializing architecture
s3c24xx-pwm s3c24xx-pwm.0: tin at 50000000, tdiv at 50000000, tin=divclk, base 0
bio: create slab <bio-0> at 0
SCSI subsystem initialized
Switching to clocksource mct-frc
ROMFS MTD (C) 2007 Red Hat, Inc.
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
dma-pl330 dma-pl330.0: Loaded driver for PL330 DMAC-267056
dma-pl330 dma-pl330.0:  DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
of_dma_controller_register: not enough information provided
dma-pl330 dma-pl330.0: unable to register DMA to the generic DT DMA helpers
dma-pl330: probe of dma-pl330.0 failed with error -22



On 2 March 2013 09:40, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Padma,
>
> While trying to boot the latest mainline kernel (Linus tree tip at
> commit b0af9cd9) on Exynos4210 based Origen board, it stops at
> "Uncompressing Linux... done, booting the kernel."
>
> Git bisect pointed to the commit 421da89aa ("DMA: PL330: Register the
> DMA controller with the generic DMA helpers").
> Reverting this commit helped me boot the board again.
> Could you please look into this?
>
> --
> With warm regards,
> Sachin



-- 
With warm regards,
Sachin
