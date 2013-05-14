Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3ENXsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 19:48:08 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58121 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab3ENXsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 19:48:06 -0400
Message-ID: <5192CD0B.40306@iki.fi>
Date: Wed, 15 May 2013 02:47:23 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgxaB1c3Rlaw==?= <sustmidown@centrum.cz>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rtl28xxu: Add USB ID for Leadtek WinFast DTV
 Dongle mini
References: <1368574931-12146-1-git-send-email-sustmidown@centrum.cz>
In-Reply-To: <1368574931-12146-1-git-send-email-sustmidown@centrum.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 82.128.191.26
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:42 AM, Miroslav Šustek wrote:
> USB ID 0413:6a03 is Leadtek WinFast DTV Dongle mini.
> Decoder Realtek RTL2832U and tuner Infineon TUA9001.
>
> Signed-off-by: Miroslav Šustek <sustmidown@centrum.cz>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 22015fe..d220ccc 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1408,6 +1408,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
>   		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03,
> +		&rtl2832u_props, "WinFast DTV Dongle mini", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>


-- 
http://palosaari.fi/
