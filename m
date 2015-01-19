Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbbASKB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:01:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51133 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbASKB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:01:56 -0500
X-AuditID: cbfee68d-f79296d000004278-77-54bcd60578b1
Message-id: <54BCD604.3030105@samsung.com>
Date: Mon, 19 Jan 2015 19:01:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCHv8 7/9] ARM: dts: Add PPMU dt node for Exynos5260 SoC
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
 <1421066097-26237-8-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421066097-26237-8-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkQJf12p4Qg18ruC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcViSTO3xesXhhb9j18zW5xtesNusenxNVaLy7vmsFl87j3CaDHj/D4mi6XX
	LzJZ3G5cwWbxeMVbdovWvUfYLVbt+sPoIOixZt4aRo+ds+6yeyze85LJY9OqTjaPzUvqPfq2
	rGL0+LxJLoA9issmJTUnsyy1SN8ugStj5srYgityFQunPGduYNwn3sXIySEhYCLxsvkHG4Qt
	JnHh3nogm4tDSGApo8TcJffYYIr+/e6DSixilOjvvMAC4bxmlNjS8YYVpIpXQEui6e4NIJuD
	g0VAVeLn90iQMBtQeP+LG2CDRAXCJFZOv8ICUS4o8WPyPTBbREBDYubfK4wgM5kFdjFLLJn3
	nwkkISzgITFj/y12iGWNjBL3754Em8Qp4CYx934HM4jNLKAjsb91GhuELS+xec1bZpAGCYGF
	HBIbPy0DS7AICEh8m3yIBeQ6CQFZiU0HmCFek5Q4uOIGywRGsVlIjpqFZOwsJGMXMDKvYhRN
	LUguKE5KLzLUK07MLS7NS9dLzs/dxAiM9dP/nvXuYLx9wPoQowAHoxIP7wbfPSFCrIllxZW5
	hxhNga6YyCwlmpwPTCh5JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtSi+KLSnNS
	iw8xMnFwSjUw3s311tW6bXPU3+Qg2+28Fytv2Iavfv3gaX7R9LsZz7emdYiwhK1nOfqP89vE
	hRMlTCWTvJKeLzYMWpL4OjDdILDnRkyqzoW3nKY3/NrYRKySbX6tWKbXUn5VLenlp68Stx7K
	NwQfvPl6tsYRE+dtH//6rzw5+fg6caaoNLEou0NnxL8UJancUmIpzkg01GIuKk4EABMKHxPw	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3Wa3tCDK6sZrJ4vGYxk8XGGetZ
	La5/ec5qMen+BBaLJc3cFq9fGFr0P37NbHG26Q27xabH11gtLu+aw2bxufcIo8WM8/uYLJZe
	v8hkcbtxBZvF4xVv2S1a9x5ht1i16w+jg6DHmnlrGD12zrrL7rF4z0smj02rOtk8Ni+p9+jb
	sorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRef
	AF23zBygB5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGTNXxhZckatY
	OOU5cwPjPvEuRk4OCQETiX+/+9ggbDGJC/fWA9lcHEICixgl+jsvsEA4rxkltnS8YQWp4hXQ
	kmi6ewPI5uBgEVCV+Pk9EiTMBhTe/+IG2CBRgTCJldOvsECUC0r8mHwPzBYR0JCY+fcKI8hM
	ZoFdzBJL5v1nAkkIC3hIzNh/ix1iWSOjxP27J8EmcQq4Scy938EMYjML6Ejsb53GBmHLS2xe
	85Z5AqPALCRLZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4ETyTGoH48oG
	i0OMAhyMSjy8HAF7QoRYE8uKK3MPMUpwMCuJ8DJeAArxpiRWVqUW5ccXleakFh9iNAUGwURm
	KdHkfGCSyyuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYHR7OU17
	SZ7Kh5wFBznfsJRGNX7T+cY+98pkXzXf+r0FJdfT3V6UGi4RvrbJYmGo+tqHXk9des+8C1cK
	1a69/l3hTVZh2AOGata49M96VzfYGC4JTP4itGYe057XGR9nXXnksr1Nd8OKA+v9gqRmL1i5
	e4rUmv0buBnO+c/5pLZULSJM7omp8BUlluKMREMt5qLiRADHGeCDOgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I'll drop this patch because I can't test it on Exynos5260-based board.

Best Regards,
Chanwoo Choi

On 01/12/2015 09:34 PM, Chanwoo Choi wrote:
> This patch adds PPMU (Performance Profiling Monitoring Unit) dt node
> Exynos5260 SoC.
> 
> Exynos5260 SoC has following PPMU IPs:
> - PPMU_DREX0_S0 0x10c60000
> - PPMU_DREX0_S1 0x10c70000
> - PPMU_DREX1_S0 0x10c80000
> - PPMU_DREX1_S1 0x10c90000
> - PPMU_EAGLE    0x10cc0000
> - PPMU_KFC      0x10cd0000
> - PPMU_MFC      0x11040000
> - PPMU_G3D      0x11880000
> - PPMU_FSYS     0x12220000
> - PPMU_ISP      0x13370000
> - PPMU_FICM     0x13cb0000
> - PPMU_GSCL     0x13e60000
> - PPMU_MSCL     0x13ee0000
> - PPMU_FIMD0X   0x145b0000
> - PPMU_FIMD1X   0x145c0000
> 
> The drivers/devfreq/exynos/exynos5_bus.c supports the memory bus frequency/
> voltage scaling of Exynos5260 SoC with DEVFREQ framework.
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Abhilash Kesavan <a.kesavan@samsung.com>
> Cc: Jonghwan Choi <jhbird.choi@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5260.dtsi | 90 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos5260.dtsi
> index 36da38e..26f3074 100644
> --- a/arch/arm/boot/dts/exynos5260.dtsi
> +++ b/arch/arm/boot/dts/exynos5260.dtsi
> @@ -307,6 +307,96 @@
>  			fifo-depth = <64>;
>  			status = "disabled";
>  		};
> +
> +		ppmu_drex0_s0: ppmu_drex0_s0@10c60000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x10c60000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_drex0_s1: ppmu_drex0_s1@10c70000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x10c70000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_drex1_s0: ppmu_drex1_s0@10c80000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x10c80000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_drex1_s1: ppmu_drex1_s1@10c90000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x10c90000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_eagle: ppmu_eagle@10cc0000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x10cc0000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_kfc: ppmu_kfc@10cd0000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x10cd0000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_mfc: ppmu_mfc@11040000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x11040000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_g3d: ppmu_g3d@11880000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x11880000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_fsys: ppmu_fsys@12220000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x12220000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_isp: ppmu_isp@13370000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x13370000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_fimc: ppmu_fimc@13cb0000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x13cb0000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_gscl: ppmu_gscl@13e60000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x13e60000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_mscl: ppmu_gscl@13ee0000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x13ee0000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_fimd0x: ppmu_fimd0x@145b0000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x145b0000 0x2000>;
> +			status = "disabled";
> +		};
> +
> +		ppmu_fimd1x: ppmu_fimd1x@145c0000 {
> +			compatible = "samsung,exynos-ppmu";
> +			reg = <0x145c0000 0x2000>;
> +			status = "disabled";
> +		};
>  	};
>  };
>  
> 

