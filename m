Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3JDCZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:25:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54977 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3JDCZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:25:38 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-8c-524e26e304e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sean Paul'" <seanpaul@chromium.org>
Cc: airlied@linux.ie, kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-3-git-send-email-seanpaul@chromium.org>
In-reply-to: <1380839303-4834-3-git-send-email-seanpaul@chromium.org>
Subject: Re: [PATCH v2 2/5] ARM: dts: Add dp-controller node to exynos5250-snow
Date: Fri, 04 Oct 2013 11:24:35 +0900
Message-id: <000501cec0a8$de4b5240$9ae1f6c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Ah+vUa/SSr2uFRom57soQnvXmGAAIGUTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zY93Han5BBuu3W1j0njvJZDH/yDlW
	iytf37NZTLo/gcXi8sJLrBa9C66yWWx6fI3VYmHbEqDYrjlsFjPO72OyuLvhLKMDt8fshoss
	Htu/PWD1uN99nMlj85J6j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MpoeveVreAzZ0XL07fs
	DYy/2bsYOTkkBEwklhzqYoWwxSQu3FvP1sXIxSEksIxRovvMamaYoj83VrBCJBYxSnye9Aiq
	6hejxOx/X9hAqtgE1CS+fDkMNlZEQF3i2t/tLCBFzAJrmCTuTFzFDNGxm1Fi+pJ/TCBVnAKu
	En9/9YAtFxbwl7i0qYkFxGYRUJWY/Wo52G5eAVuJGxcbWCBsQYkfk++B2cwCWhLrdx5ngrDl
	JTaveQtUzwF0q7rEo7+6EEcYSTS+XMQGUSIise/FO0aQGyQEJnJILDu0jBlil4DEt8mHWCB6
	ZSU2HYB6WVLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS9
	5PzcTYyQmJ+4g/H+AetDjMlA6ycyS4km5wNTRl5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE2MF5pk379zIvi2aelNRe+uFa73maIOLrj0tLd3
	ZpFtVPSZuVsvMb600/n9a0H96f3G4g9+MH/dXudi5arSdcD5y2cPnuAsWRvpzav9FQR5/dW7
	A38w7P0fapmStH3q3vjnBoa6rK9y1pXW6HhE79MUFlafNdWw5bHQk/xfOh2zVl3nOqs8T4ml
	OCPRUIu5qDgRAIKr6zoPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd3Han5BBvd2G1v0njvJZDH/yDlW
	iytf37NZTLo/gcXi8sJLrBa9C66yWWx6fI3VYmHbEqDYrjlsFjPO72OyuLvhLKMDt8fshoss
	Htu/PWD1uN99nMlj85J6j74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMeY0fTuK1vBZ86Klqdv2RsYf7N3MXJySAiYSPy5sYIVwhaTuHBvPVsXIxeHkMAi
	RonPkx5BOb8YJWb/+8IGUsUmoCbx5cthsG4RAXWJa3+3s4AUMQusYZK4M3EVM0THbkaJ6Uv+
	MYFUcQq4Svz91QO2Q1jAX+LSpiYWEJtFQFVi9qvlzCA2r4CtxI2LDSwQtqDEj8n3wGxmAS2J
	9TuPM0HY8hKb17wFqucAulVd4tFfXYgjjCQaXy5igygRkdj34h3jBEahWUgmzUIyaRaSSbOQ
	tCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxQnknvYFzVYHGIUYCDUYmHd0Oxb5AQ
	a2JZcWXuIUYJDmYlEd7Tn4BCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9Mdnkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLhsFdeGScf+XjBimfx8gjX7
	rqsG4iET/8QfyXix3KrBKHrzBin+iak5PZnXmPwWls7MXf3/SNrbucrOLFs4FRZ/msB6k3vV
	X/kr9QWyQZcPvYqIPr/bJXh21U9JRztDTTa1aHuRTdGmm8ucHE5s11sluUvmyfZ4w+8qa3nn
	8EzV28nEP6NSr0aJpTgj0VCLuag4EQB1kHK8bAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 7:28 AM, Sean Paul wrote:
> 
> This patch adds the dp-controller node to the exynos5250-snow board dts
> file.
> 
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
> 
> v2: Added dp-controller address to node (rebased on linux-next)
> 
>  arch/arm/boot/dts/exynos5250-snow.dts | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index 2a0f0de..f1cf68e 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -186,6 +186,18 @@
>  		samsung,vbus-gpio = <&gpx1 1 0>;
>  	};
> 
> +	dp-controller@145B0000 {
> +		samsung,color-space = <0>;
> +		samsung,dynamic-range = <0>;
> +		samsung,ycbcr-coeff = <0>;
> +		samsung,color-depth = <1>;
> +		samsung,link-rate = <0x0a>;
> +		samsung,lane-count = <2>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&dp_hpd>;

How about adding 'status = "okay" as below?

		pinctrl-names = "default";
		pinctrl-0 = <&dp_hpd>;
		status = "okay";

status of dp node was disabled by exynos5.dtsi.

./arch/arm/boot/dts/exynos5.dtsi
dp-controller@145B0000 {
	status = "disabled";

Best regards,
Jingoo Han

