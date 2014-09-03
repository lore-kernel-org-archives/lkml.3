Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaICNuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:50:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48575 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbaICNus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:50:48 -0400
X-AuditID: cbfee690-f79ce6d00000115a-6c-54071cb66dde
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <1409062405-15215-1-git-send-email-t.figa@samsung.com>
In-reply-to: <1409062405-15215-1-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH] ARM: dts: exynos4x12: Fix pull setting in sd4_width8 pin
 group
Date: Wed, 03 Sep 2014 22:50:46 +0900
Message-id: <02ed01cfc77e$0fede790$2fc9b6b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIoG+gG2A9OPxyuujSakoxof+pLLZs+w8wg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI91tMuwhBjMuqFhsenyN1eLyrjls
	FjPO72OyWHvkLrsDi8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfG6pZGp4CR7xYGL
	LYwNjG1sXYycHBICJhLv/+2CssUkLtxbD2RzcQgJLGOUeHnoFBNM0fTD66ASixglOo81Qjl/
	GSWOnD/ICFLFJqAhcfj9M3YQW0TAU+LBqQNgNrNAuUTDzF6wGiEBJ4nW2VtZQWxOAWeJF81X
	mEFsYYFQiafPloDVsAioSjyedhYszitgKXHl7gkmCFtQ4sfkeywQM7Uk1u88zgRhy0tsXvOW
	GeJSBYkdZ18zQtxgJLHnzxeoG0Qk9r14xwhytITALnaJt/uvsUAsE5D4NvkQkM0BlJCV2HQA
	ao6kxMEVN1gmMErMQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsY
	IdE4YQfjvQPWhxgFOBiVeHgXBLCFCLEmlhVX5h5iNAW6aCKzlGhyPjDm80riDY3NjCxMTUyN
	jcwtzZTEeV9L/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOhSF/op/4kCj/y7gPPV+tMK
	g1e35KgX/9zEanHCO2i38rETKQoN3HOvxetKvHhp/GcX+5UX95OPMwRHLTvleeJIm96LuXP1
	xLUfhDs1n9A1medv1rZJ7dSZzXUCsh67NV6sKHuVkC3c0KvJw322Wvfq4euNZ/TV3O7f2X3Y
	UXz6hajD3/5dPq7EUpyRaKjFXFScCADV3DFJwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAd1tMuwhBsu7FS02Pb7GanF51xw2
	ixnn9zFZrD1yl92BxWPzknqPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x43dLIVHCSveLAxRbGBsY2ti5GTg4JAROJ6YfXQdliEhfurQeyuTiEBBYx
	SnQea4Ry/jJKHDl/kBGkik1AQ+Lw+2fsILaIgKfEg1MHwGxmgXKJhpm9YDVCAk4SrbO3soLY
	nALOEi+arzCD2MICoRJPny0Bq2ERUJV4PO0sWJxXwFLiyt0TTBC2oMSPyfdYIGZqSazfeZwJ
	wpaX2LzmLTPEpQoSO86+ZoS4wUhiz58vUDeISOx78Y5xAqPQLCSjZiEZNQvJqFlIWhYwsqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI71Z9I7GFc1WBxiFOBgVOLhXRDAFiLEmlhWXJl7
	iFGCg1lJhHeNNHuIEG9KYmVValF+fFFpTmrxIUZToE8nMkuJJucD01BeSbyhsYmZkaWRmYWR
	ibm5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZGhtB3exKVTGb8XbGq+31gXNXCyX2LGzqq
	DJbZdF66Z5zI4+HOsdWEuc3g1yxpfhGLRYdumLVcNJxbNmvtvqKka5YLz7G4XXm0oHhPqEsz
	32XGCeVbnYMiZ6/X/rJkYrmcsUtI985FB5jUb8QYLz4bW8Z7Zrf2rLdrw3K6Bdf2HQ6sv+a0
	0FhPiaU4I9FQi7moOBEAQaIORQsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> The group has the samsung,pin-pud property set to 4, which is not a
> correct value. This patch fixes this by replacing it with 3, which is
> the correct value for pull-up.
> 
Yes, I checked the value. You're right.

Will apply into fixes.

Thanks,
Kukjin

> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
> index 927fec6..c141931 100644
> --- a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
> @@ -691,7 +691,7 @@
>  		sd4_bus8: sd4-bus-width8 {
>  			samsung,pins = "gpk1-3", "gpk1-4", "gpk1-5", "gpk1-6";
>  			samsung,pin-function = <4>;
> -			samsung,pin-pud = <4>;
> +			samsung,pin-pud = <3>;
>  			samsung,pin-drv = <3>;
>  		};
> 
> --
> 2.0.4

