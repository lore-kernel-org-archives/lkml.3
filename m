Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaGDHnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:43:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaGDHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:43:03 -0400
X-AuditID: cbfee68f-b7fef6d000003970-9e-53b65b04b0b2
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux@arm.linux.org.uk,
        t.figa@samsung.com
Cc: kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH] ARM: dts: Add I2S dt node for Exynos3250
Date: Fri, 04 Jul 2014 16:43:00 +0900
Message-id: <02fa01cf975b$947d6e20$bd784a60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHM9oHxzIrf9SdEDX6ROUEaJ0Gs2JuUyYiQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ13W6G3BBlOeMVlc//Kc1WLX3/uM
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi/YzXLA4cHi3NPWwem5fUe/RtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAlfGlJnX2QrOclds7m1nbGCcy9nFyMkhIWAiMePzO3YIW0ziwr31bF2M
	XBxCAssYJY7fu8PYxcgBVjTrtilEfDqjxLNT+1kgnL+MEms2TGQE6WYT0JA4/P4Z2CQRgQiJ
	az9XsIMUMQssYJSY8W0lC0hCSMBVYu6FF2BFnAJuEq9PN7CC2MICthKbJ15nA9nGIqAqsfmb
	HEiYV8BS4vbd72wQtqDEj8n3wMYwC2hJbN7WxAphy0tsXvOWGeIDBYkdZ18zQtxgJHHo90ao
	ehGJfS/eMYLcIyHwll3i6a+NYA0sAgIS3yYfYoH4UlZi0wGoOZISB1fcYJnAKDELyepZSFbP
	QrJ6FpIVCxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKExG7/Dsa7B6wPMSYDrZ/ILCWa
	nA+M/bySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wFgm7c3H97iQbUpBcu9PP+ZlghfmLwhfsCr4efRb122HJCeuXWI9tfXpObkj8SllSpH7P7M/
	Pbvzwqc5H4uWvPmXkm6wJyMg+9b8XTcVtn05l+fVnvEqtSOnbe/NEJavmvuKFm/K/eZqZiKV
	XXF3NWP1q0OtR1yPxd5ozJ19TvGdW5DjFi+RBXpKLMUZiYZazEXFiQCqH1sE8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoC5L9LZggy/rrSyuf3nOarHr731G
	i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGuxfsZrFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpSZ19kKznJXbO5tZ2xgnMvZ
	xcjBISFgIjHrtmkXIyeQKSZx4d56ti5GLg4hgemMEs9O7WeBcP4ySqzZMJERpIpNQEPi8Ptn
	7CC2iECExLWfK9hBipgFFjBKzPi2kgUkISTgKjH3wguwIk4BN4nXpxtYQWxhAVuJzROvs4Fs
	ZhFQldj8TQ4kzCtgKXH77nc2CFtQ4sfke2BjmAW0JDZva2KFsOUlNq95ywxxqYLEjrOvGSFu
	MJI49HsjVL2IxL4X7xgnMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0
	veT83E2M4MTwTHoH46oGi0OMAhyMSjy8HkVbg4VYE8uKK3MPMUpwMCuJ8FYpbQsW4k1JrKxK
	LcqPLyrNSS0+xGgK9OhEZinR5Hxg0soriTc0NjEzsjQyszAyMTdXEuc92GodKCSQnliSmp2a
	WpBaBNPHxMEp1cAY63TV89NCqxr5klZdhlWCs8/4nCk4ueT4o8MGomLB79geqV/ZfGAJS+z0
	8OC7NuYG59edP13VeC/ePXvDhd2somnT9i1Z+8kzd873BzlcuZnnnjW7vK88auwrd/wK26op
	WmVKxzk2hxb+snXZOFOGdc6hKt1E3ftbfp3/Z7HS9Xlg/8lO2Y/ySizFGYmGWsxFxYkAH1kQ
	GCIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
> (1 channels) IIS-bus for audio interface with DMA-based operation.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> Tested-by: Inha Song <ideal.song@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 1f8384f..e9017ef 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -644,6 +644,19 @@
>  			status = "disabled";
>  		};
> 
> +		i2s: i2s@13970000 {
> +			compatible = "samsung,s3c6410-i2s";
> +			reg = <0x13970000 0x100>;
> +			interrupts = <0 126 0>;
> +			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
> +			clock-names = "iis", "i2s_opclk0";
> +			dmas = <&pdma0 14>, <&pdma0 13>;
> +			dma-names = "tx", "rx";
> +			pinctrl-0 = <&i2s2_bus>;
> +			pinctrl-name = "default";

To put 'pinctrl-name' and then 'pinctrl-0' is better? :-)

> +			status = "disabled";
> +		};
> +
>  		pwm: pwm@139D0000 {
>  			compatible = "samsung,exynos4210-pwm";
>  			reg = <0x139D0000 0x1000>;
> --
> 1.8.0

Will apply.

Thanks,
Kukjin

