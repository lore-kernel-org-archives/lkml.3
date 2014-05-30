Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbaE3Ltc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:49:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38458 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaE3Lt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:49:28 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-d9-53887045948b
Message-id: <53887045.9010203@samsung.com>
Date: Fri, 30 May 2014 20:49:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, ben-linux@fluff.org, linux@arm.linux.org.uk,
        l.krishna@samsung.com, chanho61.park@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add pmu sysreg node to Exynos3250
References: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSoutW0BFssLOB2WLSugNMFpf3a1tc
	//Kc1WL+kXOsFv1vFrJanHu1ktGid8FVNouzTW/YLXZuucFmsenxNVaLhW1LWCwu75rDZjHj
	/D4mi9uXeS2WXr/IZDFh+loWi7d3prNYtO49wm6xfsZrFgdhjzXz1jB6tDT3sHlc7utl8vi7
	6gWzx8rlX9g8Nq/Q8ti0qhPIWFLv0bdlFaPH501yAVxRXDYpqTmZZalF+nYJXBn/jz1kKmjl
	q7h4kqOBcTN3FyMHh4SAicTpo85djJxAppjEhXvr2boYuTiEBJYyStx+9poFImEisXnib6jE
	dEaJ9Yf/MEI4rxklniz8zQpSxSugJTF96Qp2EJtFQFXiytJWMJsNKL7/xQ02EFtUIExi5fQr
	LBD1ghI/Jt8Ds0UEQiXu77/GBDKUWWADs8TVrVuZQRLCAg4SPZvngxUJCbhKfLpwByzOKeAm
	8XvTXkYQm1lAR2J/6zQ2CFteYvOat8wggyQEjnBInHl9nBXiIgGJb5MPsUD8LCux6QAzxGuS
	EgdX3GCZwCg2C8lNs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgYnh9L9n
	vTsYbx+wPsSYDLRyIrOUaHI+MLHklcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVANj3HWXR0snRjNcKL+9rU3ATr/w+6Wlf7tF9lveDoj0SrIxD/39
	tfdhtDCjJgc7qybDni07Z+5XffDK9PbUhfzhr966hqzN2HFcvWe1Wf03Y+N3O3m3La9r/cnW
	OCV3n58Y+98tEzvdIyKfysXk73zCejtIxV0jM1alMKw1cIVSymfTa9eqGEqUWIozEg21mIuK
	EwHlisnJIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jQV3Xgo5ggw3PTC0mrTvAZHF5v7bF
	9S/PWS3mHznHatH/ZiGrxblXKxktehdcZbM42/SG3WLnlhtsFpseX2O1WNi2hMXi8q45bBYz
	zu9jsrh9mddi6fWLTBYTpq9lsXh7ZzqLReveI+wW62e8ZnEQ9lgzbw2jR0tzD5vH5b5eJo+/
	q14we6xc/oXNY/MKLY9NqzqBjCX1Hn1bVjF6fN4kF8AV1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mJJCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx4/+xh0wFrXwVF09yNDBu5u5i5OSQEDCR2DzxNxuELSZx4d56IJuL
	Q0hgOqPE+sN/GCGc14wSTxb+ZgWp4hXQkpi+dAU7iM0ioCpxZWkrmM0GFN//4gbYJFGBMImV
	06+wQNQLSvyYfA/MFhEIlbi//xoTyFBmgQ3MEle3bmUGSQgLOEj0bJ4PViQk4Crx6cIdsDin
	gJvE7017GUFsZgEdif2t09ggbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRexSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iRGceJ5J72Bc1WBxiFGAg1GJh3dCenuwEGtiWXFl7iFGCQ5mJRHe4/Ed
	wUK8KYmVValF+fFFpTmpxYcYk4FBMJFZSjQ5H5gU80riDY1NzIwsjcwNLYyMzUkTVhLnPdhq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qB0exngfvW970H3mXIGNlGFt1LTxKTC/skdVH8xNsmra1H
	2FdmaerMvTjjBef7LgHb6o1LzDOLN2V07L36c0FJ09GKKFWfI9YSBoyvBPSK28/MfKm9eeeC
	iEhewUkSoWUVPCoTn96WvNYu/jOtPp31iu9xrutyulIO/5cXGHjPsPaR/ZPf/yZciaU4I9FQ
	i7moOBEATxCRV4ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping,

Could you review this patch?

Thanks,
Chanwoo Choi

On 05/26/2014 03:29 PM, Chanwoo Choi wrote:
> This patch add pmusysreg node for Exynos3250 to access PMU (Power Management Unit)
> register in a centralized way using syscon driver.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>  arch/arm/boot/dts/exynos3250.dtsi                     | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> index b562634..2a4ab04 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> @@ -2,6 +2,7 @@ SAMSUNG Exynos SoC series PMU Registers
>  
>  Properties:
>   - compatible : should contain two values. First value must be one from following list:
> +		   - "samsung,exynos3250-pmu" - for Exynos3250 SoC,
>  		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
>  		   - "samsung,exynos4212-pmu" - for Exynos4212 SoC,
>  		   - "samsung,exynos4412-pmu" - for Exynos4412 SoC,
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index ca28eac..3e678fa 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -125,6 +125,11 @@
>  			reg = <0x10010000 0x400>;
>  		};
>  
> +		pmu_system_controller: system-controller@10020000 {
> +			compatible = "samsung,exynos3250-pmu", "syscon";
> +			reg = <0x10020000 0x4000>;
> +		};
> +
>  		pd_cam: cam-power-domain@10023C00 {
>  			compatible = "samsung,exynos4210-pd";
>  			reg = <0x10023C00 0x20>;
> 

