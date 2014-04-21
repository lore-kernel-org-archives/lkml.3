Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaDUJrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:47:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63287 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDUJrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:47:43 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-1b-5354e93d0284
Message-id: <5354E943.1070902@samsung.com>
Date: Mon, 21 Apr 2014 18:47:47 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] extcon: max14577: Properly handle regmap_irq_get_virq error
References: <1397832450-5086-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1397832450-5086-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkWNf2ZUiwwaMD/BavXxhaXN41h83i
	duMKNosFGx8xOrB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8arKUfZCt5wVDz6voKpgXEV
	excjJ4eEgInEhO0L2SBsMYkL99aD2UICSxklFkxlhqm5PQOkhgsovohR4t7cS8wQRa8ZJbpP
	FIHYvAJaEjNeHQGLswioSlxtec8IYrMBxfe/uAE2VFQgTGLl9CssEPWCEj8m3wOzRQQMJQ7u
	3s4EYjMLJEtc3toIVi8sECDx+MNvVohdbhInr+0Gi3MKuEu0LtwEVa8jsb91GhuELS+xec1b
	ZpBDJQSms0us3rqXDeIgAYlvkw8BLeMASshKbDoA9ZikxMEVN1gmMIrNQnLSLCRjZyEZu4CR
	eRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYNyc/vesdwfj7QPWhxiTgVZOZJYSTc4Hxl1e
	SbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAuSZB/
	03tYxiS34VObsO1Ztfg5eazaz0IqlB7NsyyKTZV38OQQdzQMneDlPlcl8YpsnvklTuGc1Lrv
	qdFRXC/q/6/eJtfxe885jczomT9ZSxsDtNg50+ZeulBZ7Cv7siZraeWWWek+0bLO5n1/Pids
	0jk38WeI1tRF5fM0V2rWSfTaeC61VGIpzkg01GIuKk4EAM6LWPqxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV3blyHBBg9uc1i8fmFocXnXHDaL
	240r2CwWbHzE6MDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZr6YcZSt4w1Hx6PsKpgbGVexdjJwcEgImErdnLGSDsMUkLtxbD2RzcQgJLGKUuDf3
	EjNIQkjgNaNE94kiEJtXQEtixqsjYHEWAVWJqy3vGUFsNqD4/hc3wAaJCoRJrJx+hQWiXlDi
	x+R7YLaIgKHEwd3bmUBsZoFkictbG8HqhQUCJB5/+M0KsctN4uS13WBxTgF3idaFm6DqdST2
	t05jg7DlJTavecs8gVFgFpIVs5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cFw+k97BuKrB4hCjAAejEg/vi/yQYCHWxLLiytxDjBIczEoivBHrgUK8KYmVValF+fFFpTmp
	xYcYk4EhMJFZSjQ5H5gy8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBkbPT+3ybXflPviUKoRVik15N+u87XfpQl6hd9ZTSNDPfcykeSYVuR99GX7VbuM1C
	6KEq30mh6lQxjZ+/gn93XJni9ifjuol5bMXe5nRXplUuJYJ3HW6cchTg+ZVvdJZ5x4b7Dyff
	fpeZk/Rgsoode1NayJPXCdnXLuRprExf0Ldywqz8GyE2SizFGYmGWsxFxYkAwtL0Yg8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 11:47 PM, Krzysztof Kozlowski wrote:
> The regmap_irq_get_virq may return 0 or -EINVAL on error. Fail the probe
> in both situations.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/extcon/extcon-max14577.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
> index 3846941801b8..d58747d2ddfa 100644
> --- a/drivers/extcon/extcon-max14577.c
> +++ b/drivers/extcon/extcon-max14577.c
> @@ -650,7 +650,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
>  		unsigned int virq = 0;
>  
>  		virq = regmap_irq_get_virq(max14577->irq_data, muic_irq->irq);
> -		if (!virq)
> +		if (virq <= 0)
>  			return -EINVAL;
>  		muic_irq->virq = virq;

Applied it.

But,
IMO, Generally, if function completed the operation without problem,
return zero(0). But, irq_create_mapping() returns zero(0) when error happen.
It is necessary to modify irq_create_mapping(kernel/irq/irqdomain.c) about return value.

Thanks,
Chanwoo Choi

