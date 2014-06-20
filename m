Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaFTBII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 21:08:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23343 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaFTBIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 21:08:06 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-89-53a389745dc6
Message-id: <53A38974.90903@samsung.com>
Date: Fri, 20 Jun 2014 10:08:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Subject: Re: [PATCH] extcon: palmas: Make of_device_id array const
References: <000301cf8ab6$02ebea10$08c3be30$%han@samsung.com>
In-reply-to: <000301cf8ab6$02ebea10$08c3be30$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkULekc3GwwYoGSYv+LS4WlxdeYrW4
	8LSHzeLyrjlsFrcbV7A5sHr0bVnF6DF1yl9Gj+M3tjN5fN4kF8ASxWWTkpqTWZZapG+XwJVx
	qms1Y8FX9oqmt29ZGxgPs3UxcnJICJhIrDhylR3CFpO4cG89UJyLQ0hgKaPEoTltrDBFG+5/
	YAGxhQQWMUrMvVkLUfSaUeLq3TdMXYwcHLwCGhLnNqaB1LAIqEqs6j8KNpRNQEti/4sbYMtE
	BcIkVk6/AjaHV0BQ4sfke2C2iICKxOf1x8EWMwvMY5Q403MaLCEs4CTx/dxXJojFthIXH78F
	i3MK2En83jwfLM4soCOxv3UaG4QtL7F5zVtmkEESArvYJc4vfcAKcZGAxLfJh1hADpUQkJXY
	dIAZ4jFJiYMrbrBMYBSbheSmWUjGzkIydgEj8ypG0dSC5ILipPQiI73ixNzi0rx0veT83E2M
	wLg6/e9Z3w7GmwesDzEmA62cyCwlmpwPjMu8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cC4sn2VafQvzl2GW/cXFC8oCDjuc5qlWZRRRk5Fe8O0
	7P+fX4hKKE0KTjyReiyon2XK54jnJ1LvZHD/b0xP403JPhVW//Vfz4wc1y86oUsn6/hKLi0W
	5VHfFp98a8fCkLtza8K+tIkHppdP5zm0Mej2F9XZ4tGTOr+4rXzNb3MsmlWg7+2C+RFKLMUZ
	iYZazEXFiQAAeS8ZwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG5J5+Jgg9P/BC36t7hYXF54idXi
	wtMeNovLu+awWdxuXMHmwOrRt2UVo8fUKX8ZPY7f2M7k8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYQ1jxqmu1YwFX9krmt6+ZW1gPMzWxcjJISFgIrHh/gcWCFtM
	4sK99WBxIYFFjBJzb9Z2MXIB2a8ZJa7efcPUxcjBwSugIXFuYxpIDYuAqsSq/qPsIDabgJbE
	/hc3wHpFBcIkVk6/AjaTV0BQ4sfke2C2iICKxOf1x9lAZjILzGOUONNzGiwhLOAk8f3cVyaI
	xbYSFx+/BYtzCthJ/N48HyzOLKAjsb91GhuELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYKj9pnUDsaVDRaHGAU4GJV4eDtMFwcLsSaWFVfmHmKU
	4GBWEuE93Q4U4k1JrKxKLcqPLyrNSS0+xJgMDIKJzFKiyfnAhJJXEm9obGJmZGlkbmhhZGxO
	mrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzzRSwm+rgxV4lbqXm8Lrk+IeaBednZJXmC
	aV32j866B0/p3/JfQcTCbbPiu17uOSXuhxw046cl3eTo/1I6V87wr5HkkssX7t1y/C85f1OC
	S5Zp0/7MZUv//Hv81PHz7nf+3ywLXxrJB/dYSR/K9S/Zzd7zdJtjQXZ09/3p8bU7f336sSnE
	464SS3FGoqEWc1FxIgAwuIX+HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 06/18/2014 02:27 PM, Jingoo Han wrote:
> Make of_device_id array const, because all OF functions handle
> it as const.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/extcon/extcon-palmas.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index 7417ce8..5efa96c 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -278,7 +278,7 @@ static int palmas_usb_resume(struct device *dev)
>  
>  static SIMPLE_DEV_PM_OPS(palmas_pm_ops, palmas_usb_suspend, palmas_usb_resume);
>  
> -static struct of_device_id of_palmas_match_tbl[] = {
> +static const struct of_device_id of_palmas_match_tbl[] = {
>  	{ .compatible = "ti,palmas-usb", },
>  	{ .compatible = "ti,palmas-usb-vid", },
>  	{ .compatible = "ti,twl6035-usb", },
> 

The same patch was applied by Krzysztof Kozlowski on extcon-next branch. 

Thanks,
Chanwoo Choi
