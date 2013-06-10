Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3FJIY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:24:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45746 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3FJIY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:24:57 -0400
X-AuditID: cbfee691-b7fef6d000002d62-2d-51b58d573743
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1370454336-13003-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1370454336-13003-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH] ARM: dts: add vmmc regulator support for ODROID-X
Date: Mon, 10 Jun 2013 17:24:55 +0900
Message-id: <0e9e01ce65b3$fcc3ba00$f64b2e00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5iFIWQy28oFIWRTnGfaqwK5n/8ZQDn2sfQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zfd3w3q2BBo+6NS02Pb7GanF51xw2
	i9uXeS1OXf/MZnFsxhJGi32P1zA7sHm0NPeweeycdZfd4861PWwem5fUe1w50cTq8XmTXABb
	FJdNSmpOZllqkb5dAlfG7TeX2QtesVdMmLKbrYFxGlsXIyeHhICJRNvhRawQtpjEhXvrgeJc
	HEICyxgl+n68gyuaOqUFzBYSmM4oseCIIUTRX0aJ+XO2M4Mk2AQ0JA6/f8YOYosIqEk0/u1k
	BSliFjjCKHHkwFkWiG4niWuftjGB2JwCzhJ3zx4CaxAWcJM4fmMRWJxFQFXizJelYCfxCthK
	nDoM0csrICjxY/I9MJtZQEti/c7jTBC2vMTmNW+BjuAAulRd4tFfXYgbjCQO3N7HClEiIrHv
	xTtGkHskBF6yS+zdvYoZYpeAxLfJh1ggemUlNh1ghnhYUuLgihssExglZiHZPAvJ5llINs9C
	smIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJDYnbiD8f4B60OMyUDrJzJLiSbnA2M/
	ryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mq5Y/
	Zo1z2Fu8cMv87aW1KT/PXmVZp/00SUDRSSemTegK86zGfSd+Vyyxnt15YcfLvW+PCcl7N7+2
	Vd1b8pJJ/KvofDuPpSkfXAW+M8QVXMnTf6y0s7siS+224EttgdJVjx6Hvp5fsqQ0bmuZ/MlP
	XZvTz/oJ/5I9l6e6+9GqkxtebNIqmlO0R4mlOCPRUIu5qDgRAAA9lP3zAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd3w3q2BBqvmq1psenyN1eLyrjls
	Frcv81qcuv6ZzeLYjCWMFvser2F2YPNoae5h89g56y67x51re9g8Ni+p97hyoonV4/MmuQC2
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGbffXGYveMVeMWHKbrYGxmls
	XYycHBICJhJTp7RA2WISF+6tB7OFBKYzSiw4YtjFyAVk/2WUmD9nOzNIgk1AQ+Lw+2fsILaI
	gJpE499OVpAiZoEjjBJHDpxlgeh2krj2aRsTiM0p4Cxx9+whsAZhATeJ4zcWgcVZBFQlznxZ
	ygpi8wrYSpw6DNHLKyAo8WPyPTCbWUBLYv3O40wQtrzE5jVvgY7gALpUXeLRX12IG4wkDtze
	xwpRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4MTyT3sG4qsHiEKMAB6MSD++DX1sChVgTy4orcw8xSnAwK4nwzmrYGijEm5JYWZValB9f
	VJqTWnyIMRno0YnMUqLJ+cCklVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC
	1CKYLUwcnFINjA52TPob7B6d4zAWm/PnjdwfEdYv1T13w3efk0h/XCclECB/ap1LUUZY/Oab
	e9NZvLiW8E1P+G/BqJ55fcNlV5/oK/u/9U55kNDVx9/Eu+t9ZvF7nrdvOVYJXLuzgHHhn/R/
	vh+ssq4ckl5V+evOHlmrf91+C1yTNub67YiZk6wfaRl4b0VshxJLcUaioRZzUXEiAId1AXVQ	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjin Kim wrote:
> 
> This patch is to add vmmc regulator node at MSHC and SDHCI for ODROID-X
> board file.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidx.dts |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
> index 1786225..3f3d7c8 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidx.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -44,6 +44,7 @@
>  		pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
>  		pinctrl-names = "default";
>  		status = "okay";
> +		vmmc-supply = <&ldo20_reg &buck8_reg>;
> 
>  		num-slots = <1>;
>  		supports-highspeed;
> @@ -78,6 +79,7 @@
>  		bus-width = <4>;
>  		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
>  		pinctrl-names = "default";
> +		vmmc-supply = <&ldo4_reg &ldo21_reg>;
>  		status = "okay";
>  	};
> 
> --
> 1.7.9.5

Applied, thanks.

- Kukjin

