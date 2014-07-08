Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaGHNsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:48:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25499 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaGHNsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:48:18 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-4b-53bbf6a018b0
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-5-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-5-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
Date: Tue, 08 Jul 2014 22:48:15 +0900
Message-id: <033901cf9ab3$44c469a0$ce4d3ce0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQImwlMNtKSRmS2HaaYx0l+evMEXagJmb08gmtSs3yA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ90F33YHG8xYLWCx6fE1VovLu+aw
	Wcw4v4/JYu2Ru+wW62e8ZrFYtesPowObx85Zd9k9Ni+p9+jbsorR4/MmuQCWKC6blNSczLLU
	In27BK6MtdsWMxccEqiYNHsGUwPjFt4uRg4OCQETibd9kl2MnECmmMSFe+vZuhi5OIQEljFK
	HP/7iBUiYSJxsWM9O0RiOqNE27GfzBDOX0aJ5qtr2ECq2AQ0JA6/f8YOYosIeEo8OHUArINZ
	YAGjxNlbM8ASQgLVEqt6djGC2JwCzhK9+x4zgpwhLOAr8WF+EkiYRUBVYsqrPUwgNq+ApcTL
	01PZIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcamCxI6zrxkhbrCS+LtvGzNEjYjEvhfv
	GEHukRC4xy7x+PsRNohlAhLfJh9igQSFrMSmA1BzJCUOrrjBMoFRYhaS1bOQrJ6FZPUsJCsW
	MLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJ1L4djDcPWB9iTAZaP5FZSjQ5HxjpeSXx
	hsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUfaF492z
	XVXffrz7PjVtxUo7Uf1DVjVla7f8Taqs9dXbfefJaXdexnqvAn2ZxVd2Tjg0v3fHTP+S2ue5
	P65865Gdu3PBHo5UXqeDrxrmTl/o71C4uGpvmN69/Drh5w9WCZ63yUwObFQ8lLF59tHKG8wV
	pgfe5a/trVJ6rs164qXkNXOnpkvGwkosxRmJhlrMRcWJAPtgoUfqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoO6Cb7uDDU6t47HY9Pgaq8XlXXPY
	LGac38dksfbIXXaL9TNes1is2vWH0YHNY+esu+wem5fUe/RtWcXo8XmTXABLVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QciWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtpti5kLDglUTJo9g6mBcQtvFyMnh4SAicTF
	jvXsELaYxIV769m6GLk4hASmM0q0HfvJDOH8ZZRovrqGDaSKTUBD4vD7Z2AdIgKeEg9OHWAH
	KWIWWMAocfbWDLCEkEC1xKqeXYwgNqeAs0TvvsdANgeHsICvxIf5SSBhFgFViSmv9jCB2LwC
	lhIvT09lg7AFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxKUKEjvOvmaEuMFK4u++bcwQNSIS
	+168Y5zAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE8Ez
	6R2MqxosDjEKcDAq8fCuOLgrWIg1say4MvcQowQHs5II75dTu4OFeFMSK6tSi/Lji0pzUosP
	MZoCfTqRWUo0OR+YpPJK4g2NTcyMLI3MLIxMzM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBK
	NTCm7Ih3sQ01uv47e/Wf3pdzuNNbJ6d0/7yg2B6zjPfJIpsbuX4hPpN0xGu4GUx4XvwUMNw8
	vTVI54KT9H2f+X6/rq6r7FTk6RbbcyEy332y2WQXxce66hOZKk81aC7Sv8CnGXpZ/ozPxgOL
	bp9Olfv1fOdn9+seJkpzS77I/Mt59O/entJvpSpKLMUZiYZazEXFiQDOe8/0GgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Due to recently merged patches and previous merge conflicts, the Samsung
> PM Debug functionality no longer can be enabled. This patch fixes
> incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
> missing header inclusion.
> 
Yes, you're right and it should be fixed...but I have comments...

> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/plat-samsung/Kconfig    | 8 +++++++-
>  arch/arm/plat-samsung/pm-debug.c | 1 +
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 301b892..483c959 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -412,9 +412,14 @@ config S5P_DEV_MFC
> 
>  comment "Power management"
> 
> +config HAVE_SAMSUNG_PM_DEBUG
> +	bool
> +	help
> +	  Allow compilation of Samsung PM debugging code.
> +
>  config SAMSUNG_PM_DEBUG
>  	bool "S3C2410 PM Suspend debug"
> -	depends on PM && DEBUG_KERNEL && DEBUG_S3C_UART
> +	depends on PM && DEBUG_KERNEL && HAVE_SAMSUNG_PM_DEBUG
>  	help
>  	  Say Y here if you want verbose debugging from the PM Suspend and
>  	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
> @@ -484,6 +489,7 @@ config S5P_SLEEP
> 
>  config DEBUG_S3C_UART
>  	depends on PLAT_SAMSUNG
> +	select HAVE_SAMSUNG_PM_DEBUG

Hmm...

The DEBUG_S3C_UART will be '0' when we select DEBUG_S3C_UART0, then the
HAVE_SAMSUNG_PM_DEBUG will not be selected so SAMSUNG_PM_DEBUG is also...

>  	int
>  	default "0" if DEBUG_S3C_UART0
>  	default "1" if DEBUG_S3C_UART1
> diff --git a/arch/arm/plat-samsung/pm-debug.c b/arch/arm/plat-samsung/pm-debug.c
> index 8f19f66..3960960 100644
> --- a/arch/arm/plat-samsung/pm-debug.c
> +++ b/arch/arm/plat-samsung/pm-debug.c
> @@ -14,6 +14,7 @@
>   */
> 
>  #include <linux/serial_core.h>
> +#include <linux/serial_s3c.h>

Yeah, this is required then we don't need inclusion <linux/serial_core.h> here.

>  #include <linux/io.h>
> 
>  #include <asm/mach/map.h>
> --
> 1.9.3

