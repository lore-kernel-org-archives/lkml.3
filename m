Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3BDWpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:45:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40498 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3BDWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:45:33 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-dc-51103a0acd6d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1358959242-1667-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1358959242-1667-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH] ARM: dts: Fix MSHC property and add RTC node
Date: Mon, 04 Feb 2013 14:45:18 -0800
Message-id: <11f301ce0329$50329dc0$f097d940$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJukooklfXeOqMGu0MAxZ6x5EO6a5cpLEOg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zA10uK4FAg11zTS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGthuX2At2cFa8mJvVwLievYuRk0NCwERi65EfULaYxIV769m6
	GLk4hASWMUq86JnFDFP0YeVGFhBbSGARo8S5XkOIonlMEucXfwbrZhPQkDj8/hmYLSKgJtH4
	t5MVpIhZYAqjxOq3X5gguh0lXn2+AjaJU8BJYuOzjWBxYaD42lOrwJpZBFQlLu87AFbDK2Ap
	cWjDH1YIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17yFulRBYsfZ14wQRxhJTF+9jx2iRlxi0oOH
	7CAHSQhMZ5dYeLaZFWKZgMS3yYeAhnIAJWQlNh2AmiMpcXDFDZYJjBKzkKyehWT1LCSrZyFZ
	sYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGSGxJ7WBc2WBxiFGAg1GJh/fHZf5AIdbE
	suLK3EOMEhzMSiK8H28AhXhTEiurUovy44tKc1KLDzEmAx07kVlKNDkfGPd5JfGGxsYmZiam
	JuaWpuampAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoFRUOrdW7ZbRRaTMl5u3ZrSwcF6
	xDlU7+Ga1kvsL/++8ZeTTz0stZSPR2LzXt6jp3vSPKVFdhgbrD1w7au798NV/uzZBtIXvy+f
	PSPn/SrzVdrBJ5nz/9k5ZZxtaXwjwVwZ3H72v3zbc8mUwG0nYkPm5PAmTvfeMafrwB25q0e+
	m5lfmX0vPbVZiaU4I9FQi7moOBEA7bAXCPECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgC6XlUCgQc8yA4vLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYse3GJfaCHZwVL+ZmNTCu
	Z+9i5OSQEDCR+LByIwuELSZx4d56NhBbSGARo8S5XsMuRi4gex6TxPnFn8Ea2AQ0JA6/fwZm
	iwioSTT+7WQFKWIWmMIosfrtFyaIbkeJV5+vgE3lFHCS2PhsI1hcGCi+9tQqsGYWAVWJy/sO
	gNXwClhKHNrwhxXCFpT4MfkeWJxZQEti/c7jTBC2vMTmNW+ZIS5VkNhx9jUjxBFGEtNX72OH
	qBGXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HLnPpHYwrmywOMQowMGoxMP74zJ/oBBrYllxZe4hRgkOZiUR3o83gEK8KYmVValF+fFFpTmp
	xYcYk4E+ncgsJZqcD0wqeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5YkpqdmlqQWgSz
	hYmDU6qB8UCINFdZ5dHkVu0NXccmPhA61rysXbvpx+z8XV2Vlx86KNfycFrev5u5PvJLk7rb
	qYc34nYqvPsc8mzBt1f1tSJd3jr+fh4LudgkrqdMKFF+8mDdx29aMyRLlb02/fnaJs+n0Re8
	/QDXvRuJwtUZnlNKUiOt/vicePHxzwNWuYl2Pm8vJ8ZsUmIpzkg01GIuKk4EAIuArzEgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjin Kim wrote:
> 
> This fixes the property of dw-mshc-sdr-timing and dw-mshc-ddr-timing as
> per
> its current binding, it only has two cells.

Yes, it should be fixed.

> And also RTC node is added new.

Above two changes should be separated.

> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidx.dts |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
> b/arch/arm/boot/dts/exynos4412-odroidx.dts
> index f41a84e..1c1d5ec 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidx.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -49,8 +49,8 @@
>  		fifo-depth = <0x80>;
>  		card-detect-delay = <200>;
>  		samsung,dw-mshc-ciu-div = <3>;
> -		samsung,dw-mshc-sdr-timing = <2 3 3>;
> -		samsung,dw-mshc-ddr-timing = <1 2 3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;
> 
>  		slot@0 {
>  			reg = <0>;
> @@ -90,4 +90,8 @@
>  	serial@13830000 {
>  		status = "okay";
>  	};
> +
> +	rtc@10070000 {
> +		status = "okay";
> +	};

Please put above node in alphabetical order.

Thanks.

- Kukjin

