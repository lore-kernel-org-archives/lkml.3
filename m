Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaDPKo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:44:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39791 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbaDPKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:44:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee68e-b7f566d000002344-09-534e5f025e2d
Content-transfer-encoding: 8BIT
Message-id: <534E5F09.8070703@samsung.com>
Date: Wed, 16 Apr 2014 19:44:25 +0900
From: Seung-Woo Kim <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH 8/8] extcon: arizona: Use devm_extcon_dev_register()
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
 <1397644023-32516-9-git-send-email-sangjung.woo@samsung.com>
In-reply-to: <1397644023-32516-9-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkSJc53i/YYNoOZovrX56zWlzeNYfN
	4nbjCjaLBXtKLGZMfsnmwOrRt2UVo8fnTXIBTFFcNimpOZllqUX6dglcGXc3T2UseCNUMXdq
	E0sD4xL+LkYODgkBE4mV02K6GDmBTDGJC/fWs4HYQgJLGSV2HZGFiJtIrD8wnbWLkQsovohR
	4u+NbcwgCV4BQYkfk++xgMxhFpCXOHIpGyTMLKAhMfX1aUaI+teMEp2/VrNC1GtJNB/+yAhi
	swioSizpewm2jE1AR2L/kt+sEIsVJK5MPMYOMlNUIExi5+Z0kLCIgLbE/QmfWSDmz2aUuD9X
	DsQWFvCQuPagmRliVzujxLuvl5hAEpwCnhLLb9xiB0lICBxil+h+8JAVYrGAxLfJh1ggnpeV
	2HSAGeJJSYmDK26wTGAUn4XktVkIr81C8toCRuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmb
	GIFRdfrfs74djDcPWB9iTAbaOJFZSjQ5HxiVeSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMcr08otuduEFftvqjeYoaM+6tNN76r8Yc3bPwiUJ
	Ezm7GdkdH6k847y+zjLz0MbVicYvrkrd4Xa3tIhqzLDdU52c92PmgfcVt+9W2uyT2L8i9Vbk
	/DBGy5Xn4vR/reXoX9Mtx98zVcDH73Vd3lntPwkHWMQY/k5uPGLNW3t+uUB7kNLHBW//KLEU
	ZyQaajEXFScCAAMSIxXAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgC5TvF+wwfO1FhbXvzxntbi8aw6b
	xe3GFWwWC/aUWMyY/JLNgdWjb8sqRo/Pm+QCmKIaGG0yUhNTUosUUvOS81My89JtlbyD453j
	Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwlrGDPubp7KWPBGqGLu1CaWBsYl/F2MnBwSAiYS6w9MZ4WwxSQu3FvP1sXIxSEk
	sIhR4u+NbcwgCV4BQYkfk++xdDFycDALyEscuZQNEmYW0JCY+vo0I0T9a0aJzl+rWSHqtSSa
	D39kBLFZBFQllvS9ZAOx2QR0JPYv+Q1WIySgIHFl4jF2kJmiAmESOzeng4RFBLQl7k/4zAIx
	fzajxP25ciC2sICHxLUHzcwQu9oZJd59vcQEkuAU8JRYfuMW+wRGwVlITp2FcOosJKcuYGRe
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREct8+kdzCuarA4xCjAwajEwzszxzdYiDWxrLgy
	9xCjBAezkghvY6RfsBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA1NKXkm8obGJmZGlkbmh
	hZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwdhpHml+8ZJjy674XU3yN/urcNOtL
	ZxZcUTzOszGgrnr+2oCrS0u/Tnin+vPtv2O7yua+XyC9THDuBta/OvO7lljfTX1cVNi24CD/
	Q57Um/r1V5a85Db9qPWuhN241/C1dO9Rp61X1Je+u3b8csy+7c39+1WNz5ddP3D58BFTqeW1
	LdVB0VdPaSixFGckGmoxFxUnAgCLTeV4HwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2014³â 04¿ù 16ÀÏ 19:27, Sangjung Woo wrote:
> Use the resource-managed extcon device register function (i.e.
> devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
> is attached with this function, that extcon device is automatically unregistered
> on driver detach. That reduces tiresome managing code.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-arizona.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 98a14f6..40e6c0b 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1105,15 +1105,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>  	if (!info) {
>  		dev_err(&pdev->dev, "Failed to allocate memory\n");
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
>  
>  	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
>  	if (IS_ERR(info->micvdd)) {
> -		ret = PTR_ERR(info->micvdd);
>  		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);

Assignment to ret is removed but it is still used here.

> -		goto err;
> +		return PTR_ERR(info->micvdd);
>  	}
>  
>  	mutex_init(&info->lock);
> @@ -1155,11 +1153,11 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  	info->edev.dev.parent = arizona->dev;
>  	info->edev.supported_cable = arizona_cable;
>  
> -	ret = extcon_dev_register(&info->edev);
> +	ret = devm_extcon_dev_register(&pdev->dev, &info->edev);
>  	if (ret < 0) {
>  		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
>  			ret);
> -		goto err;
> +		return ret;
>  	}
>  
>  	info->input = devm_input_allocate_device(&pdev->dev);
> @@ -1410,8 +1408,6 @@ err_rise:
>  err_input:
>  err_register:
>  	pm_runtime_disable(&pdev->dev);
> -	extcon_dev_unregister(&info->edev);
> -err:
>  	return ret;
>  }
>  
> @@ -1445,7 +1441,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
>  	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
>  			   ARIZONA_JD1_ENA, 0);
>  	arizona_clk32k_disable(arizona);
> -	extcon_dev_unregister(&info->edev);
>  
>  	return 0;
>  }
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

