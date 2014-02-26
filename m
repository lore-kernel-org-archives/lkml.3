Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaBZJb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:31:56 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:36403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaBZJby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:31:54 -0500
Message-ID: <530DB488.9030901@iki.fi>
Date: Wed, 26 Feb 2014 11:31:52 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Vcelak <jv@fcelda.cz>, linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
References: <1393374645-4568-1-git-send-email-jv@fcelda.cz>
In-Reply-To: <1393374645-4568-1-git-send-email-jv@fcelda.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.187.87
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank for the patch.

Even I didn't added any comment to driver ID list, which apparently 
should be there, that empty line before "Astrometa DVB-T2" entry was 
there because I wanted to separate RTL2832P entries from RTL2832U 
entries (different chipset version). So if possible, could you provide a 
new patch which adds that entry after the last RTL2832U device :) Maybe 
some comment like "RTL2832P" could be nice too... I hope this is not too 
much work for you, my mistake...

regards
Antti


On 26.02.2014 02:30, Jan Vcelak wrote:
> 0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]
>
> The USB dongle uses RTL2832U demodulator and FC0012 tuner.
>
> Signed-off-by: Jan Vcelak <jv@fcelda.cz>
> ---
>
> The patch adds support for the Genius TVGo DVB-T03 USB dongle.
>
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index fda5c64..bb051c9 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1432,6 +1432,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>
>   	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
>   		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
> +		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>


-- 
http://palosaari.fi/
