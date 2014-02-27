Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaB0A6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:58:11 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:35894 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaB0A6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:58:09 -0500
Message-ID: <530E8D9F.50200@iki.fi>
Date: Thu, 27 Feb 2014 02:58:07 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Vcelak <jv@fcelda.cz>, linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
References: <530DB488.9030901@iki.fi> <1393439620-7993-1-git-send-email-jv@fcelda.cz>
In-Reply-To: <1393439620-7993-1-git-send-email-jv@fcelda.cz>
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
> 0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]
>
> The USB dongle uses RTL2832U demodulator and FC0012 tuner.
>
> Signed-off-by: Jan Vcelak <jv@fcelda.cz>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index fda5c64..b9eb662 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1429,6 +1429,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
>   		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
> +		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
>
>   	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
>   		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
>


-- 
http://palosaari.fi/
