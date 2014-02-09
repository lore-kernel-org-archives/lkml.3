Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaBITOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:14:21 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4342 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaBITOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:14:20 -0500
Message-ID: <52F7D363.2080108@xs4all.nl>
Date: Sun, 09 Feb 2014 20:13:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 19/28] Remove SI4713
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-20-git-send-email-richard@nod.at>
In-Reply-To: <1391971686-9517-20-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 07:47 PM, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.

NACK.

It's not an orphan, it's a typo. It should be I2C_SI4713.

Paul, Richard, let me handle this. I'll make a patch for this tomorrow (I believe
there was a report about a missing I2C dependency as well) and make sure it ends
up in a pull request for 3.14.

Regards,

	Hans

> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/media/radio/si4713/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
> index a7c3ba8..ed51ed0 100644
> --- a/drivers/media/radio/si4713/Kconfig
> +++ b/drivers/media/radio/si4713/Kconfig
> @@ -1,7 +1,6 @@
>  config USB_SI4713
>  	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
>  	depends on USB && RADIO_SI4713
> -	select SI4713
>  	---help---
>  	  This is a driver for USB devices with the Silicon Labs SI4713
>  	  chip. Currently these devices are known to work.
> @@ -16,7 +15,6 @@ config USB_SI4713
>  config PLATFORM_SI4713
>  	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
>  	depends on I2C && RADIO_SI4713
> -	select SI4713
>  	---help---
>  	  This is a driver for I2C devices with the Silicon Labs SI4713
>  	  chip.
> 

