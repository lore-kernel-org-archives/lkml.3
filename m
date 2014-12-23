Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaLWXqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:46:51 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38074 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaLWXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:46:49 -0500
MIME-Version: 1.0
In-Reply-To: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
Date: Wed, 24 Dec 2014 00:46:48 +0100
Message-ID: <CACna6rwTwrZurN+bgerQu_UPsTTv=1iB-C3_MeMiQN0GSyDoMg@mail.gmail.com>
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than
 80 characters per line.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2014 at 00:55, Oscar Forner Martinez
<oscar.forner.martinez@gmail.com> wrote:
> Three lines with more than 80 characters per line have been split in several lines.
>
> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
> ---
>  drivers/bcma/driver_chipcommon.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
> index 19f6796..1956918 100644
> --- a/drivers/bcma/driver_chipcommon.c
> +++ b/drivers/bcma/driver_chipcommon.c
> @@ -79,7 +79,8 @@ static int bcma_chipco_watchdog_ticks_per_ms(struct bcma_drv_cc *cc)
>
>         if (cc->capabilities & BCMA_CC_CAP_PMU) {
>                 if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
> -                       /* 4706 CC and PMU watchdogs are clocked at 1/4 of ALP clock */
> +                       /* 4706 CC and PMU watchdogs are clocked */
> +                       /* at 1/4 of ALP clock */

I don't think we use comments like this. Use normal multiline comment,
also see which one is preferred for that tree.


> -               bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
> +               bcma_err(cc->core->bus,
> +                        "serial not supported on this device ccrev: 0x%x\n",
> +                        ccrev);

I think some subsystems agreed to keep dev/bus pointed and string in
the one line. It makes more sense for me too.
