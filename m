Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaBFOnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:43:20 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10091 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaBFOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:16 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-1f-52f39f83c56a
Message-id: <52F39F80.1090709@samsung.com>
Date: Thu, 06 Feb 2014 15:43:12 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 5/9 v5] clk: samsung exynos5250/5420: Add gate clock for
 SSS module
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
 <1390987446-18784-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1390987446-18784-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7rN8z8HGZxqlLa4+/wwo8XLQ5oW
	84+cY7XofiVj0bvgKpvF/Xs/mSwu75rDZjHj/D4mi0Xb/jNbnJ1ziMmBy2PnrLvsHtsOqHr0
	bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXRmvXMqaCOxwVv6ZUNjD+Z+ti5OSQEDCRePHoHiOE
	LSZx4d56oDgXh5DAUkaJH2vPMkI4nxklNuzcDNbBK6AlcXXVFzCbRUBVouXfQmYQm01ATeJz
	wyOwuKhAhMTfeesZIeoFJX5MvscCYosIlEv8u7EGbAOzwFFGicu7D7GDJIQFIiUmPPsKta2R
	UWLZ5ENgHZwCbhLd55eCTWUWsJZYOWkbI4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVNL
	kwuKk9JzjfSKE3OLS/PS9ZLzczcxQsL+6w7GpcesDjEKcDAq8fBuWP8pSIg1say4MvcQowQH
	s5IIb2rT5yAh3pTEyqrUovz4otKc1OJDjEwcnFINjLcFdjmKlYbzeJtZidn9nPPx6xkTlbxE
	9ZIDrVv0q9yzVFQPrzNOuvktfFbRpksNHm77PTY4H516LPDvvR2BH+s+zOOYNUPt51vVb8Et
	fv6ntv9viSkKWn3rWdLGqr4LDu41vkt7Zy8y3VT4ZZlhd2DL3/vL0iNbXTmPGR/4Vsr0xXqy
	wucHwUosxRmJhlrMRcWJAG2i3zRZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 29.01.2014 10:24, Naveen Krishna Chatradhi wrote:
> This patch adds gating clock for SSS(Security SubSystem)
> module on Exynos5250/5420.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> TO: Tomasz Figa <t.figa@samsung.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v4:
> Use register GATE_IP_G2D instead of GATE_BUS_G2D for Exynos5420
> Changes since v3:
> 1. Rebased on to https://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git
> 2. Added new ID for SSS clock on Exynos5250, with Documentation and
> 3. Added gate clocks definitions for SSS on Exynos5420 and Exynos5250
>   .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
>   drivers/clk/samsung/clk-exynos5250.c               |    1 +
>   drivers/clk/samsung/clk-exynos5420.c               |    4 ++++
>   include/dt-bindings/clock/exynos5250.h             |    1 +
>   4 files changed, 7 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
