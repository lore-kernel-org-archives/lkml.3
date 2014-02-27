Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaB0A6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:58:25 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:55893 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbaB0A6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:58:23 -0500
Message-ID: <530E8DAD.3080604@iki.fi>
Date: Thu, 27 Feb 2014 02:58:21 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Vcelak <jv@fcelda.cz>, linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] [media] rtl28xxu: add chipset version comments
 into device list
References: <530DB488.9030901@iki.fi> <1393439620-7993-1-git-send-email-jv@fcelda.cz> <1393439620-7993-2-git-send-email-jv@fcelda.cz>
In-Reply-To: <1393439620-7993-2-git-send-email-jv@fcelda.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.75
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!
Antti

On 26.02.2014 20:33, Jan Vcelak wrote:
> Signed-off-by: Jan Vcelak <jv@fcelda.cz>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index b9eb662..ab1deac 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1382,6 +1382,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
>   };
>
>   static const struct usb_device_id rtl28xxu_id_table[] = {
> +	/* RTL2831U devices: */
>   	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
>   		&rtl2831u_props, "Realtek RTL2831U reference design", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT,
> @@ -1389,6 +1390,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2,
>   		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
>
> +	/* RTL2832U devices: */
>   	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2832,
>   		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
> @@ -1432,6 +1434,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
>   		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
>
> +	/* RTL2832P devices: */
>   	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
>   		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
>   	{ }
>


-- 
http://palosaari.fi/
