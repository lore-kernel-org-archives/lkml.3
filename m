Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaE1EoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:44:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34463 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbaE1EoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:44:14 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-8a-538569826f16
Message-id: <53856981.5010802@samsung.com>
Date: Wed, 28 May 2014 13:43:45 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] extcon: palmas: Make of_device_id array const
References: <1400835785-26947-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1400835785-26947-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkULcpszXYoP8Gu0X/FheL1y8MLS7v
	msNmcbtxBZsDi0ffllWMHlOn/GX0+LxJLoA5issmJTUnsyy1SN8ugSvj5uN77AVf2Ct2T13O
	1MB4jq2LkZNDQsBEor3nPiOELSZx4d56oDgXh5DAUkaJCdvWwxW92vqSCSIxnVHi2+QnLBDO
	a0aJ6ZuPsoNU8QpoSfz7v5MJxGYRUJXY0X8NLM4GFN//4gbYJFGBMImV06+wQNQLSvyYfA/M
	FhEwlDi4eztYL7NAgcSkg9PAbGEBJ4nv576C2UIC7hJnJj4Cm8kp4CHxccceNoh6HYn9rdOg
	bHmJzWveMoMcJyEwj13izulFbBAHCQBdfQhoGQdQQlZi0wFmiM8kJQ6uuMEygVFsFpKTZiEZ
	OwvJ2AWMzKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAmPo9L9nvTsYbx+wPsSYDLRyIrOU
	aHI+MAbzSuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoExYOK7S/kLj7izy4vfTNz4P8zuRIjG9B6bu/z5My7+cI8S8/rMUC7nu+mPbZzup9uT54VF
	28ddrG26ydup9bXHVtPjf4Y6t5Taou95qSJX5DT3qBSzXw4Rc5d/w++aJKytv7/jTf6zrLV3
	pJ9KvXT/9Pdl55TPvjqWwYy7Lme0tShn8y+9qK3EUpyRaKjFXFScCACrz3WctwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoG5TZmuwwSldi/4tLhavXxhaXN41
	h83iduMKNgcWj74tqxg9pk75y+jxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZ
	gaGuoaWFuZJCXmJuqq2Si0+ArltmDtAuJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPGzcf32Au+sFfsnrqcqYHxHFsXIyeHhICJxKutL5kgbDGJC/fWA8W5OIQEpjNK
	fJv8hAXCec0oMX3zUXaQKl4BLYl//3eCdbAIqErs6L8GFmcDiu9/cQNsqqhAmMTK6VdYIOoF
	JX5MvgdmiwgYShzcvR2sl1mgQGLSwWlgtrCAk8T3c1/BbCEBd4kzEx+BzeQU8JD4uGMPG0S9
	jsT+1mlQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAiOz2dSOxhXNlgcYhTgYFTi4T2wuCVYiDWxrLgy9xCjBAezkgjvn4DWYCHelMTKqtSi/Pii
	0pzU4kOMycAQmMgsJZqcD0wdeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAeNZlXebbD7GWb3de9Qpa9+DB2/Tv/lUJ+eatFzq8Z+sc8zVbyBBk2Rhe1rEx
	e321yRyZZz+CP57hvRwUo8+5r+XkpjM1N7J3txb4X9vN+bmeVe1NOpM0tzrPrsV12WZOQYsO
	Tf8YNXurpvqlgPXmyvb9PitNZ8x2sWBbeXee8+nkXQmde74vVWIpzkg01GIuKk4EANWdRhgT	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:03 PM, Krzysztof Kozlowski wrote:
> Array of struct of_device_id may be be const as expected by
> of_match_table field.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/extcon/extcon-palmas.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index ddff2b72f0a8..eb59fe564fd1 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -273,7 +273,7 @@ static int palmas_usb_resume(struct device *dev)
>  
>  static SIMPLE_DEV_PM_OPS(palmas_pm_ops, palmas_usb_suspend, palmas_usb_resume);
>  
> -static struct of_device_id of_palmas_match_tbl[] = {
> +static const struct of_device_id of_palmas_match_tbl[] = {
>  	{ .compatible = "ti,palmas-usb", },
>  	{ .compatible = "ti,palmas-usb-vid", },
>  	{ .compatible = "ti,twl6035-usb", },
> 

Applied.

Thanks,
Chanwoo Choi
