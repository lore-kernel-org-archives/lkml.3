Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3LRSXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:23:07 -0500
Received: from mxout1.idt.com ([157.165.5.25]:49382 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab3LRSXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:23:05 -0500
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Matt Porter <mporter@kernel.crashing.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 2/3] drivers: rapidio: Include appropriate header file
 in rio-driver.c
Thread-Topic: [PATCH 2/3] drivers: rapidio: Include appropriate header file
 in rio-driver.c
Thread-Index: AQHO+Msg9s8PpNV+YkKTmJH0smjz05paSmgg
Date: Wed, 18 Dec 2013 18:22:55 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BED3278@corpmail1.na.ads.idt.com>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
 <955c21bd0ce986e1e616f8f912a57568421f5078.1386926041.git.rashika.kheria@gmail.com>
In-Reply-To: <955c21bd0ce986e1e616f8f912a57568421f5078.1386926041.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBIINDwo012742

On Sat, Dec 14, 2013 at 7:50AM, Rashika Kheria wrote:
> Subject: [PATCH 2/3] drivers: rapidio: Include appropriate header file
> in rio-driver.c
> 
> This patch includes the header file linux/rio_drv.h in rio-driver.c
> because functions rio_dev_get(), rio_dev_put(), rio_register_driver()
> and rio_unregister_driver() have their prototype declarations in
> linux/rio_drv.h.
> 
> Thus, it also eliminates the following warnings in rio-driver.c:
> 
> drivers/rapidio/rio-driver.c:57:17: warning: no previous prototype for
> â€˜rio_dev_getâ€™ [-Wmissing-prototypes]
> drivers/rapidio/rio-driver.c:74:6: warning: no previous prototype for
> â€˜rio_dev_putâ€™ [-Wmissing-prototypes]
> drivers/rapidio/rio-driver.c:143:5: warning: no previous prototype for
> â€˜rio_register_driverâ€™ [-Wmissing-prototypes]
> drivers/rapidio/rio-driver.c:162:6: warning: no previous prototype for
> â€˜rio_unregister_driverâ€™ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/rapidio/rio-driver.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-
> driver.c
> index c9ae692..df73419 100644
> --- a/drivers/rapidio/rio-driver.c
> +++ b/drivers/rapidio/rio-driver.c
> @@ -13,6 +13,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/rio.h>
> +#include <linux/rio_drv.h>
>  #include <linux/rio_ids.h>
> 
>  #include "rio.h"
> --
> 1.7.9.5

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
