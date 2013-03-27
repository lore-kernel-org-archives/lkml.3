Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3C0NQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:16:04 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64457 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3C0NQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <1363959373-10671-6-git-send-email-ian@slimlogic.co.uk>
References: <1363959373-10671-1-git-send-email-ian@slimlogic.co.uk>
	<1363959373-10671-6-git-send-email-ian@slimlogic.co.uk>
Date: Wed, 27 Mar 2013 14:15:57 +0100
Message-ID: <CACRpkdbc3U=4T4P-CtbzU1Ds4Fupno__AkZjPRenzdwW0jEOjg@mail.gmail.com>
Subject: Re: [PATCH v9 05/11] gpio: palmas: add in GPIO support for palmas charger
From: Linus Walleij <linus.walleij@linaro.org>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, cooloney@gmail.com,
        sfr@canb.auug.org.au, rpurdie@rpsys.net, akpm@linux-foundation.org,
        sameo@linux.intel.com, wim@iguana.be, lgirdwood@gmail.com,
        gg@slimlogic.co.uk, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 2:36 PM, Ian Lartey <ian@slimlogic.co.uk> wrote:

> Palmas charger has 16 GPIOs
> add palmas_gpio_[read|write|update] api to take account
> second bank of GPIOs
>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/gpio/gpio-palmas.c |   77 ++++++++++++++++++++++++++++++++++++--------
>  include/linux/mfd/palmas.h |   12 ++++++-
>  2 files changed, 74 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
> index e3a4e56..636648c 100644
> --- a/drivers/gpio/gpio-palmas.c
> +++ b/drivers/gpio/gpio-palmas.c
> @@ -1,7 +1,7 @@
>  /*
> - * TI Palma series PMIC's GPIO driver.
> + * TI Palmas series PMIC's GPIO driver.
>   *
> - * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + * Copyright (c) 2012-2012, NVIDIA CORPORATION.  All rights reserved.

Do you mean 2012-2013?

Anyway, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
