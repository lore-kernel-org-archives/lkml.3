Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaFWHxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:53:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59134 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaFWHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:53:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7fac6d000006cfe-98-53a7dcfa0a4c
Content-transfer-encoding: 8BIT
Message-id: <53A7DCF8.4090108@samsung.com>
Date: Mon, 23 Jun 2014 11:53:28 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
Cc: Kevin Hilman <khilman@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: exynos5410: Fill in CPU clock-frequency
References: <1403466596-3347-1-git-send-email-afaerber@suse.de>
In-reply-to: <1403466596-3347-1-git-send-email-afaerber@suse.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xy7q/7iwPNuiezm7RvKnYYtK6A0wW
	84+cY7Xof7OQ1eLcq5WMFr0LrrJZfD28gtFi0+NrrBaXd81hs5hxfh+Txe3LvBZLr19kspgw
	fS2LReveI+wOfB5r5q1h9Ghp7mHzuNzXy+Txd9ULZo+Vy7+weWxa1cnmcefaHjaPzUvqPfq2
	rGL02Hy62uPzJrkA7igum5TUnMyy1CJ9uwSujC1tH1kLGtkqHrw5w9bA+Iali5GTQ0LARKK7
	fz4jhC0mceHeerYuRi4OIYGljBI/fn9iA0nwCghK/Jh8D6iBg4NZQF7iyKVskDCzgJnEo5Z1
	zBD1Hxkldty8xQ5RryXx/MInZhCbRUBV4uWeLYwgvWwC2hJbdniBmKICERKPLwiBVIgIxEj8
	mvSfCWQMs0A/i8S2HXfB7hEWcJNo3/0BbKSQgL1Ez/39YDdzCjhIbF7RwjiBUWAWkutmIVw3
	C8l1CxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExNaXHYyLj1kdYhTgYFTi4b3htTxY
	iDWxrLgy9xCjBAezkghvYwNQiDclsbIqtSg/vqg0J7X4ECMTB6dUAyP/x+cpWbUhR/5/iCpZ
	9CPnWub5FlaBisD+1gkPaoXmS37++2SV/Jqqlnm7tqRzlxtkfHTyMi95oF+w3bXLqIbfItT5
	ZDJnt9zu+C/6ojq2XgU37574ObHq0CM3b459wR91tzNK8DsYHv12TS7Wk0GFb/uOpToCCzlN
	t77Y+Y6hr2SvNI/cWSWW4oxEQy3mouJEAM0P1TmLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 11:49 PM, Andreas Färber wrote:
> It's 1.6 GHz for the Cortex-A15.
>
> Avoids warnings like "/cpus/cpu@0 missing clock-frequency property".
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>   arch/arm/boot/dts/exynos5410.dtsi | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
> index 3839c26..9d0b8cc 100644
> --- a/arch/arm/boot/dts/exynos5410.dtsi
> +++ b/arch/arm/boot/dts/exynos5410.dtsi
> @@ -28,24 +28,28 @@
>   			device_type = "cpu";
>   			compatible = "arm,cortex-a15";
>   			reg = <0x0>;
> +			clock-frequency = <1600000000>;
>   

Reviewed-by: Tarek Dakhran<t.dakhran@samsung.com>

-- 
Best regards,
     Tarek Dakhran

