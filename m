Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3CGEGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:06:30 -0500
Received: from f149.mail.ru ([217.69.128.104]:52495 "EHLO f149.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3CGEG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:06:28 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?RG1pdHJ5IFRvcm9raG92?= <dmitry.torokhov@gmail.com>,
        =?UTF-8?B?U3RlcGhlbiBXYXJyZW4=?= <swarren@wwwdotorg.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NiAxLzJdIG1mZDogc3lzY29uOiBSZW1vdmVkIHVubmVl?=
 =?UTF-8?B?ZGVkIGZpZWxkICJkZXYiIGZyb20gcHJpdmF0ZSBkcml2ZXIgc3RydWN0dXJl?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Thu, 07 Mar 2013 08:06:24 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1362629184.106648871@f149.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <1362063434-8318-1-git-send-email-shc_work@mail.ru>
References: <1362063434-8318-1-git-send-email-shc_work@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2746UC4019203

> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/syscon.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 61aea63..674af14 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -25,17 +25,15 @@
>  static struct platform_driver syscon_driver;
>  
>  struct syscon {
> -	struct device *dev;
>  	void __iomem *base;
>  	struct regmap *regmap;
>  };
>  
>  static int syscon_match(struct device *dev, void *data)
>  {
> -	struct syscon *syscon = dev_get_drvdata(dev);
>  	struct device_node *dn = data;
>  
> -	return (syscon->dev->of_node == dn) ? 1 : 0;
> +	return (dev->of_node == dn) ? 1 : 0;
>  }
>  
>  struct regmap *syscon_node_to_regmap(struct device_node *np)
> @@ -130,7 +128,6 @@ static int syscon_probe(struct platform_device *pdev)
>  		return PTR_ERR(syscon->regmap);
>  	}
>  
> -	syscon->dev = dev;
>  	platform_set_drvdata(pdev, syscon);
>  
>  	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> -- 
> 1.7.12.4

ping

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
