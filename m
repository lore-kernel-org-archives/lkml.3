Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab3EWNs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:48:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49318 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab3EWNsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:48:25 -0400
Message-ID: <519E1E26.3060106@gmail.com>
Date: Thu, 23 May 2013 21:48:22 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: wsa@the-dreams.de
CC: Libo Chen <libo.chen@huawei.com>, guz.fnst@cn.fujitsu.com,
        sonic.zhang@analog.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 3/3] i2c: pxa: use module_platform_driver() replace
 init/exit
References: <1369310411-35652-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369310411-35652-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe I make a mistake, please drop it.

ÓÚ 2013-5-23 20:00, Libo Chen Ð´µÀ:
> use module_platform_driver() macro to replace the module init/exit
> 
> Signed-off-by: Libo Chen<libo.chen@huawei.com>
> ---
>   drivers/i2c/busses/i2c-pxa.c |   10 +---------
>   1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index 7b10102..e9c3524 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1242,15 +1242,7 @@ static struct platform_driver i2c_pxa_driver = {
>   	.id_table	= i2c_pxa_id_table,
>   };
>   
> -static int __init i2c_adap_pxa_init(void)
> -{
> -	return platform_driver_register(&i2c_pxa_driver);
> -}
> -
> -static void __exit i2c_adap_pxa_exit(void)
> -{
> -	platform_driver_unregister(&i2c_pxa_driver);
> -}
> +module_platform_driver(i2c_pxa_driver);
>   
>   MODULE_LICENSE("GPL");
>   MODULE_ALIAS("platform:pxa2xx-i2c");

