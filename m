Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab3DYP6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:58:44 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:56711 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab3DYP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:58:43 -0400
Message-ID: <51795289.2040608@iki.fi>
Date: Thu, 25 Apr 2013 18:58:01 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] anysee: Grammar s/report the/report to/
References: <1366803406-17738-1-git-send-email-geert@linux-m68k.org> <1366803406-17738-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1366803406-17738-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.187.254
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 02:36 PM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>


Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/usb/dvb-usb-v2/anysee.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
> index 3a1f976..1760fee 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.c
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.c
> @@ -885,7 +885,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
>   		/* we have no frontend :-( */
>   		ret = -ENODEV;
>   		dev_err(&d->udev->dev, "%s: Unsupported Anysee version. " \
> -				"Please report the " \
> +				"Please report to " \
>   				"<linux-media@vger.kernel.org>.\n",
>   				KBUILD_MODNAME);
>   	}
>


-- 
http://palosaari.fi/
