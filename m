Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbbA2Hwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:52:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33541 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbbA2Hwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:52:34 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-81-54c9e6c06047
Date: Thu, 29 Jan 2015 08:52:26 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: rui.zhang@intel.com, edubezval@gmail.com, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, amit.daniel@samsung.com,
        kesavan.abhilash@gmail.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v4 1/2] dts: Documentation: Add documentation for Exynos7
 SoC thermal bindings
Message-id: <20150129085226.14f316f0@amdc2363>
In-reply-to: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
References: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAd0Dz06GGPy4LmbxeM1iJouGqyEW
	G2esZ7WYf+Uaq8Wav0oWvQuusllc3jWHzeJz7xFGixnn9zFZPHnYx+bA5bFz1l12j8V7XjJ5
	9G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8a/079YCrr5K952nWFvYNzM08XIySEhYCIxuaeH
	EcIWk7hwbz1bFyMXh5DAIkaJe+c+MEI4vxglnm2aywJSxSKgKvF6wVp2EJtNQE/i892nTCC2
	iICOxOM5EJOYBT4zSnTPlgexhQVSJG68amQGsXmB6lf9fAZWzyngJnGhcTMbiC0k4Cpx7vky
	sDi/gKRE+78fzBAX2Umc+7SBHaJXUOLH5HssEPO1JDZva2KFsOUlNq95yzyBUXAWkrJZSMpm
	ISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Hp5J72Bc1WBxiFGAg1GJhzeh8WSI
	EGtiWXFl7iFGCQ5mJRHe681AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxK9m0hQgLpiSWp2amp
	BalFMFkmDk6pBsZlR367rnAp/xi/cP2JeUxSO2ZrrJXKnpjasuZbv8/FD0t+pHEu2uqQIXzs
	z1axAzamd/e35j071FQ8J45j7yuld3/3sL+66jdZ8MndvqUT9D9tXxB1LEgtZEnJ1C32Zy1a
	jKdurD3BZrPkNKvUB8MVVbsWrAs98WsHG/Me83KmCtXJEpN9i/azK7EUZyQaajEXFScCAAoF
	eMqDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

> Add documentation for exynos7 thermal bindings including compatible
> name and special clock properties.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git
> a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt index
> 0f44932..695150a 100644 ---
> a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt +++
> b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt @@
> -12,6 +12,7 @@ "samsung,exynos5420-tmu-ext-triminfo" for TMU channels
> 2, 3 and 4 Exynos5420 (Must pass triminfo base and triminfo clock)
> "samsung,exynos5440-tmu"
> +	       "samsung,exynos7-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
>  - reg : Address range of the thermal registers. For soc's which has
> multiple instances of TMU and some registers are shared across all
> TMU's like @@ -32,10 +33,13 @@
>  - clocks : The main clocks for TMU device
>  	-- 1. operational clock for TMU channel
>  	-- 2. optional clock to access the shared registers of TMU
> channel
> +	-- 3. optional special clock for functional operation
>  - clock-names : Thermal system clock name
>  	-- "tmu_apbif" operational clock for current TMU channel
>  	-- "tmu_triminfo_apbif" clock to access the shared triminfo
> register for current TMU channel
> +	-- "tmu_sclk" clock for functional operation of the current
> TMU
> +		channel
>  - vtmu-supply: This entry is optional and provides the regulator
> node supplying voltage to TMU. If needed this entry can be placed
> inside board/platform specific dts file.

Acked-by: Lukasz Majewski <l.majewski@samsung.com>

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
