Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805Ab3EBRiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:38:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab3EBRiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:38:00 -0400
Message-ID: <5182A44E.7080701@redhat.com>
Date: Thu, 02 May 2013 14:37:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 22/22] radio-si4713: depend on SND_SOC
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-23-git-send-email-arnd@arndb.de>
In-Reply-To: <1367507786-505303-23-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-05-2013 12:16, Arnd Bergmann escreveu:
> It is not possible to select SND_SOC_SI476X if we have not also
> enabled SND_SOC.
>
> warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet
> 	 direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC)
>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/media/radio/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index c0beee2..d529ba7 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -22,6 +22,7 @@ config RADIO_SI476X
>   	tristate "Silicon Laboratories Si476x I2C FM Radio"
>   	depends on I2C && VIDEO_V4L2
>   	depends on MFD_SI476X_CORE
> +	depends on SND_SOC
>   	select SND_SOC_SI476X
>   	---help---
>   	  Choose Y here if you have this FM radio chip.
>

Do you prefer to send it via your tree or via mine? Either way works for me.

If you're willing to send it via your tree:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
