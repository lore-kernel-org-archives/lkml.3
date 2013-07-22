Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3GVIi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:38:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58574 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab3GVIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:37:06 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ec-51ecef2e924a
Date: Mon, 22 Jul 2013 08:37:02 +0000 (GMT)
From: NAVEEN KRISHNA CHATRADHI <ch.naveen@samsung.com>
Subject: Re: Re: [PATCH] of: provide of_platform_unpopulate()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Roger Quadros <rogerq@ti.com>,
        George Cherian <george.cherian@ti.com>, Felipe Balbi <balbi@ti.com>
Reply-to: ch.naveen@samsung.com
MIME-version: 1.0
X-MTR: 20130722083454010@ch.naveen
Msgkey: 20130722083454010@ch.naveen
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130722083454010@ch.naveen
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <23795036.212591374482218972.JavaMail.weblogic@epml23>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSrav3/k2gwfLlQhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj+JEzzAVHhCvmvb/N0sDYINzFyMkhJKAi8XfHdFYQW0LAROLp
	jG9sELaYxIV764FsLqCapYwSzUu62GGKDi2ZxA6RmM8osXPGIbBuFgFViasvF4MVsQmYS7w7
	8QMsLixgK3H3wA0WEFsEKD5j6iRmkGZmgY2sEn8b25kgzpCXmDGxE6yIV0BQ4uTMJ0A2B9A2
	JYmeO4YQYWWJy/e3MUIcISexZOplJgibV2JG+1MWmPi0r2uYIWxpifOzNjDCfLP4+2OoOL/E
	sds7mCDG80o8uR8MM2b35i9QzwtITD1zkBGiRF1idaMgRJhPYs3CtywwU3adWs4M03p/y1yw
	a5gFFCWmdD9kh7ANJI4smsOK7ileASeJs2cLJzAqz0KSmYWkexaSbmQ1CxhZVjGKphYkFxQn
	pRcZ6xUn5haX5qXrJefnbmIEJoXT/57172C8e8D6EGMyMEImMkuJJucDk0peSbyhsZmRhamJ
	qbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiXVS9s7fSvao21tPik
	0e37w8axkEdQcceHN6ei9OolxV9v4J8uzHDi0uYzSxmeHHyVdG/llpt7TXoPWS7cfCriDNOr
	pXMyz+33qjL4s1J477EggbAg3yPrFFfLhgRomVRfN+/QLoxflFMYObfBYyZjjvXe11tqFimy
	PLXpls6qiNNisFtXkqjEUpyRaKjFXFScCABYhVzwIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/t6bp6798EGrxawGlxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DE1jrQwNDIxMgWoS0jKO
	HznDXHBEuGLe+9ssDYwNwl2MnBxCAioSf3dMZwWxJQRMJA4tmcQOYYtJXLi3nq2LkQuoZj6j
	xM4Zh8CKWARUJa6+XAxWxCZgLvHuxA+wuLCArcTdAzdYQGwRoPiMqZOYQZqZBTaySvxtbGeC
	2CYvMWNiJ1gRr4CgxMmZT4BsDqBtShI9dwwhwsoSl+9vY4Q4Qk5iydTLTBA2r8SM9qcsMPFp
	X9cwQ9jSEudnbWCEOXrx98dQcX6JY7d3MEGM55V4cj8YZszuzV/YIGwBialnDjJClKhLrG4U
	hAjzSaxZ+JYFZsquU8uZYVrvb5kLdg2zgKLElO6H7BC2gcSRRXNY0T3FK+AkcfZs4QRGuVlI
	MrOQdM9C0o2sZgEjyypG0dSC5ILipPQKY73ixNzi0rx0veT83E2M4NT0bPEOxv/nrQ8xCnAw
	KvHw3gh6EyjEmlhWXJl7iFGCg1lJhNdzFVCINyWxsiq1KD++qDQntfgQYzIw+iYyS4km5wPT
	Zl5JvKGxibmpsamFgaG5uRlpwkrivM9arQOFBNITS1KzU1MLUotgtjBxcEo1MDpte+qXFv3Y
	0bEp6JjXq5bgzCeNMvwM85V7xU5Lqi955vE4ev/8t+yH98sfWcXTGScVOeVVxoJ73qvd+I9Z
	/Xz1dcvE6QLr7sV2uoZ7XDR4puAepqY308Z53f6f1kZJ9rO8eRZO2TNl66N0if0hhjGTfn04
	wLSUJSv9lu2y+dtn36k48o/7MIsSS3FGoqEWc1FxIgDArFIKkQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6M8cXEl008533

Hello Sebastian,

------- Original Message -------
Sender : Sebastian Andrzej Siewior<bigeasy@linutronix.de> 
Date   : Jul 22, 2013 13:55 (GMT+05:30)
Title  : Re: [PATCH] of: provide of_platform_unpopulate()

On 07/20/2013 07:42 AM, NAVEEN KRISHNA CHATRADHI wrote:
> Hello Sebastian,

Hello Naveen,

> 
> I just did one more testing.
> 
> In case of iio/adc/exynos_adc.c there is a bug in the remove path.
> If I fix the bug in the driver, with below patch
> 
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -375,14 +375,14 @@ static int exynos_adc_remove(struct platform_device *pdev)
>         struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>         struct exynos_adc *info = iio_priv(indio_dev);
> 
> -       device_for_each_child(&pdev->dev, NULL,
> -                               exynos_adc_remove_devices);
>         regulator_disable(info->vdd);
>         clk_disable_unprepare(info->clk);
>         writel(0, info->enable_reg);
>         iio_device_unregister(indio_dev);
>         free_irq(info->irq, info);
>         iio_device_free(indio_dev);
> +       device_for_each_child(&pdev->dev, NULL,
> +                               exynos_adc_remove_devices);
> 
> Even without your fix, I could configure it as a module and the rmmod, insmod are working fine. (no crash)

I have no idea why you moved it. I haven't found any .dts with this
  regulator_disable(info->vdd);
has to happen before we free and remove the devices.
The dts part is not upstreamed yet.

binding but from the binding document I would assume that you do not
have any memory resources and therefore you don't see that crash.
Yes, my devices under ADC are 3rd party thermistors and they don't have memory resources.
May be your explanation seems right.

Thanks,
Naveen

> Regards,
> Naveen

Sebastian
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
