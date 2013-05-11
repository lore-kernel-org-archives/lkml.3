Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3EKFeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:34:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3EKFd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:33:58 -0400
X-AuditID: cbfee690-b7f136d000000fea-11-518dd844b6a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Shawn Guo'" <shawn.guo@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-33-git-send-email-wsa@the-dreams.de>
In-reply-to: <1368173847-5661-33-git-send-email-wsa@the-dreams.de>
Subject: Re: [RFC 32/42] drivers/video: don't check resource with
 devm_ioremap_resource
Date: Sat, 11 May 2013 14:33:56 +0900
Message-id: <002c01ce4e09$218612b0$64923810$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKrVsRnZVwbWOaUrA6bMaaf4JBF+gIrNvwBlzQJGgA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ12XG72BBnv/61nM6tK16Jx5jdHi
	RN8HVovLu+awWSxraWOxWD//FpvFyhOzmB3YPf4d7mfy+PAxzuPkqScsHsdvbGfy+LxJLoA1
	issmJTUnsyy1SN8ugSuj/ew2loJHPBWNO/vYGhhXc3UxcnJICJhItJ/tZ4OwxSQu3FsPZHNx
	CAksY5Q4MP07SxcjB1hRb3cwRHw6o8SJth2MEM4vRonr/dsYQbrZBNQkvnw5zA5iiwi4SGz8
	fwtsErPAbUaJ5YfmgxUJCVRIzD7QxQpicwo4STw9uh4sLiwQKfF9/jawZhYBVYmFzyaDbeYV
	sJR4PbUaJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSE+UJDYcfY1I8QNVhL9a+exQ9SI
	SOx78Q7saAmBt+wSTWfbWSB2CUh8m3wI6ktZiU0HoOZIShxccYNlAqPELCSrZyFZPQvJ6llI
	VixgZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERK7E3Yw3jtgfYgxGWj9RGYp0eR8YOzn
	lcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx7azz
	LqeCNsH6+JPepxRWJrFd6UmwMDSV17H9MefNYweZFw/mTT69d1lW0esEU5f9He0St1QbZac0
	10tklAQf4giYd3xL42mVNxOmLr9p+l+v8B5jxUGmwyf37F55KLHF9Wn6X4+XsZvNZ30VCu5b
	+Ppo0I6vyessrPdU6t3o0L8xad+Ho1Y/lViKMxINtZiLihMB8BzwTvMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQV2XG72BBivnaVnM6tK16Jx5jdHi
	RN8HVovLu+awWSxraWOxWD//FpvFyhOzmB3YPf4d7mfy+PAxzuPkqScsHsdvbGfy+LxJLoA1
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRvvZbSwFj3gqGnf2sTUwrubq
	YuTgkBAwkejtDu5i5AQyxSQu3FvP1sXIxSEkMJ1R4kTbDkYI5xejxPX+bYwgVWwCahJfvhxm
	B7FFBFwkNv6/BdbBLHCbUWL5oflgRUICFRKzD3SxgticAk4ST4+uB4sLC0RKfJ+/DayZRUBV
	YuGzySwgV/AKWEq8nloNEuYVEJT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBCXKkjsOPuaEeIG
	K4n+tfPYIWpEJPa9eMc4gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBCeGZ9I7GFc1WBxiFOBgVOLhrRDqDRRiTSwrrsw9xCjBwawkwntkOlCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84FJK68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGOeF/kop8rk/cY4ET4CUj3nhs422OfL/1663uzS5sevFpoX1VcYa4r/Y
	qz7tvzJ/V+rS7Q37GtlXPl6p/eukpfSWtAdlpx9I8FnyBWtKlfK6b/3gUmZx6IFRWUmH1JHt
	8YyrWkx8bx3jvVt+qnOJmr3WKd+geLEAh3kptoKr165SWzSl5d+qGiWW4oxEQy3mouJEAE4u
	51xQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 10, 2013 5:17 PM, Wolfram Sang wrote:
> 
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

CC'ed Tomi Valkeinen, Shawn Guo, Fabio Estevam


It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/mxsfb.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index 1b2c26d..3dc3265 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -883,12 +883,6 @@ static int mxsfb_probe(struct platform_device *pdev)
>  	if (of_id)
>  		pdev->id_entry = of_id->data;
> 
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Cannot get memory IO resource\n");
> -		return -ENODEV;
> -	}
> -
>  	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
>  	if (!fb_info) {
>  		dev_err(&pdev->dev, "Failed to allocate fbdev\n");
> @@ -897,6 +891,7 @@ static int mxsfb_probe(struct platform_device *pdev)
> 
>  	host = to_imxfb_host(fb_info);
> 
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	host->base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(host->base)) {
>  		dev_err(&pdev->dev, "ioremap failed\n");
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

