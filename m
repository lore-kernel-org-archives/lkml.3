Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3C0XxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:53:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22607 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3C0Xw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:52:58 -0400
X-AuditID: cbfee690-b7f656d0000007e3-15-515386588847
Message-id: <51538652.7040005@samsung.com>
Date: Thu, 28 Mar 2013 08:52:50 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Andrei Epure <epure.andrei@gmail.com>
Cc: inki.dae@samsung.com, kyungmin.park@samsung.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: exynos: Convert to devm_ioremap_resource()
References: <1364416081-24113-1-git-send-email-epure.andrei@gmail.com>
In-reply-to: <1364416081-24113-1-git-send-email-epure.andrei@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zTd2ItuBAg9X7NCxO/FzKZtE58xqj
	xaT7E1gszja9Ybc40feB1eLyrjlsDmweO2fdZff48DHOo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDKmXDzHXLCcs2LdkT9MDYzX2bsYOTkkBEwkFq5ZwAZhi0lcuLceyObiEBJYxijxtWk5
	XNGi7fPZIRKLGCU2337OCOG8ZJT4tuEFUxcjBwevgJbE7a96IA0sAqoSb16vYAKx2QQ0JE7f
	uw82SFQgTGLl9CssIDavgKDEj8n3wGwRAU2Jidu/gtnMAl2MEi1XLUBGCgu4STydCNYqBGQe
	+t3FDGJzCrhLHH99EarcWmLlpG2MELa8xOY1b5lBTpMQ2Mcu0Xy1gRXiHgGJb5MPsYDMlBCQ
	ldh0gBniL0mJgytusExgFJuF5KJZSMbOQjJ2ASPzKkbR1ILkguKk9CITveLE3OLSvHS95Pzc
	TYyQ+Jqwg/HeAetDjMlAKycyS4km5wPjM68k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjMHWJkIn1i7/8mJxZ8naYr+rP1J6kv6nv1dXfta7tf/R
	syvcznsP3fP9vSdGXjn319H/UgvEH5T//Bk5ueLAIcd5j1cmuU3MNul2+7JAl2cVk0ZYcUze
	f0fTw+9M5r0s/BCot3zhguc6FzWzje08rryLexxtlGW8mfPRMp0HZbON0lvyejy9PJVYijMS
	DbWYi4oTAeB/AF3FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgG5EW3CgwdVJShYnfi5ls+iceY3R
	YtL9CSwWZ5vesFuc6PvAanF51xw2BzaPnbPusnt8+Bjn0bdlFaPH501yASxRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZUy6eYy5Yzlmx7sgfpgbG6+xdjJwcEgImEou2
	z4eyxSQu3FvP1sXIxSEksIhRYvPt54wQzktGiW8bXjB1MXJw8ApoSdz+qgfSwCKgKvHm9Qom
	EJtNQEPi9L37YINEBcIkVk6/wgJi8woISvyYfA/MFhHQlJi4/SuYzSzQxSjRctUCZKSwgJvE
	04lgrUJA5qHfXcwgNqeAu8Tx1xehyq0lVk7axghhy0tsXvOWeQKjwCwkG2YhKZuFpGwBI/Mq
	RtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODofSa1g3Flg8UhRgEORiUe3gqB4EAh1sSy4src
	Q4wSHMxKIryzaoBCvCmJlVWpRfnxRaU5qcWHGJOBATCRWUo0OR+YWPJK4g2NTcyMLI3MjE3M
	jY1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbF5gvODptKNIl/KZB51F7Bt3HP9W/+/
	138WHPu7fvZ59vlsOu786oXOqv551aE8GlV3y+PUOINC8p5mzph6XVCrY921lrlGXU+u5Qu6
	8pRZ/JKNdN1Y8sDE3nbu9/MGhpw71b4t5PaSiFLRTZxbtm/ljG8ql7Z4v//GsL/ebsoC01CV
	yXvOmiuxFGckGmoxFxUnAgBFsOL0IgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Please refer to the following link.

http://marc.info/?l=linux-fbdev&m=135963121130437&w=2

Best regard,
Donghwa Lee

On Thu, Mar 28, 2013 at 05:28, Andrei Epure wrote:
> The new devm_ioremap_resource() provides its own error messages.
> Patch found using coccinelle.
>
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>   drivers/video/exynos/exynos_mipi_dsi.c |    7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
> index fac7df6..dd5e5e9 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
> @@ -384,10 +384,9 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>   
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   
> -	dsim->reg_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!dsim->reg_base) {
> -		dev_err(&pdev->dev, "failed to remap io region\n");
> -		ret = -ENOMEM;
> +	dsim->reg_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(dsim->reg_base)) {
> +		ret = PTR_ERR(dsim->reg_base);
>   		goto error;
>   	}
>   

