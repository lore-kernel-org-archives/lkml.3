Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaIVGlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:41:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16921 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaIVGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:41:46 -0400
X-AuditID: cbfee68d-f79296d000004278-82-541fc4a7e06b
Message-id: <541FC4A7.3010901@samsung.com>
Date: Mon, 22 Sep 2014 15:41:43 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Daniel Drake <drake@endlessm.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos Peach
 boards
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
 <1410954633-27025-2-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1410954633-27025-2-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkSHf5EfkQgwlLLCzOLjvIZvFo/mNm
	i6O/Cyx6F1xls9j0+BqrxeVdc9gsZpzfx+TA7jG74SKLx9/n11k8Fn3P8ti8pN6jb8sqRo/P
	m+QC2KK4bFJSczLLUov07RK4Ml6eCC9YLVrR9/8mWwPjOsEuRk4OCQETiYMLLjBC2GISF+6t
	Z+ti5OIQEljKKLH65E8ghwOs6H1PBEiNkMB0RokPHzwhal4zSrzatZENJMEroCXx7uhyJhCb
	RUBVYumZX2BxNqD4/hc3wGxRgTCJldOvsEDUC0r8mHwPzBYRsJO4sfohM8hQZoHbjBJHthwD
	GyQsEC5xYus/JohtUxkljj1/BZbgFAiQOHirmxnEZhbQkdjfOo0NwpaX2LzmLdgkCYFz7BI7
	J8xghDhJQOLb5EMsEO/ISmw6wAzxsqTEwRU3WCYwis1CctQsJGNnIRm7gJF5FaNoakFyQXFS
	epGhXnFibnFpXrpecn7uJkZg7J3+96x3B+PtA9aHGAU4GJV4eBc0yYcIsSaWFVfmHmI0Bbpi
	IrOUaHI+MMLzSuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgXLVT6qxByuGsyZ/WfL8l8tJt+apPbWw1zPVFsxVrz/m0X/b0n90itq7hi2BViMC3cMmu
	6M2e2ZLSkc2bW51XpwvYPov6x7C+tFiy+vGMhK4JDpmeDrPkjjHkBNZdd9tixSWxSCBv34cf
	p16JrT7dnW6x78K7bVEMXxeluWbKHPL191h3P7lTiaU4I9FQi7moOBEAn44TdbgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd3lR+RDDLZcNLA4u+wgm8Wj+Y+Z
	LY7+LrDoXXCVzWLT42usFpd3zWGzmHF+H5MDu8fshossHn+fX2fxWPQ9y2PzknqPvi2rGD0+
	b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx8kR4wWrRir7/N9ka
	GNcJdjFycEgImEi874noYuQEMsUkLtxbzwZiCwlMZ5T48MGzi5ELyH7NKPFq10awBK+AlsS7
	o8uZQGwWAVWJpWd+gcXZgOL7X9wAs0UFwiRWTr/CAlEvKPFj8j0wW0TATuLG6ofMIEOZBW4z
	ShzZcgxskLBAuMSJrf+YILZNZZQ49vwVWIJTIEDi4K1uZhCbWUBHYn/rNDYIW15i85q3zBMY
	BWYhWTILSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH9jOpHYwrGywOMQpw
	MCrx8C5okg8RYk0sK67MPcQowcGsJMJ7NAcoxJuSWFmVWpQfX1Sak1p8iNEUGAYTmaVEk/OB
	SSevJN7Q2MTMyNLI3NDCyNhcSZz3QKt1oJBAemJJanZqakFqEUwfEwenVAOj+AyNld/Nvpmd
	jd73u2n589XTp70L3bI5naFGeG3zxoTtvWtKXSPPK0TncxVfz593OOXB9sqTU66q3J79/cIb
	uRSbtoi7lSXXebbIPprjslq/80bWK3Gde/sO101v+1vcce1DouWXzHvCMx9tUrti6xmV37x/
	d8UTzkrx7YemnF9/uaj54IrQGUosxRmJhlrMRcWJAKJmFeMCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Javier,

On 09/17/2014 08:50 PM, Javier Martinez Canillas wrote:
> commit 546b117fdf17 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
> added an "rtc_src" DT property for the Samsung's S3C Real Time Clock
> controller that specifies the 32.768 kHz clock that uses the RTC as its
> source clock. In the case of the Peach Pit and Pi machines, the Maxim
> 77802 32kHz AP clock is used as the source clock.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 5 ++++-
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index 9a23382..bfd189e 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -12,6 +12,7 @@
>  #include <dt-bindings/input/input.h>
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/clock/maxim,max77802.h>
>  #include "exynos5420.dtsi"
>  
>  / {
> @@ -151,7 +152,7 @@
>  	status = "okay";
>  	clock-frequency = <400000>;
>  
> -	max77802-pmic@9 {
> +	max77802: max77802-pmic@9 {
>  		compatible = "maxim,max77802";
>  		interrupt-parent = <&gpx3>;
>  		interrupts = <1 IRQ_TYPE_NONE>;
> @@ -727,6 +728,8 @@
>  
>  &rtc {
>  	status = "okay";
> +	clocks = <&clock CLK_RTC>, <&max77802 MAX77802_CLK_32K_AP>;
> +	clock-names = "rtc", "rtc_src";
>  };
>  
>  &spi_2 {
> diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> index 1d31c81..84ec1ce 100644
> --- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
> +++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> @@ -12,6 +12,7 @@
>  #include <dt-bindings/input/input.h>
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/clock/maxim,max77802.h>
>  #include "exynos5800.dtsi"
>  
>  / {
> @@ -150,7 +151,7 @@
>  	status = "okay";
>  	clock-frequency = <400000>;
>  
> -	max77802-pmic@9 {
> +	max77802: max77802-pmic@9 {
>  		compatible = "maxim,max77802";
>  		interrupt-parent = <&gpx3>;
>  		interrupts = <1 IRQ_TYPE_NONE>;
> @@ -715,6 +716,8 @@
>  
>  &rtc {
>  	status = "okay";
> +	clocks = <&clock CLK_RTC>, <&max77802 MAX77802_CLK_32K_AP>;
> +	clock-names = "rtc", "rtc_src";
>  };
>  
>  &spi_2 {
> 

I'm so sorry for delay reply because I'm out of office for vacation (9/5 ~ 9/20).
Looks goot to me for this patch.

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

