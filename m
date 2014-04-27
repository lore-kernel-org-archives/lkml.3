Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaD0WTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:19:15 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:54998 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaD0WTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG=RuYdtfjJf5wKG92KdyKuG6AiBHp2_OSH8Wemi3yQOsouMQ@mail.gmail.com>
References: <CAGG=RuYdtfjJf5wKG92KdyKuG6AiBHp2_OSH8Wemi3yQOsouMQ@mail.gmail.com>
Date: Sun, 27 Apr 2014 15:19:12 -0700
X-Google-Sender-Auth: t42KXwYWpqBLqX-HFz6ET2zlfEM
Message-ID: <CA+55aFzhydSCJqMLoUX59cLpiwbnoXtL524O5VtQ4-CVj8HxyA@mail.gmail.com>
Subject: Re: [PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for
 rtl28xxu driver
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Brian Healy <healybrian@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian, please use

 ./scripts/get_maintainer -f drivers/media/usb/dvb-usb-v2/rtl28xxu.c

to get the proper people to send this to, so that it doesn't get lost
in the flood in lkml.

The indentation of that new entry also seems to be suspect, in that it
doesn't match the ones around it.

Quoting full email for context for people added.

             Linus

On Sat, Apr 26, 2014 at 9:36 AM, Brian Healy <healybrian@gmail.com> wrote:
> [PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for rtl28xxu driver
>
> Signed-off-by: Brian Healy <healybrian<at>gmail.com>
>
>
> --- drivers/media/usb/dvb-usb-v2/rtl28xxu.c.orig    2014-04-26
> 17:02:36.068691000 +0100
> +++ drivers/media/usb/dvb-usb-v2/rtl28xxu.c    2014-04-26
> 17:03:11.944691000 +0100
> @@ -1499,6 +1499,8 @@ static const struct usb_device_id rtl28x
>          &rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
>      { DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
>          &rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
> +        { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
> +                &rtl2832u_props, "Peak DVB-T USB", NULL) },
>
>      /* RTL2832P devices: */
>      { DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
