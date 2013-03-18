Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3CRCyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:54:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14619 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3CRCyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:54:22 -0400
X-AuditID: cbfee690-b7f656d0000007e3-d4-514681dde171
Date: Mon, 18 Mar 2013 02:54:21 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] backlight: lp855x: use PAGE_SIZE for the sysfs read
 operation
To: milo.kim@ti.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130318025301023@jg1.han
Msgkey: 20130318025301023@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130318025301023@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15748966.189511363575250499.JavaMail.weblogic@epml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zA927jW6BBs938lpc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMeLemh6mgQ7DieH8zawPjGYEuRk4OIQEliUkn9zKC2BICJhIL5uxg
	h7DFJC7cW8/WxcgFVLOMUeLBgmNMMEW75j9gh0jMZ5R4/vMMWDeLgKrEmUnLwLrZBNQlJvxu
	ZgGxhQWCJL7uOMIKYosISEj8erCMDcRmFkiWuPTjMyvEFbIS9ybPZgaxeQUEJU7OfMICsUxB
	4vmaV4wQcUWJn9O+QF0nIXHn/n5WCJtXYkb7U6h6OYlpX9cwQ9jSEudnbWCE+Wbx98dQcX6J
	Y7d3AD3DAdb75H4wzJjdm7+wQdgCElPPHIRqVZXYtWQF1Fo+iTUL30KtEpQ4fa2bGaa3YeNv
	doi3FCWmdD+EsrUkvvzYx4buLV4BJ4kns6YzTWBUnoUkNQtJ+ywk7chqFjCyrGIUTS1ILihO
	Si8yQY7tTYyQRDhhB+O9A9aHGPczAuNkIrOUaHI+MJXmlcQbGpsZWZiamBobmVuaUShsYmph
	YWJEFWElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxmuQW5O7numC/1DF315ZqN
	BEvRS+P1/aZV7DdmJj48m9yyc8KGnC/rpikdPdt6dKpN9WO18D2Ch0QU8yw1Vk3S6vA/bxNh
	0PqK4/rjbyp3TCJOuq6fq7Yvgm96TUbXLYOb1fNf9X/asFtW6NrVLTv8nW8Z/uw+pMcU6ij5
	dE3Q/7Mv/+5xeiGjxFKckWioxVxUnAgAWGDVe/cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TN27jW6BBj+XcFpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jHdrepgKOgQrjvc3szYwnhHoYuTkEBJQkph0ci8jiC0hYCKxa/4DdghbTOLCvfVsXYxcQDXz
	GSWe/zwDVsQioCpxZtIysCI2AXWJCb+bWUBsYYEgia87jrCC2CICEhK/HixjA7GZBZIlLv34
	zAqxTFbi3uTZzCA2r4CgxMmZT1gglilIPF/zihEirijxc9oXqCMkJO7c388KYfNKzGh/ClUv
	JzHt6xpmCFta4vysDYwwRy/+/hgqzi9x7PYOpi5GDrDeJ/eDYcbs3vyFDcIWkJh65iBUq6rE
	riUroNbySaxZ+BZqlaDE6WvdzDC9DRt/s0O8pSgxpfshlK0l8eXHPjZ0b/EKOEk8mTWdaQKj
	3CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqFiV5xYm5xaV66XnJ+7iZGcIp6tmQHY8MF60OM
	AhyMSjy8NzhdA4VYE8uKK3MPMUpwMCuJ8DaEuAUK8aYkVlalFuXHF5XmpBYfYkwGRuBEZinR
	5Hxg+swriTc0NjYxMzE1N7AwsDQnTVhJnPdZq3WgkEB6YklqdmpqQWoRzBYmDk6pBsaQ3jLV
	h+mZ0eUNidEWLLcNHLbJCH4vS7il+E9s3+TsU03zZWtEveu2MiaKurB9ctfZkr9hxa+SqyyT
	9t054adbqPNN8+0PDX0bW7urqo8nR2knFor1z3R4ei/y4vT31xbv+c+7+Ez2rvo5fZMU3q1s
	n7VAdK/RGa7A4B6rTWaX+bbc/ZMcEa7EUpyRaKjFXFScCABMhSJAlQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2I2sRTu013945

On Thusday, 14 Mar 2013 17:19:55 -0700, Milo(Woogyom) Kim wrote:
> The sysfs allocates PAGE_SIZE. It is used by each R/W operation method.
> Use it instead of another buffer size.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/lp855x_bl.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
> index 7ae9ae6..d47efe1 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -35,7 +35,6 @@
>  #define LP8557_EPROM_START		0x10
>  #define LP8557_EPROM_END		0x1E
>  
> -#define BUF_SIZE		20
>  #define DEFAULT_BL_NAME		"lcd-backlight"
>  #define MAX_BRIGHTNESS		255
>  
> @@ -304,7 +303,7 @@ static ssize_t lp855x_get_chip_id(struct device *dev,
>  				struct device_attribute *attr, char *buf)
>  {
>  	struct lp855x *lp = dev_get_drvdata(dev);
> -	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipname);
> +	return scnprintf(buf, PAGE_SIZE, "%s\n", lp->chipname);
>  }
>  
>  static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
> @@ -319,7 +318,7 @@ static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
>  	else if (mode == REGISTER_BASED)
>  		strmode = "register based";
>  
> -	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
> +	return scnprintf(buf, PAGE_SIZE, "%s\n", strmode);
>  }
>  
>  static DEVICE_ATTR(chip_id, S_IRUGO, lp855x_get_chip_id, NULL);
> -- 
> 1.7.9.5
>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
