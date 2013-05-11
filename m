Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3EKFHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:07:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60921 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3EKFHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:07:52 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-74-518dd2129f78
From: Jingoo Han <jg1.han@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1368034636-15865-1-git-send-email-dianders@chromium.org>
In-reply-to: <1368034636-15865-1-git-send-email-dianders@chromium.org>
Subject: Re: [PATCH] ARM: exynos: dts: Fixed vbus-gpios
Date: Sat, 11 May 2013 14:07:29 +0900
Message-id: <002501ce4e05$6fe4c630$4fae5290$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGgsM3r3wWtBqS/WdKhiVMEhfKEY5laqMVA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zga7Qpd5Ag6mPuSwezNvGZnF22UE2
	i7YrB9ktLi+8xGrRu+Aqm8Wmx9dYLS7vmsNmcfsyr8Wp65/ZLKYsOsxq8W3LNkaLYzOWMFqs
	2vWH0YHXo6W5h81jdsNFFo+ds+6ye9y5tofNY/OSeo8rJ5pYPfq2rGL0+LxJLoAjissmJTUn
	syy1SN8ugSvj1qtn7AWnuSo6WlawNzCe5Ohi5OSQEDCRuNN+iRHCFpO4cG89WxcjF4eQwDJG
	ic8fJjPCFL26tJ8RIjGdUaL/SDMzhPOLUWLvmoXMIFVsAmoSX74cZu9i5OAQEQiW+HfeH6SG
	WWAXs0Tb4rtMIDVCAq4S/7ufsYPYnAJuEnc3H2MBsYUFzCW2T/gKto1FQFVixdSnbCBzeAUs
	JXpOSYKEeQUEJX5MvgdWziygJbF+53EmCFteYvOat8wQhypI7Dj7GmyMiICRRNO6G+wQNSIS
	+168A3tAQmALh8Tc+aeZIHYJSHybfIgFZJeEgKzEpgNQcyQlDq64wTKBUWIWktWzkKyehWT1
	LCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQISQp9OxhvHrA+xJgMtH4is5Rocj4w
	qeSVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdGN
	7+wZ32VXH3yRY2sKWcu73ZfjhcUjzfjrhlc9J7mkWbO8mvLMP7Mt5F5X3bT5AZxz7RaumJSV
	N2vl9U17tNst1skyvGk2bAxrN/rTfGrm/AeM618/5Luq8Nbx0sLWe/EraqV8g2N2iCjrrhaK
	WMUt+i7EKITzPmtmuRTzz6mrZG9FWP+T8FdiKc5INNRiLipOBAA/nZpYIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t9jQV2hS72BBrP2s1o8mLeNzeLssoNs
	Fm1XDrJbXF54idWid8FVNotNj6+xWlzeNYfN4vZlXotT1z+zWUxZdJjV4tuWbYwWx2YsYbRY
	tesPowOvR0tzD5vH7IaLLB47Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABHVAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QyUoKZYk5pUCh
	gMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjFuvnrEXnOaq6GhZwd7AeJKji5GTQ0LA
	ROLVpf2MELaYxIV769m6GLk4hASmM0r0H2lmhnB+MUrsXbOQGaSKTUBN4suXw+xdjBwcIgLB
	Ev/O+4PUMAvsYpZoW3yXCaRGSMBV4n/3M3YQm1PATeLu5mMsILawgLnE9glfwbaxCKhKrJj6
	lA1kDq+ApUTPKUmQMK+AoMSPyffAypkFtCTW7zzOBGHLS2xe85YZ4lAFiR1nX4ONEREwkmha
	d4MdokZEYt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcMp5JrWDcWWDxSFGAQ5GJR5eBYHeQCHWxLLiytxDjBIczEoivEemA4V4UxIrq1KL8uOL
	SnNSiw8xJgM9OpFZSjQ5H5gO80riDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQ
	WgSzhYmDU6qBUcJT9u3kjgk1WmfmRsa5Sd3uF5o3W1hbtCq/nnOp4nPRaV82xe0t3Si2vcrs
	h5Su8np/Ra0swRU6Yvo2BaXGMn3yjMemqS5875X93sn85P30bQEbb61a9fmgF9en5ot108NK
	0xLvbH4WtHneBoPbVf7bN7o6WV2KTAh4I/d9aeTjt+cs12/jV2Ipzkg01GIuKk4EAPUfS6t9	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 09, 2013 2:37 AM, Doug Anderson wrote:
> 
> The 'samsung,vbus-gpio' was submitted before pinmux landed for
> exynos5250 and uses the old-style gpio specifier.  Fix the two
> exynos5250 boards that use it.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  arch/arm/boot/dts/exynos5250-smdk5250.dts | 2 +-
>  arch/arm/boot/dts/exynos5250-snow.dts     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index 26d856b..3e0c792 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -214,7 +214,7 @@
>  	};
> 
>  	usb@12110000 {
> -		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +		samsung,vbus-gpio = <&gpx2 6 0>;
>  	};
> 
>  	dp-controller {
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index bf4744b..d449feb 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -183,7 +183,7 @@
>  	};
> 
>  	usb@12110000 {
> -		samsung,vbus-gpio = <&gpx1 1 1 3 3>;
> +		samsung,vbus-gpio = <&gpx1 1 0>;
>  	};
> 
>  	fixed-rate-clocks {
> --
> 1.8.2.1

