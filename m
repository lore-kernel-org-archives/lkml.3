Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaG3I5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:57:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38025 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaG3I5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:57:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Li Yang <leoli@freescale.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] MAINTAINERS: Update usb/gadget patterns
Date: Wed, 30 Jul 2014 10:58:02 +0200
Message-ID: <3040193.IdGZMy9E2c@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <d07bbb44f8c937d7e10a0b7a52689ca59d55b787.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com> <d07bbb44f8c937d7e10a0b7a52689ca59d55b787.1406691397.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thank you for the patch.

On Tuesday 29 July 2014 20:38:40 Joe Perches wrote:
> Several commits have moved files around, update the section patterns.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>
> cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> cc: Li Yang <leoli@freescale.com>
> cc: Eric Miao <eric.y.miao@gmail.com>
> cc: Russell King <linux@arm.linux.org.uk>
> cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>  MAINTAINERS | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 66d5894..6033aaf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -596,7 +596,7 @@ AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
>  M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
>  L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
>  S:	Supported
> -F:	drivers/usb/gadget/amd5536udc.*
> +F:	drivers/usb/gadget/udc/amd5536udc.*
> 
>  AMD GEODE PROCESSOR/CHIPSET SUPPORT
>  P:	Andres Salomon <dilinger@queued.net>
> @@ -1688,7 +1688,7 @@ ATMEL USBA UDC DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Supported
> -F:	drivers/usb/gadget/atmel_usba_udc.*
> +F:	drivers/usb/gadget/udc/atmel_usba_udc.*
> 
>  ATMEL WIRELESS DRIVER
>  M:	Simon Kelley <simon@thekelleys.org.uk>
> @@ -3798,7 +3798,7 @@ M:	Li Yang <leoli@freescale.com>
>  L:	linux-usb@vger.kernel.org
>  L:	linuxppc-dev@lists.ozlabs.org
>  S:	Maintained
> -F:	drivers/usb/gadget/fsl*
> +F:	drivers/usb/gadget/udc/fsl*
> 
>  FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
>  M:	Li Yang <leoli@freescale.com>
> @@ -7232,7 +7232,7 @@ S:	Maintained
>  F:	arch/arm/mach-pxa/
>  F:	drivers/pcmcia/pxa2xx*
>  F:	drivers/spi/spi-pxa2xx*
> -F:	drivers/usb/gadget/pxa2*
> +F:	drivers/usb/gadget/udc/pxa2*
>  F:	include/sound/pxa2xx-lib.h
>  F:	sound/arm/pxa*
>  F:	sound/soc/pxa/
> @@ -9576,8 +9576,8 @@ USB WEBCAM GADGET
>  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:	linux-usb@vger.kernel.org
>  S:	Maintained
> -F:	drivers/usb/gadget/*uvc*.c
> -F:	drivers/usb/gadget/webcam.c
> +F:	drivers/usb/gadget/function/*uvc*.c
> +F:	drivers/usb/gadget/legacy/webcam.c
> 
>  USB WIRELESS RNDIS DRIVER (rndis_wlan)
>  M:	Jussi Kivilinna <jussi.kivilinna@iki.fi>

-- 
Regards,

Laurent Pinchart

