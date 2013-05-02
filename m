Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3EBPYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:24:21 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:33029 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3EBPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:24:20 -0400
MIME-Version: 1.0
In-Reply-To: <1367507786-505303-23-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
	<1367507786-505303-23-git-send-email-arnd@arndb.de>
Date: Thu, 2 May 2013 11:24:18 -0400
Message-ID: <CAC-25o9Xp+pu_AUwxyh+YsiOCOebzMRF37v1VWZJD6nrbx5e6Q@mail.gmail.com>
Subject: Re: [PATCH, RFC 22/22] radio-si4713: depend on SND_SOC
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, May 2, 2013 at 11:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> It is not possible to select SND_SOC_SI476X if we have not also
> enabled SND_SOC.
>
> warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet
>          direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC)
>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Note on your patch title, this change is against si476X, not on *si4713*.



>  drivers/media/radio/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index c0beee2..d529ba7 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -22,6 +22,7 @@ config RADIO_SI476X
>         tristate "Silicon Laboratories Si476x I2C FM Radio"
>         depends on I2C && VIDEO_V4L2
>         depends on MFD_SI476X_CORE
> +       depends on SND_SOC
>         select SND_SOC_SI476X
>         ---help---
>           Choose Y here if you have this FM radio chip.
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Eduardo Bezerra Valentin
