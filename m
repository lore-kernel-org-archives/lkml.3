Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaJ0NUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:20:32 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34844 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0NUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:20:31 -0400
MIME-Version: 1.0
In-Reply-To: <1412351606-29453-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412351606-29453-1-git-send-email-tomeu.vizoso@collabora.com>
Date: Mon, 27 Oct 2014 14:20:30 +0100
Message-ID: <CAPDyKFrp0cqUhH-2XUhCiMdWonb6TJ_v6TA9568KUKEx5=CGDA@mail.gmail.com>
Subject: Re: [PATCH] mmc: sunxi: Remove unused includes of linux/clk-private.h
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>, Chris Ball <chris@printf.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?Q?David_Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2014 17:53, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sunxi-mmc.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
> index 024f67c..647955d 100644
> --- a/drivers/mmc/host/sunxi-mmc.c
> +++ b/drivers/mmc/host/sunxi-mmc.c
> @@ -21,7 +21,6 @@
>  #include <linux/err.h>
>
>  #include <linux/clk.h>
> -#include <linux/clk-private.h>
>  #include <linux/clk/sunxi.h>
>
>  #include <linux/gpio.h>
> --
> 1.9.3
>
