Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaKLEUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:20:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28777 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbaKLEU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:20:26 -0500
X-AuditID: cbfee691-f79b86d000004a5a-89-5462e007a7bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@google.com, ajaykumar.rs@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
 <1414675442-3471-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1414675442-3471-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH v2 2/2] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
Date: Wed, 12 Nov 2014 13:21:08 +0900
Message-id: <000101cffe30$155793a0$4006bae0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/0RMzrsRpDgpEPR4ekVihuSDTpBQJ6yDQA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ132B0khBj3rbSwOvD/IYjH/yDlW
	iytf37NZtF05yG5xeeElVovLu+awWcw4v4/JYu7BXAcOjwWbSj3udx9n8ujbsorR4/MmuQCW
	KC6blNSczLLUIn27BK6MZ4f/MRd08FQ09+9mbmB8ytnFyMkhIWAisefuOjYIW0ziwr31QDYX
	h5DAMkaJxoX32WGKDk15BpWYzihx/eNVZgjnF6PEjK/rwKrYBNQkvnw5DGaLCOhK9Ez8yAJS
	xCxwnVHiVvtPFoiOVkaJ7tkbGEGqOAU8JFbe6mYCsYUFYiW6379iBbFZBFQlXm35CDaJV8BW
	omvqQjYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveAp3EAXSrusSjv7oQRxhJrLgL0cosICKx
	78U7RpAbJAResktcb7/NDrFLQOLb5EMsEL2yEpsOMEO8LClxcMUNlgmMErOQbJ6FZPMsJJtn
	IVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZI/E7cwXj/gPUhRgEORiUe3ozNSSFC
	rIllxZW5hxhNgS6ayCwlmpwPTBJ5JfGGxmZGFqYmpsZG5pZmSuK8OtI/g4UE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwzuZZXfaerUF96o6+jLzWA/s0GZ+ESAhYNwss4jmy6G18rvYr9m0M
	122Waju3KW4Ut1i9mO3CmWxrcfaFW55022QZt3su8dmy4O+uFyV7/0ft+M95Qzsq+xb7yU+v
	FLtdeWbwMfer2d2dIX5j2d/XMt7ZLwWEXrtbhr//fqYrKjt/7vR4iZ6VSizFGYmGWsxFxYkA
	F6gYadoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV32B0khBn3fzS0OvD/IYjH/yDlW
	iytf37NZtF05yG5xeeElVovLu+awWcw4v4/JYu7BXAcOjwWbSj3udx9n8ujbsorR4/MmuQCW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGc8O/2Mu6OCpaO7fzdzA+JSz
	i5GTQ0LAROLQlGdsELaYxIV764FsLg4hgemMEtc/XmWGcH4xSsz4uo4dpIpNQE3iy5fDYLaI
	gK5Ez8SPLCBFzALXGSVutf9kgehoZZTonr2BEaSKU8BDYuWtbiYQW1ggVqL7/StWEJtFQFXi
	1ZaPYJN4BWwluqYuZIOwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt0EkcQLeqSzz6qwtxhJHE
	irsQrcwCIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYKTwzPpHYyrGiwOMQpwMCrx8GZsTgoRYk0sK67MPcQowcGsJML7YClQiDclsbIqtSg/
	vqg0J7X4EKMp0KMTmaVEk/OBiSuvJN7Q2MTMyNLIzMLIxNxcSZz3YKt1oJBAemJJanZqakFq
	EUwfEwenVAOjW1DU/ReBd7+b+woVpiotqdsfWSlm33qhMadJYP3cO3mJ4v1htyNmpN0V8bsz
	ybVDiXtPxgbDOYEv786z8H0owy71v81Il1uXo7urSErXbf9fZ0k22b54012e17ntciZ/jD1Y
	81932VHb128Nfz2zm/skUphD632C6MVvfxYVHHsTvZ6pbYsSS3FGoqEWc1FxIgDOEyC8JAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 30, 2014 10:24 PM, Vivek Gautam wrote:
> 
> DP PHY now require pmu-system-controller to handle PMU register
> to control PHY's power isolation. Adding the same to dp-phy
> node.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 
> Changes from V1:
>  - none.
> 
>  arch/arm/boot/dts/exynos5250.dtsi |    2 +-
>  arch/arm/boot/dts/exynos5420.dtsi |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 012b021..69f5eb0 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -732,7 +732,7 @@
> 
>  	dp_phy: video-phy@10040720 {
>  		compatible = "samsung,exynos5250-dp-video-phy";
> -		reg = <0x10040720 4>;
> +		samsung,pmu-syscon = <&pmu_system_controller>;
>  		#phy-cells = <0>;
>  	};
> 
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 8617a03..1353a09 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -503,8 +503,8 @@
>  	};
> 
>  	dp_phy: video-phy@10040728 {
> -		compatible = "samsung,exynos5250-dp-video-phy";
> -		reg = <0x10040728 4>;
> +		compatible = "samsung,exynos5420-dp-video-phy";
> +		samsung,pmu-syscon = <&pmu_system_controller>;
>  		#phy-cells = <0>;
>  	};
> 
> --
> 1.7.10.4

