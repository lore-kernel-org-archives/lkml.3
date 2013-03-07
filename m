Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3CGANT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:13:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22590 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3CGANR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:13:17 -0500
X-AuditID: cbfee690-b7f6b6d000004563-bd-5137db9bfee5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
References: <1362567231.16460.175.camel@x61.thuisdomein>
In-reply-to: <1362567231.16460.175.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: drop "select HAVE_SCHED_CLOCK"
Date: Thu, 07 Mar 2013 09:13:15 +0900
Message-id: <014201ce1ac8$8ff12510$afd36f30$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aWORM1IEnzDeoSNeU/sYTLYCopQAb5ntQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zY93Zt80DDQ7NULXY9Pgaq8XlXXPY
	LGac38dkcfsyr8WiW2eYHVg9Wpp72Dw2L6n32Lj9CZPH501yASxRXDYpqTmZZalF+nYJXBk9
	71tYCyZwVfz4+JupgXEyRxcjJ4eEgInEkZ872SBsMYkL99YD2VwcQgLLGCUOr9nFAlM05etR
	VhBbSGA6o8T25yIQRX8ZJfYf3c0MkmAT0JA4/P4ZO4gtIuAncbDrPBOIzSyQLXHkyxZ2iGYL
	ieZNv8AGcQpYSkxetwysVxgofupvJ5jNIqAqcbBvBVgvr4CtxLaFN9khbEGJH5PvAR3EATRT
	XWLKlFyI8fISm9e8ZQYJSwCFH/3VhbjASOLV5xtQF4hI7HvxjhHkZAmBc+wS86Z+YYdYJSDx
	bfIhFoheWYlNB5gh3pWUOLjiBssERolZSBbPQlg8C8niWUg2LGBkWcUomlqQXFCclF5kolec
	mFtcmpeul5yfu4kREpcTdjDeO2B9iDEZaPtEZinR5HxgXOeVxBsaG5uYmZiamFuampuSJqwk
	zit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OQabrf6cM+GlaLr19Qvq70R+/Ljaxv
	JfeXc9+93Wy+dM69yw/mnUmJyDt3suK8wFy+vP+ThDSZ9wm6s6mp6Aj//vgw2t7K50P5lTqX
	+3t/SByzDmnZ7MJw3cOjam+YU1fRU3PP7QtbFJoE+Y6UdG5esTT+4/S6v80/LH+vD4raV1fx
	dGKxargSS3FGoqEWc1FxIgBct/6Z4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd3Zt80DDT4ckrfY9Pgaq8XlXXPY
	LGac38dkcfsyr8WiW2eYHVg9Wpp72Dw2L6n32Lj9CZPH501yASxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZPe9bWAsmcFX8+PibqYFxMkcXIyeHhICJxJSvR1khbDGJ
	C/fWs4HYQgLTGSW2PxfpYuQCsv8ySuw/upsZJMEmoCFx+P0zdhBbRMBP4mDXeSYQm1kgW+LI
	ly3sEM0WEs2bfoEN5RSwlJi8bhlYrzBQ/NTfTjCbRUBV4mDfCrBeXgFbiW0Lb7JD2IISPybf
	Y+li5ACaqS4xZUouxHh5ic1r3jKDhCWAwo/+6kJcYCTx6vMNqAtEJPa9eMc4gVFoFpJBsxAG
	zUIyaBaSjgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP+mfQOxlUNFocYBTgYlXh4
	N+aYBwqxJpYVV+YeYpTgYFYS4b27BCjEm5JYWZValB9fVJqTWnyIMRnozYnMUqLJ+cCElFcS
	b2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGHWsVY43H30wrZJp
	6Y9w/SLVtA8Tb01L3We7dobJ3T9xMwVefgyNWLvfRmnlrZrjgaenPbmp9/vOs7cPeFInx0uv
	ZtJuft3JxeHYw7TnVJUp7/7k+Vx3701c36LCl3DIYU7E7UPb75v8ODZR84c9e4qxvDprTaPK
	W91t+bmnLQwMv321WlHA9E6JpTgj0VCLuag4EQARaGO1PgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> The Kconfig symbol HAVE_SCHED_CLOCK got removed in v3.4, with commit
> 6905a65879b51d326396e63dfea40861a30bc17f ("ARM: Make the sched_clock
> framework mandatory"). Drop the last two select statements for that
> symbol too. They're useless now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep" only.
> 
>  arch/arm/Kconfig             | 1 -
>  arch/arm/mach-exynos/Kconfig | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 0c990b7..2530799 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1172,7 +1172,6 @@ config PLAT_VERSATILE
>  config ARM_TIMER_SP804
>  	bool
>  	select CLKSRC_MMIO
> -	select HAVE_SCHED_CLOCK
> 
>  source arch/arm/mm/Kconfig
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 068aeb5..acfdbcf 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -253,7 +253,6 @@ config MACH_UNIVERSAL_C210
>  	select EXYNOS4_SETUP_USB_PHY
>  	select EXYNOS_DEV_DMA
>  	select EXYNOS_DEV_DRM
> -	select HAVE_SCHED_CLOCK
>  	select S3C_DEV_HSMMC
>  	select S3C_DEV_HSMMC2
>  	select S3C_DEV_HSMMC3
> --
> 1.7.11.7

Right, applied.

Thanks.

- Kukjin

