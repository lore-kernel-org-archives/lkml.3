Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3LRSUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:20:55 -0500
Received: from mxout1.idt.com ([157.165.5.25]:49297 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab3LRSUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:20:54 -0500
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Matt Porter <mporter@kernel.crashing.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 1/3] drivers: rapidio: Include appropriate header file
 in rio-access.c
Thread-Topic: [PATCH 1/3] drivers: rapidio: Include appropriate header file
 in rio-access.c
Thread-Index: AQHO+MqQHgLSE+Gw3UatrEbOTV5IFZpaSYBg
Date: Wed, 18 Dec 2013 18:20:37 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BED3265@corpmail1.na.ads.idt.com>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
In-Reply-To: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBIILKfb012684

On Sat, Dec 14, 2013 at 7:46AM, Rashika Kheria wrote:
> Subject: [PATCH 1/3] drivers: rapidio: Include appropriate header file
> in rio-access.c
> 
> This patch includes appropriate header file linux/rio_drv.h in
> rio-access.c because functions __rio_local_read_config_8,
> __rio_local_read_config_16, __rio_local_read_config_32,
> __rio_local_write_config_8, __rio_local_write_config_16,
> __rio_local_write_config_32, rio_mport_read_config_8,
> rio_mport_read_config_16, rio_mport_read_config_32,


... skip ...

> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/rapidio/rio-access.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rapidio/rio-access.c b/drivers/rapidio/rio-
> access.c
> index a3824ba..5e6c7eb 100644
> --- a/drivers/rapidio/rio-access.c
> +++ b/drivers/rapidio/rio-access.c
> @@ -11,6 +11,7 @@
>   */
> 
>  #include <linux/rio.h>
> +#include <linux/rio_drv.h>
>  #include <linux/module.h>
> 
>  /*
> --
> 1.7.9.5

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
