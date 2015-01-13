Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbbAMIde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:33:34 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63524 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbAMIdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:33:32 -0500
MIME-Version: 1.0
In-Reply-To: <20150112191702.2895.75815.stgit@notabene.brown>
References: <20150112191702.2895.75815.stgit@notabene.brown>
Date: Tue, 13 Jan 2015 09:33:31 +0100
Message-ID: <CAPDyKFrvn-BMQQ6Xn0vXt=CVLnfuX7wfWGosa4PkVHWNaJfYGA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Convert omap_hsmmc to use common devicetree parsing code.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Chris Ball <chris@printf.net>, GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 January 2015 at 20:23, NeilBrown <neilb@suse.de> wrote:
> This is another resend with mmc_gpio_set_cd_isr() now returning
> void and being EXPORTed.
>
> I included
>         WARN_ON(ctx->cd_gpio_isr);
> to guard against misuse.
>
> My goal is to get omap_hsmmc to use the common code for parsing of,
> particularly so that I can set "cap-power-off-card", which omap_hsmmc
> doesn't explicitly report.
>
> Thanks,
> NeilBrown
>
> P.S. Sorry for delay - I've been travelling.
>
> ---
>
> NeilBrown (3):
>       mmc: core: Allow host driver to provide isr for card-detect interrupts.
>       mmc: omap_hsmmc: use slot-gpio library for gpio support.
>       mmc: omap_hsmmc: use mmc_of_parse to parse common mmc configuration.
>
>
>  drivers/mmc/core/slot-gpio.c  |   18 +++++++
>  drivers/mmc/host/omap_hsmmc.c |  100 +++++++++--------------------------------
>  include/linux/mmc/slot-gpio.h |    2 +
>  3 files changed, 40 insertions(+), 80 deletions(-)
>


Thanks! Applied for next.

Kind regards
Uffe
