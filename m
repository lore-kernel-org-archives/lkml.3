Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3C0XSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:18:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47822 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3C0XST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:18:19 -0400
X-AuditID: cbfee68d-b7f786d000005188-2d-51537e39c2ad
Message-id: <51537E3A.9050606@samsung.com>
Date: Thu, 28 Mar 2013 08:18:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH 2/2] extcon: max8997: Fix return value
References: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
 <1364383410-15093-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1364383410-15093-2-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zXV3LuuBAg4mHzS0u75rDZnG7cQWb
	xZTDX1gsTv7pZXRg8bhzbQ+bR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVcaH3CXjCdp+LP
	0U72BsYGri5GTg4JAROJR9OeMUHYYhIX7q1nA7GFBJYxSszZEAtT0967EijOBRRfxCix5PwC
	RgjnBaPEht0fWUGqeAW0JO6/PckOYrMIqEps/fMabCobUHz/ixtgU0UFwiRWTr/CAlEvKPFj
	8j0wWwSo5mX3cqB6Dg5mAT+JiXuDQMLCAlYSPUc6oRa3Mko0nn8BNp9TwEPi1dcNYL3MAjoS
	+1unsUHY8hKb17xlBmmQEFjGLrH1UDMrxEECEt8mH2IBWSAhICux6QAzxGeSEgdX3GCZwCg2
	C8lJs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIVHUu4Px9gHrQ4zJQCsn
	MkuJJucDozCvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYxR/2eltpf47V8Rs+6uYV1P8pecLrnb7v3TfJdwxwcrfhBw54zbfumEbTvTmvuX1yXM
	VVy2Vjvk4qvUiSlfT7vtfrAgr0NR58A8y2NRJWFsciIbt00XmlBx/JHz8evc9bPCYm+t0WPc
	t++xnLXlOsnwqztqL93V1pHcu7pv9YfpmS/Nj8yOEJmqxFKckWioxVxUnAgAiEpwZLgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgK5lXXCgwfw+fovLu+awWdxuXMFm
	MeXwFxaLk396GR1YPO5c28Pm0bdlFaPH501yAcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGEdYwZF1qfsBdM56n4c7STvYGxgauLkZNDQsBEor13JRuELSZx4d56IJuLQ0hg
	EaPEkvMLGCGcF4wSG3Z/ZAWp4hXQkrj/9iQ7iM0ioCqx9c9rJhCbDSi+/8UNsEmiAmESK6df
	YYGoF5T4MfkemC0CVPOyezlQPQcHs4CfxMS9QSBhYQEriZ4jnVCLWxklGs+/AJvPKeAh8err
	BrBeZgEdif2t09ggbHmJzWveMk9gFJiFZMUsJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREcpc+kdzCuarA4xCjAwajEw1shEBwoxJpYVlyZe4hRgoNZSYR3Vg1QiDclsbIq
	tSg/vqg0J7X4EGMyMAQmMkuJJucDE0heSbyhsYmZkaWRmbGJubExacJK4rwHW60DhQTSE0tS
	s1NTC1KLYLYwcXBKNTDKSuxu4rTbk7EjY5uVedZtO65rDO93CDXPmXzroUbsjunzTrWHvbO2
	6bEXt6utDpQ3f2T/VG6+qITbp1Bb7vj/GSr2ryZfjzSVZj61QvH2rqkXYxz2pKbK2VrY+v6c
	xsupzF2yzPesTtj+x3ub9s8xW7ST+59Sp17Q09rZv6NPXGTX//Z64zolluKMREMt5qLiRAB7
	PhyzFgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 08:23 PM, Sachin Kamat wrote:
> Return the value obtained from the function instead of hardcoding.
> drivers/extcon/extcon-max8997.c:235 max8997_muic_set_path() info:
> why not propagate 'ret' from max8997_update_reg() instead of (-11)?
> drivers/extcon/extcon-max8997.c:248 max8997_muic_set_path() info:
> why not propagate 'ret' from max8997_update_reg() instead of (-11)?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/extcon/extcon-max8997.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 69641bc..05b76b3 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -232,7 +232,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
>  			MAX8997_MUIC_REG_CONTROL1, ctrl1, COMP_SW_MASK);
>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
> -		return -EAGAIN;
> +		return ret;
>  	}
>  
>  	if (attached)
> @@ -245,7 +245,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
>  			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
> -		return -EAGAIN;
> +		return ret;
>  	}
>  
>  	dev_info(info->dev,
OK, I agree with your opinion. So, can you fix all of these return type
on extcon-max8997.c? I'd like to receive one patch related
to modification for fixing return type.

Thanks,
Chanwoo Choi

