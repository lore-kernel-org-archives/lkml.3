Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039Ab3DISrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:47:20 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:56885 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3DISrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:47:18 -0400
Message-ID: <516461FE.4020007@iki.fi>
Date: Tue, 09 Apr 2013 21:46:22 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH -next] media:
References: <20130408174343.cc13eb1972470d20d38ecff1@canb.auug.org.au> <51630297.2040803@infradead.org>
In-Reply-To: <51630297.2040803@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.187.254
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 08:47 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix randconfig error when USB is not enabled:
>
> ERROR: "usb_control_msg" [drivers/media/common/cypress_firmware.ko] undefined!
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Antti Palosaari <crope@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/common/Kconfig |    1 +
>   1 file changed, 1 insertion(+)
>
> --- linux-next-20130408.orig/drivers/media/common/Kconfig
> +++ linux-next-20130408/drivers/media/common/Kconfig
> @@ -18,6 +18,7 @@ config VIDEO_TVEEPROM
>
>   config CYPRESS_FIRMWARE
>   	tristate "Cypress firmware helper routines"
> +	depends on USB
>
>   source "drivers/media/common/b2c2/Kconfig"
>   source "drivers/media/common/saa7146/Kconfig"
>


-- 
http://palosaari.fi/
