Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbaJ1GtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:49:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17693 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbaJ1Dss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:48:48 -0400
X-AuditID: cbfee68e-f79b46d000002b74-c3-544f121da84b
From: Kukjin Kim <kgene@kernel.org>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        yj44.cho@samsung.com, jaewon02.kim@samsung.com, ideal.song@samsung.com
References: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
 <1414373759-4362-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1414373759-4362-2-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCHv2 1/2] ARM: EXYNOS: Add EXYNOS4415 SoC ID
Date: Tue, 28 Oct 2014 12:48:44 +0900
Message-id: <02b501cff262$127d44b0$3777ce10$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8RNIEvKbq0iSBkCqwA7nWAb+6GAE/eoRUm2I9d6A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zsa6skH+IwaopahZ/Jx1jt7j+5Tmr
	xa6/9xktJt2fwGKxo+EIq8XZpjfsFpseX2O1uLxrDpvFjPP7mCzWHrnLbrH0+kUmi1PXPwPF
	Jr9ks1i16w+jxd6dkxkd+D3WzFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBH
	cdmkpOZklqUW6dslcGWs2buJpaBdoOLWxmlsDYwTebsYOTkkBEwkns5dzAphi0lcuLeerYuR
	i0NIYBmjRPvlc8xdjBxgRStmJ0HEFzFKXOw8yw7h/GWUaH09iwWkiE1AWaKxSR9kkLCAlsTC
	LU0sIDUiApMZJZoPHmYGcZgF/jNK/Jm+C6xBSKBe4vNCLpAGTgFXiZ8fbjFBNNtKvHq1mBnE
	ZhFQlZgw6RkbiM0rYCGxqn02M4QtKPFj8j0WEJsZaNn6nceZIGx5ic1r3jJDfKMgsePsa0YQ
	W0TASuLbxdnsEDUiEvtevGMEuUdC4AiHRPetKywQywQkvk0+xALxsazEpgNQcyQlDq64wTKB
	UXIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQISRx9OxhvHrA+
	xCjAwajEw2vw0C9EiDWxrLgy9xCjKdBFE5mlRJPzgekpryTe0NjMyMLUxNTYyNzSTEmcN0Hq
	Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRuk/77MfuWhxhR1SW5+0ylLuxKkT7urLDwcu
	z7oQcGlz7av+R+9aTX7ufaN0eGOe0ud7q+xk/rWnem1qW5lwUqNDaN0Nm8WBz75nyM3Un1G6
	VUx8bkbykaX7o2c8f1q4aObkreutG+63Re92iXhRzekwTzLKLyX//4qMizJTHHIXTYnRkOT9
	36jEUpyRaKjFXFScCAD+cbBhFwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAV1ZIf8Qg8dvFSz+TjrGbnH9y3NW
	i11/7zNaTLo/gcViR8MRVouzTW/YLTY9vsZqcXnXHDaLGef3MVmsPXKX3WLp9YtMFqeufwaK
	TX7JZrFq1x9Gi707JzM68HusmbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CP
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6XEmh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWbvJpaCdoGKWxunsTUwTuTt
	YuTgkBAwkVgxO6mLkRPIFJO4cG89WxcjF4eQwCJGiYudZ9khnL+MEq2vZ7GANLAJKEs0NumD
	NAgLaEks3NLEAlIjIjCZUaL54GFmEIdZ4D+jxJ/pu8AahATqJT4v5AJp4BRwlfj54RYTRLOt
	xKtXi5lBbBYBVYkJk56xgdi8AhYSq9pnM0PYghI/Jt9jAbGZgZat33mcCcKWl9i85i0zxNUK
	EjvOvmYEsUUErCS+XZzNDlEjIrHvxTvGCYzCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzgtPZPawbiyweIQowAHoxIPr8FDvxAh1sSy4srcQ4wSHMxKIrxe
	O4BCvCmJlVWpRfnxRaU5qcWHGE2BPp3ILCWanA9MmXkl8YbGJmZGlkZmFkYm5uZK4rwHWq0D
	hQTSE0tSs1NTC1KLYPqYODilGhjN3/BJbzv5a8e7k2oHz7w7lmvX5mWsup9n93bVtIgtwmFd
	T4N/JtjWzWXceO4Ztw+zt6jLJrWHz257nFzENfFx+clKbV9eufYTAeEC+sznRc5pVHMf//bt
	5TvGzwfuBD5hOPP1a01W4Q+VWSE+G1RZKo7N/57OV/Fe9KDqzaVHk0tZW04u4DFTYinOSDTU
	Yi4qTgQAWMjFjGEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> This patch add Exynos4415's SoC ID.
> 
Since the CPU ID has been removed as per comments, need to update the commit
message accordingly.

> Exynos4415 is based on the 32-bit RISC
> processor for Smartphone. Exynos4415 uses Cortex A9 quad-cores and has a target
> speed of 1.6GHz and provides 8.5GB/s memory bandwidth.
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig  | 5 +++++
>  arch/arm/mach-exynos/exynos.c | 2 ++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 46f3c0d..349c867 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -75,6 +75,11 @@ config SOC_EXYNOS4412
>  	default y
>  	depends on ARCH_EXYNOS4
> 
> +config SOC_EXYNOS4415
> +	bool "SAMSUNG EXYNOS4415"
> +	default y
> +	depends on ARCH_EXYNOS4
> +

I think, this is not required more...

Thanks,
Kukjin

>  config SOC_EXYNOS5250
>  	bool "SAMSUNG EXYNOS5250"
>  	default y
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 1b46460..1da531f 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -252,6 +252,7 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
>  	{ .compatible = "samsung,exynos4210-pmu" },
>  	{ .compatible = "samsung,exynos4212-pmu" },
>  	{ .compatible = "samsung,exynos4412-pmu" },
> +	{ .compatible = "samsung,exynos4415-pmu" },
>  	{ .compatible = "samsung,exynos5250-pmu" },
>  	{ .compatible = "samsung,exynos5260-pmu" },
>  	{ .compatible = "samsung,exynos5410-pmu" },
> @@ -359,6 +360,7 @@ static char const *exynos_dt_compat[] __initconst = {
>  	"samsung,exynos4210",
>  	"samsung,exynos4212",
>  	"samsung,exynos4412",
> +	"samsung,exynos4415",
>  	"samsung,exynos5",
>  	"samsung,exynos5250",
>  	"samsung,exynos5260",
> --
> 1.8.5.5

