Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3C0XVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:21:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29936 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3C0XVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:21:38 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-99-51537f016b1a
Message-id: <51537F02.7090500@samsung.com>
Date: Thu, 28 Mar 2013 08:21:38 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/2] extcon: max77693: Fix return value
References: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t8zHV3G+uBAg1U7xSwu75rDZnG7cQWb
	xZTDX1gsTv7pZXRg8bhzbQ+bR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGUcXreQqWAjT8Xv
	eauYGhhnc3UxcnBICJhIbDws1MXICWSKSVy4t56ti5GLQ0hgGaPEidd/WSESJhJb+iewQiQW
	MUocu/yDCcJ5wSgxfeJrRpAqXgEtidYjp9hAbBYBVYmGzddYQGw2oPj+FzfA4qICYRIrp19h
	gagXlPgx+R6YLQJU87J7ORPIRcwCfhIT9waBhIUFrCU2Lm0FaxUScJc4fnED2CpOAQ+Jx08f
	MIPYzAI6Evtbp7FB2PISm9e8ZQa5TUJgFbvEve27WSHuEZD4NvkQC8THshKbDjBDPCYpcXDF
	DZYJjGKzkFw0C8nYWUjGLmBkXsUomlqQXFCclF5kqlecmFtcmpeul5yfu4kREkMTdzDeP2B9
	iDEZaOVEZinR5HxgDOaVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgXG349lbBWcX/F/LFsl5uyZnS/Au0ychXMdSNvtHpVfI5TnN3/0/6KmApUDU
	RZvSqrL1UUfbf1y9yDsnLJ0lIPfW4+BK7hCzZ/dbTsT8EOq8OEslwPjb5Ov7rHa2FKaerl4k
	YbmSk8XY9/mGwt/hEi+Pq8TNslud51W0M0uwsubNwpscN+71LVJiKc5INNRiLipOBAAtD4yi
	twIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgC5jfXCgwZwvAhaXd81hs7jduILN
	YsrhLywWJ//0MjqweNy5tofNo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJ6xgzDq9byFSwkafi97xVTA2Ms7m6GDk5JARMJLb0T2CFsMUkLtxbz9bFyMUh
	JLCIUeLY5R9MEM4LRonpE18zglTxCmhJtB45xQZiswioSjRsvsYCYrMBxfe/uAEWFxUIk1g5
	/QoLRL2gxI/J98BsEaCal93LgYZycDAL+ElM3BsEEhYWsJbYuLQVrFVIwF3i+MUNYKs4BTwk
	Hj99wAxiMwvoSOxvncYGYctLbF7zlnkCo8AsJBtmISmbhaRsASPzKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgGH0mvYNxVYPFIUYBDkYlHt4KgeBAIdbEsuLK3EOMEhzMSiK8s2qAQrwp
	iZVVqUX58UWlOanFhxiTgQEwkVlKNDkfmD7ySuINjU3MjCyNzIxNzI2NSRNWEuc92GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoFxzZuwxNWT0y/rnv9Q7Xnk4KtDr1bvmNQg465hYVO9v2F+Od+X
	ns0fTpYz7/j+h/FGD6vHKZngfT92nFj9udCgh9HD9firt6tnvy2q2doUO8mRb37W2Yxda5oL
	P33zDsrLsdixsivN4NtZU+nebd4vdsk7dIitktt+sb5W5dXD/Y8dbf5p7rhcpcRSnJFoqMVc
	VJwIAF1ovYcVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 08:23 PM, Sachin Kamat wrote:
> Return the value obtained from the function instead of hardcoding.
> Silences the following warning:
> drivers/extcon/extcon-max77693.c:297 max77693_muic_set_path()
> info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
> drivers/extcon/extcon-max77693.c:310 max77693_muic_set_path()
> info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/extcon/extcon-max77693.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 8f3c947..894e20e 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -294,7 +294,7 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
>  			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
> -		return -EAGAIN;
> +		return ret;
>  	}
>  
>  	if (attached)
> @@ -307,7 +307,7 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
>  			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
> -		return -EAGAIN;
> +		return ret;
>  	}
>  
>  	dev_info(info->dev,
As my comment about "extcon: max8997: Fix return value",
I wish to receive one patch which modify all of return value with 'ret'
in extcon-max77693.c.

Thanks,
Chanwoo Choi
