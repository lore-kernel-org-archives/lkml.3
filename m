Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbaGANzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:55:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59839 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaGANzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:55:04 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-ab-53b2bdb40c2f
Message-id: <53B2BD99.5080704@samsung.com>
Date: Tue, 01 Jul 2014 15:54:33 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 0/6] Various Samsung fixes for v3.16-rc3
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7pb9m4KNvizy8iid8FVNotNj6+x
	WlzeNYfNYsb5fUwWa4/cZbdYtesPowObx85Zd9k9Ni+p9+jbsorR4/MmuQCWKC6blNSczLLU
	In27BK6Mjq4j7AX3uCqmnHzP3sB4kqOLkZNDQsBEYmvPRjYIW0ziwr31QDYXh5DAUkaJE6tO
	sEI4nxklHk6dx9zFyMHBK6AlsfFYMUgDi4CqxNHJTxhBbDYBNYnPDY/ABvEDlaxpus4CUi4q
	ECHx+IIQSJhXQFDix+R7LCC2CFDr57YF7CA2s8AhRonvB2xAbGEBG4lNr+8xgdhCAk4S/082
	gdmcAs4SO9u3sULU60jsb53GBmHLS2xe85Z5AqPgLCQrZiEpm4WkbAEj8ypG0dTS5ILipPRc
	I73ixNzi0rx0veT83E2MkCD/uoNx6TGrQ4wCHIxKPLwv9DcFC7EmlhVX5gIdycGsJMKbvAso
	xJuSWFmVWpQfX1Sak1p8iJGJg1OqgdHkLaODotRWdS/XlOKgtXE3udy+bcg78u5CwAfuY01y
	xjM27DwybWZlc1z6ycvNWl0/Lf7Ebgk6XG5f5bn586xr1zsm17maCG36E6MauaBlUtl657s8
	BTEPliYeMpmesXlb9IUCsZ5Mgeh8prwHOsXPer0PenHkf0gRPOwouqifzy8+4dyp1UosxRmJ
	hlrMRcWJAI+Q4etQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24.06.2014 15:57, Tomasz Figa wrote:
> This series inteds to fix various issues spotted while testing v3.16-rc2.
> The patches should be reasonably independent from each other and so could be
> picked to respective trees. See descriptions of individual patches for more
> information.
> 
> Tested on Exynos4412-based Trats2 and Exynos4210-based Trats boards.
> 
> AFAIK there is no need to backport those fixes to stable.
> 
> Tomasz Figa (6):
>   mmc: sdhci-s3c: Fix local I/O clock gating
>   ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
>   clk: samsung: exynos4: Remove SRC_MASK_ISP gates
>   ARM: SAMSUNG: Restore Samsung PM Debug functionality
>   ARM: EXYNOS: Fix suspend/resume sequencies
>   ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250
> 
>  arch/arm/mach-exynos/exynos.c     |  6 ++----
>  arch/arm/mach-exynos/hotplug.c    | 10 ++++++----
>  arch/arm/mach-exynos/platsmp.c    | 34 +++++++++++++++++++---------------
>  arch/arm/mach-exynos/pm.c         | 20 ++++----------------
>  arch/arm/plat-samsung/Kconfig     |  8 +++++++-
>  arch/arm/plat-samsung/pm-debug.c  |  1 +
>  drivers/clk/samsung/clk-exynos4.c | 16 ++++------------
>  drivers/mmc/host/sdhci-s3c.c      | 17 ++++++++++-------
>  8 files changed, 53 insertions(+), 59 deletions(-)
> 

Gentle ping.

Best regards,
Tomasz
