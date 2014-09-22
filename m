Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaIVGo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:44:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50529 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaIVGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:44:54 -0400
X-AuditID: cbfee691-f79b86d000004a5a-fd-541fc5645566
Message-id: <541FC564.8000002@samsung.com>
Date: Mon, 22 Sep 2014 15:44:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Daniel Drake <drake@endlessm.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on
 exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
 <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkRDflqHyIwaInyhZnlx1ks3g0/zGz
	xdHfBRa9C66yWWx6fI3V4vKuOWwWM87vY3Jg95jdcJHF4+/z6ywei75neWxeUu/Rt2UVo8fn
	TXIBbFFcNimpOZllqUX6dglcGZcnfmMtmMhT8fPeGsYGxrucXYycHBICJhIrt01jh7DFJC7c
	W8/WxcjFISSwlFGicSKIA1HUvGAuI0RiEaPE3SPPoapeM0qc3LSXtYuRg4NXQEvi7s1gkAYW
	AVWJDytWMIHYbEDh/S9ugA0SFQiTWDn9CguIzSsgKPFj8j0wW0TATuLG6ofMIDOZBW4zShzZ
	cgysWVggWOLf9SWsILaQwFRGie0Ho0BsToEAiZnTZ4KdzSygI7G/dRobhC0vsXnNW7BBEgLX
	2CXm7L7BCnGRgMS3yYdYQA6VEJCV2HSAGeIzSYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHU
	guSC4qT0IlO94sTc4tK8dL3k/NxNjMDoO/3v2cQdjPcPWB9iFOBgVOLh/dEiHyLEmlhWXJl7
	iNEU6IqJzFKiyfnAGM8riTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoExY1pvwWezD0Ken7vC1uRNWtOyUdTLU/tGaOfPkq+y2UaHdqxrbDlx1H3XGj0L
	8wzr8BtiLKfeah011BKs4df5wr6FmS9O2bVYsubWYq0ipsBfZy/fYT3OazH3iCJbza8wh06h
	uSVrux9J2vVWb7YSNX654M2SOxxnZNb3fnkfNUf521qThVlKLMUZiYZazEXFiQADsQKRuQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAd2Uo/IhBpNbZSzOLjvIZvFo/mNm
	i6O/Cyx6F1xls9j0+BqrxeVdc9gsZpzfx+TA7jG74SKLx9/n11k8Fn3P8ti8pN6jb8sqRo/P
	m+QC2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
	gC5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZcnviNtWAiT8XPe2sY
	GxjvcnYxcnJICJhINC+Yywhhi0lcuLeerYuRi0NIYBGjxN0jz6Gc14wSJzftZe1i5ODgFdCS
	uHszGKSBRUBV4sOKFUwgNhtQeP+LG2wgtqhAmMTK6VdYQGxeAUGJH5PvgdkiAnYSN1Y/ZAaZ
	ySxwm1HiyJZjYM3CAsES/64vYQWxhQSmMkpsPxgFYnMKBEjMnD6THcRmFtCR2N86jQ3ClpfY
	vOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGx/Ux6B+Oq
	BotDjAIcjEo8vD9a5EOEWBPLiitzDzFKcDArifAezQEK8aYkVlalFuXHF5XmpBYfYjQFBsFE
	ZinR5Hxg2skriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cBY7eXb
	6/j90T9fsRkHC+/5Xllz9c9d45q4Qt6Gz0Xcc62NKi1M52+RCyjZpM5aYbamQyjpylIph36n
	7KhbrsYG/T3Tnf7OLY33337saOOzOXPEFAMVWVNvLjrmsWqC3uWOnGc32j5tt5LdvO6pwKXu
	/HP+pyoS0g1C76vrnNs0+1jojtimsnNKLMUZiYZazEXFiQBUUQ/tAwMAAA==
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
> source clock. In the case of the Exynos5250 based Snow board, the Maxim
> 77686 32kHz AP clock is used as the source clock.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos5250-snow.dts | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index e51fcef..56eec56 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -10,6 +10,7 @@
>  
>  /dts-v1/;
>  #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/clock/maxim,max77686.h>
>  #include "exynos5250.dtsi"
>  
>  / {
> @@ -29,6 +30,8 @@
>  
>  	rtc@101E0000 {
>  		status = "okay";
> +		clocks = <&clock CLK_RTC>, <&max77686 MAX77686_CLK_AP>;
> +		clock-names = "rtc", "rtc_src";
>  	};
>  
>  	pinctrl@11400000 {
> @@ -350,7 +353,7 @@
>  	samsung,i2c-sda-delay = <100>;
>  	samsung,i2c-max-bus-freq = <378000>;
>  
> -	max77686@09 {
> +	max77686: max77686@09 {
>  		compatible = "maxim,max77686";
>  		interrupt-parent = <&gpx3>;
>  		interrupts = <2 0>;
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

