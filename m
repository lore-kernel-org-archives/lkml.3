Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaCSEn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:43:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40204 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaCSEn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:43:57 -0400
X-AuditID: cbfee68e-b7f566d000002344-4e-5329208bb72b
Message-id: <5329208B.3090401@samsung.com>
Date: Wed, 19 Mar 2014 13:43:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] charger-manager: Fix checking of wrong return type
References: <1395056031-13666-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1395056031-13666-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkQLdbQTPYoPGhtsX1L89ZLSY9ec9s
	MXHlZGaLs01v2C0u75rDZnG7cQWbA5vHzll32T02r9Dy6NuyitHj8ya5AJYoLpuU1JzMstQi
	fbsEroy7L54xFqzhrFi7q4+xgfEKexcjJ4eEgInE0zerWSFsMYkL99azdTFycQgJLGWUWHH2
	BzNM0YQ3/xkhEtMZJTomX4GqesUo8XPlL7BRvAJaEjenbGMCsVkEVCWerfnCCGKzAcX3v7jB
	BmKLCoRJrJx+hQWiXlDix+R7YLaIgIbEzL9XwDYwCzQxShzsnw/kcHAIC7hL3DhpB1IjJOAq
	sX7Oa7D5nAJuEl3t/8FsZgEdif2t09ggbHmJzWveQl29j11iwQ4NiHsEJL5NPsQCMlJCQFZi
	0wGoEkmJgytusExgFJuF5KJZSKbOQjJ1ASPzKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzA
	CDv971nfDsabB6wPMSYDrZzILCWanA+M0LySeENjMyMLUxNTYyNzSzPShJXEeRc9TAoSEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwKiwKu/e6pl8qzlNGs7cDPQ1cuMT9fj6YOfTEyYGJ2Mj
	WP0MY/aGL9x/o6RE58/k1O0fa0Rvv/8X/PLfu+49M64tf/hhEZtGaU0lQ+fWCctvrDMovmQh
	q3jE+vqMb5eNZs199ejbbNfzhy/NuzUz2Tq9bDL3XWUJMTaHfc7S3+6Jeu2w5Wibq2WrxFKc
	kWioxVxUnAgACrYrT8YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd1uBc1gg10nVCyuf3nOajHpyXtm
	i4krJzNbnG16w25xedccNovbjSvYHNg8ds66y+6xeYWWR9+WVYwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3H3xjLFgDWfF2l19jA2MV9i7GDk5JARMJCa8
	+c8IYYtJXLi3nq2LkYtDSGA6o0TH5CtQzitGiZ8rf4F18ApoSdycso0JxGYRUJV4tuYLWDcb
	UHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIaEjM/HuFEWQos0ATo8TB/vlADgeHsIC7xI2T
	diA1QgKuEuvnvAabzyngJtHV/h/MZhbQkdjfOo0NwpaX2LzmLfMERoFZSFbMQlI2C0nZAkbm
	VYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBEfxMagfjygaLQ4wCHIxKPLwHojSChVgTy4or
	cw8xSnAwK4nwCt8FCvGmJFZWpRblxxeV5qQWH2JMBobARGYp0eR8YHLJK4k3NDYxM7I0Mje0
	MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZGAcsNyZds7vS7bJav63M7c+fhknOT
	S2fET3/gNnORzzaOO6zspUIOLVzCatGsG1vflelWvmWW3CxUIFN/K+TC0xAH27R9qapH5t39
	diomXd2xYc7bV66J2jsqq6wWaeS38ymsO5eVsCdgbf/2fS6dPGGcC3YInfPYl1urGcQzaYHW
	34mnfrcrsRRnJBpqMRcVJwIAo1meKiQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

Thanks,
Chanwoo Choi

On 03/17/2014 08:33 PM, Chanwoo Choi wrote:
> This patch fix minor issue about checking wrong return type.
> 
> The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
> in this function. But, charger_manager_probe() has only checked whether
> desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
> isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
> DT, charger_manager_probe() can't detect error of desc instance.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/power/charger-manager.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index 9e4dab4..a10fb57 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	if (!desc) {
> +	if (IS_ERR(desc)) {
>  		dev_err(&pdev->dev, "No platform data (desc) found\n");
>  		return -ENODEV;
>  	}
> 

