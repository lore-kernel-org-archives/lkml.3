Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3EKFYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:24:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62768 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3EKFYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:24:37 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-48-518dd6135196
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Barry Song'" <baohua.song@csr.com>,
        "'Stephen Warren'" <swarren@wwwdotorg.org>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
In-reply-to: <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
Subject: Re: [RFC 23/42] drivers/spi: don't check resource with
 devm_ioremap_resource
Date: Sat, 11 May 2013 14:24:35 +0900
Message-id: <002b01ce4e07$d3087ed0$79197c70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKrVsRnZVwbWOaUrA6bMaaf4JBF+gF35/p2lzmhkSA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t8zQ13ha72BBg2X1S1ezrzKajFp3QEm
	i6kPn7BZHPizg9Hi8sJLrBa9C66yWWx6fI3V4vKuOWwWM87vY7Lo/DKLzeLIlEZ2i1cH21gs
	Vp6YxezA67Fr5xxWj7+rXjB7bFrVyeZx59oeNo/NS+o9di/4zOTRt2UVo8fJU09YPD5vkvPY
	ODc0gCuKyyYlNSezLLVI3y6BK+PJ7lksBZv4Ku7d+8bSwDiDu4uRg0NCwETi59W4LkZOIFNM
	4sK99WwgtpDAMkaJM+tTIOImEqf3nGXvYuQCii9ilDh+cyYThPOLUeLQlrlgHWwCahJfvhxm
	B7FFBFwkNv6/xQZSxCywmFlixtf9jBBjKyQmfPjHDGJzCjhJ9K+9xARiCwuES8zo7ACrYRFQ
	lWg7OB9sEK+ApcTF+bcYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcaqCxI6zrxkhjrCS
	+HT5AVS9iMS+F+8YQQ6SENjDIdG/vJEFYpmAxLfJh1ggQSErsekA1BxJiYMrbrBMYJSYhWT1
	LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQhJF3w7GmwesDzEmA62f
	yCwlmpwPTDR5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamAM1TINmqrbsyV55t7Hm39+spvEPqX4ScqWPB7lux09el/eyhY7rde5O2P34oy5Ee5z
	5dn3VBSU2fOLX/bumrNX2Oz+3ql2q+ScV/E8OnWqPIgv9snJdTYS7m137LYn9/w7EPLAR7To
	5Lqu1YFbHRivVwicPTuRS/CwSnbYtkp3O/3wL22P83KUWIozEg21mIuKEwEkirV9KgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t9jAV3ha72BBh1blCxezrzKajFp3QEm
	i6kPn7BZHPizg9Hi8sJLrBa9C66yWWx6fI3V4vKuOWwWM87vY7Lo/DKLzeLIlEZ2i1cH21gs
	Vp6YxezA67Fr5xxWj7+rXjB7bFrVyeZx59oeNo/NS+o9di/4zOTRt2UVo8fJU09YPD5vkvPY
	ODc0gCuqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGk92zWAo28VXcu/eN
	pYFxBncXIyeHhICJxOk9Z9khbDGJC/fWs3UxcnEICSxilDh+cyYThPOLUeLQlrlsIFVsAmoS
	X74cBusQEXCR2Pj/FlgHs8BiZokZX/czgiSEBCokJnz4xwxicwo4SfSvvcQEYgsLhEvM6OwA
	q2ERUJVoOzgfbBCvgKXExfm3GCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGqgsSOs68Z
	IY6wkvh0+QFUvYjEvhfvGCcwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLS
	vHS95PzcTYzgVPRMagfjygaLQ4wCHIxKPLwKAr2BQqyJZcWVuYcYJTiYlUR4j0wHCvGmJFZW
	pRblxxeV5qQWH2JMBvp0IrOUaHI+ME3mlcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEk
	NTs1tSC1CGYLEwenVAOjvbR30cdT97LvsSgvkWScc/DrW69mrsylL+/m/5QrqBE/l/LvevjB
	VqF86+8ZGuKNsxmuBxSm7m5buVrhnYTrvK9lJrOs01Ly5bQjNl1KyHjipbBBe6Prw47bVZpC
	12eU92y4sfct08Ia49PvljR6rJmoviLr6d87Byv1zh1Y8PrX9RMrUq9tVWIpzkg01GIuKk4E
	AKk9eeKJAwAA
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
> ---
>  drivers/spi/spi-bcm63xx.c        |    8 +-------
>  drivers/spi/spi-ep93xx.c         |    8 +-------
>  drivers/spi/spi-omap2-mcspi.c    |    7 +------
>  drivers/spi/spi-s3c64xx.c        |    7 +------
>  drivers/spi/spi-sirf.c           |    7 +------
>  drivers/spi/spi-tegra114.c       |    7 +------
>  drivers/spi/spi-tegra20-sflash.c |    5 -----
>  drivers/spi/spi-tegra20-slink.c  |    7 +------
>  8 files changed, 7 insertions(+), 49 deletions(-)
> 

[.....]

> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index 5000586..fd763cc 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -1243,12 +1243,6 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
> 
> -	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (mem_res == NULL) {
> -		dev_err(&pdev->dev, "Unable to get SPI MEM resource\n");
> -		return -ENXIO;
> -	}
> -

It breaks 'sdd->sfr_start' assignment as below:

1272         sdd->sfr_start = mem_res->start;


Best regards,
Jingoo Han

>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
>  		dev_warn(&pdev->dev, "Failed to get IRQ: %d\n", irq);
> @@ -1318,6 +1312,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
>  	/* the spi->mode bits understood by this driver: */
>  	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
> 
> +	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	sdd->regs = devm_ioremap_resource(&pdev->dev, mem_res);
>  	if (IS_ERR(sdd->regs)) {
>  		ret = PTR_ERR(sdd->regs);


