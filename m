Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKLI1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:27:36 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:37169 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaKLI1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:27:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141112035217.18267.43304.stgit@notabene.brown>
References: <20141112035217.18267.43304.stgit@notabene.brown>
Date: Wed, 12 Nov 2014 09:27:34 +0100
Message-ID: <CAPDyKFozfA2VV+xrzYWona7G8Bdro=VGphM+A=L9ar9tsXr1DA@mail.gmail.com>
Subject: Re: [PATCH 0/2] mmc: core: power-on sdio card correctly.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Chris Ball <chris@printf.net>, GTA04 owners <gta04-owner@goldelico.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 04:55, NeilBrown <neilb@suse.de> wrote:
> These two patches replace my previous patch
>   [PATCH 2/2] mmc: core: reset sdio card properly on resume.
>
> The only change is to use host->card->ocr instead of
> host->ocr_avail, as recommend by Ulf.
>
> These restore my libertas  wifi device properly on system
> resume.
>
> (I'm still hoping for a reply to my other patch:
>    [PATCH 1/2] mmc: core: allow a reset gpio to be configured.

Working on a reply. Get back to you soon. :-)

> )
>
> Thanks,
> NeilBrown
>
> ---
>
> NeilBrown (2):
>       mmc: core: use card->ocr when negotiating voltage setting in mmc_sdio_power_restore
>       mmc: core: reset sdio card properly on resume.

Thanks! Applied for next!

Kind regards
Uffe

>
>
>  drivers/mmc/core/sdio.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> --
> Signature
>
