Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754AbaDJKXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:23:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56553 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaDJKXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:23:49 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-fa-53467133ad05
From: Chanho Park <chanho61.park@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org
Cc: hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-13-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397124377-16969-13-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH 21/27] ARM: dts: exynos3250: Add PMU dt data
Date: Thu, 10 Apr 2014 19:23:48 +0900
Message-id: <002701cf54a6$f6593720$e30ba560$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGB6meoV0Op4c6O0JoKYhIbL435PgJb7Dfam5KYRLA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkUNe40C3YYMo7Y4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mq4tnwzU8EanopZM86yNzDO5Opi5OSQEDCRmPZr
	FyuELSZx4d56ti5GLg4hgaWMEpvetrPDFN1b+JAZIjGdUaJ56zuwhJDAP0aJg1+CQWw2AV2J
	Lc9fMYLYIgJVEm0fehhBGpgFDjFKzP+wiAWiu4lR4tPh88wgVZwC7hKv3u9hArGFBRwkTp7e
	AxTn4GARUJWY1ykFEuYVsJQ4sHgGI4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIS5VkNhx
	9jXUEVYSp9e9hqoRkdj34h3YQRICf9kl3rctAvuZRUBA4tvkQywgeyUEZCU2HYCaIylxcMUN
	lgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgTJ/+96x3
	B+PtA9aHGJOB1k9klhJNzgemhLySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYCxwC5xw4TLPn/3nIrbn/9t0rlhqRbnHSZ6in2KHLlX5COkrbzD1
	buONtfx7im3F2j856Y9ev+tcFS11qfNavPb60JwbVj1tLwVdX1c159Rdl/og0dmdzOBfKtrp
	pRB24rTQqo8Mi69ujVENW3W6n8VX+FFH+F29DVumaXNtfXiqMuPTht/HfJRYijMSDbWYi4oT
	AYQeKf7/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQV3jQrdgg6k/lC2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxrXlm5kK
	1vBUzJpxlr2BcSZXFyMnh4SAicS9hQ+ZIWwxiQv31rN1MXJxCAlMZ5Ro3vqOHSQhJPCPUeLg
	l2AQm01AV2LL81eMILaIQJVE24ceRpAGZoFDjBLzPyxigehuYpT4dPg82FhOAXeJV+/3MIHY
	wgIOEidP7wGKc3CwCKhKzOuUAgnzClhKHFg8gxHCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3
	UJcqSOw4+xrqCCuJ0+teQ9WISOx78Y5xAqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECE4Yz6R2MK5ssDjEKMDBqMTDe2CZa7AQa2JZcWUu0OcczEoivLsz
	3YKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YzPJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Q
	ah0oJJCeWJKanZpakFoEs4WJg1OqgdGeJfyl54u3BydNa9JxUz+qqTZF63fwjQ/1/jMXvI1c
	MbvP7U+c/UHfumMHbzC85xE/s8pbpjf65rdfh3j29y9pCF8R1zLxWurreSHZEkf8mK/tnueT
	8tg9c4v8zqojhdV7+BgvOC9qW7rIZqZw2ve6x645b29bLY7a2Dj7/+K5cbFCU9ieR/UqsRRn
	JBpqMRcVJwIAYeeuIlwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Chanwoo Choi
> Sent: Thursday, April 10, 2014 7:06 PM
> To: kgene.kim@samsung.com; t.figa@samsung.com; linux-samsung-
> soc@vger.kernel.org
> Cc: hyunhee.kim@samsung.com; sw0312.kim@samsung.com; linux-
> kernel@vger.kernel.org; yj44.cho@samsung.com; inki.dae@samsung.com;
> cw00.choi@samsung.com; kyungmin.park@samsung.com; linux-arm-
> kernel@lists.infradead.org
> Subject: [PATCH 21/27] ARM: dts: exynos3250: Add PMU dt data
> 
> From: Hyunhee Kim <hyunhee.kim@samsung.com>
> 
> ARM CPU has its own PMU (Performance Monitoring Unit). This patch add
> PMU dt
> data to support PMU for CPU. Exynos3250 has four PMU interrupts.
> 
> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi
> b/arch/arm/boot/dts/exynos3250.dtsi
> index ceed761..2f0ca32 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -280,4 +280,9 @@
>  		pinctrl-0 = <&i2c7_bus>;
>  		status = "disabled";
>  	};
> +
> +	pmu {
> +		compatible = "arm,cortex-a7-pmu";
> +		interrupts = <0 18 0>, <0 19 0>, <0 20 0>, <0 21 0>;
> +	};

As I know, the exynos3250 has two CPU cores. Why does it have four pmu
interrupts?
IMO it is sufficient it has only two interrupts.

Best Regards,
Chanho Park 

