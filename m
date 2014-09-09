Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaIIDe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:34:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13797 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaIIDeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:34:24 -0400
X-AuditID: cbfee68d-f79c46d000000b84-57-540e753dfc46
From: kgene@kernel.org
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Cc: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
References: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
In-reply-to: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
Subject: RE: [PATCH v6 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Tue, 09 Sep 2014 12:34:21 +0900
Message-id: <034a01cfcbde$f1a98270$d4fc8750$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGX7eExOkwl6lFPnEWft/4vWbJdkZxn4Zxg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zQ13bUr4Qg51PtS02zljPajHvs6zF
	2aY37BbvDz1jttj0+BqrxeVdc9gsPvceYbSYcX4fk8WZ05dYLU7+6WW02PjVw4Hb4861PWwe
	m5fUe9z+95jZY8vVdhaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgylj16hdjQZN8xZnL91ka
	GK9KdjFyckgImEh0rvrJBmGLSVy4tx7I5uIQEljGKLFn5ixmmKKXXyeyQiQWMUr8ar7ACOH8
	ZZSYv2ELUIaDgw2ofeoTaZAGYQEtiYVbmlhAbBEBK4nHM86yg9QzC3QzS0x70cgKkhAScJfY
	2X0TrIhTwENiyoMvzBDNGRL/LuwCi7MIqEq8bp7PCGLzClhIrHl0kRXCFpT4MfkeWA0z0LL1
	O48zQdjyEpvXvIW6WkFix9nXjBBHGEk8X3eYDaJGRGLfi3dgD0gITOSQmLNgIyvEMgGJb5MP
	sYA8IyEgK7HpANQcSYmDK26wTGCUnIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSiwz1ihNz
	i0vz0vWS83M3MUKSQO8OxtsHrA8xCnAwKvHwZgTzhQixJpYVV+YeYjQFumgis5Rocj4w1eSV
	xBsamxlZmJqYGhuZW5opifMqSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC48p7bxY9u
	ca+V1DeEGt2PkQwqiPm6PfiRp4bnqZytwao/PY9bhxv9XGy1WmDW9KJw8UM5t73mslbVbT0f
	LDvj8fM6m7VCbWkdp8wLdyk19Dj9EOnVN548pevZseqVxWV3JpRNPfcxaGl722MhtbXMFz7w
	3LtxZY6ktFBUsMVxbaYF0zQff7ZRYinOSDTUYi4qTgQA4CmFqf0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV3bUr4Qg6e31Cw2zljPajHvs6zF
	2aY37BbvDz1jttj0+BqrxeVdc9gsPvceYbSYcX4fk8WZ05dYLU7+6WW02PjVw4Hb4861PWwe
	m5fUe9z+95jZY8vVdhaPvi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYx5ix6tUvxoIm+Yozl++zNDBelexi5OSQEDCRePl1IiuELSZx4d56ti5GLg4hgUWM
	Er+aLzBCOH8ZJeZv2AJUxcHBBlQ19Yk0SIOwgJbEwi1NLCC2iICVxOMZZ9lB6pkFupklpr1o
	BJsqJOAusbP7JlgRp4CHxJQHX5ghmjMk/l3YBRZnEVCVeN08nxHE5hWwkFjz6CIrhC0o8WPy
	PbAaZqBl63ceZ4Kw5SU2r3nLDHG1gsSOs68ZIY4wkni+7jAbRI2IxL4X7xgnMArPQjJqFpJR
	s5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4BTzTGoH48oGi0OMAhyMSjy8
	GcF8IUKsiWXFlbmHGCU4mJVEeBligUK8KYmVValF+fFFpTmpxYcYTYE+ncgsJZqcD0x/eSXx
	hsYmZkaWRmYWRibm5krivAdarQOFBNITS1KzU1MLUotg+pg4OKUaGPfeCboUf3GV/rTVM1Ye
	NZr4rvuJ8PbQxz17RNpDNTr28r7zX6S3Pbzo1LoVBatrj5S1Ci5YtjEo9LOXx+Rtjn/ylm64
	sDrYdSLLPAmGfUlHzcNuZfmFXf0WGdwVlxckZnRnhY2oQNyX+8U1Okzb7ZfUz2atYlXP1pSo
	fPVZI86y6fi0TykzE5RYijMSDbWYi4oTAZJyWolHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
Hi,

> This patch series adds support for AFTR idle mode on boards with
> secure firmware enabled and allows EXYNOS cpuidle driver usage on
> Exynos4x12 SoCs.
> 
> It has been tested on Trats2 board (using Exynos4412 SoC with secure
> firmware enabled) on which AFTR mode reduces power consumption by ~12%

Nice.

> when EXYNOS cpuidle driver is enabled (in both cases the default
> exynos_defconfig config is used and CPU1-3 are offlined).
> 
> Currently Exynos4412 SoC support is limited to Trats2 board.
> 
> Depends on:
> - next-20140904 branch of linux-next kernel tree
> - "irqchip: Properly fetch the per cpu offset" patch
>   (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg716674.html)
> - [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
>   (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)
> 
OK this series looks good to me, I will take this series once above patches are
landed.

Thanks,
Kukjin

> Changes since v5:
> - rebased on top of next-20140904 +
>   "irqchip: Properly fetch the per cpu offset" patch
>   (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg716674.html)
>   [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
>   (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)
> - limit Exynos4412 SoC support to Trats2 board for now
> 
> Changes since v4:
> - rebased on top of next-20140804 +
>   [PATCH v5][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35262.html)
>   [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
> - call exynos_save_cp15() only on A9 type core (this is needed for the future
>   Exynos3250 SoC support)
> 
> Changes since v3:
> - rebased on top of next-20140804 +
>   [PATCH v4][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35192.html)
>   [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
> - (re-)added patch fixing S5P_CENTRAL_SEQ_OPTION register setup
> 
> Changes since v2:
> - rebased on top of next-20140708 +
>   [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html)
>   [with rejects fixed]
>   [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html)
>   [PATCH 0/2] Firmware-assisted suspend/resume of Exynos SoCs
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html)
>   [with rejects fixed in patch #2]
> - addressed review comments from Tomasz Figa and Daniel Lezcano
> 
> Changes since v1:
> - synced against next-20140602
> - added missing Acked-by-s
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> Bartlomiej Zolnierkiewicz (5):
>   ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
>   ARM: EXYNOS: add AFTR mode support to firmware do_idle method
>   ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
>   ARM: EXYNOS: PM: fix register setup for AFTR mode code
>   ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs
> 
>  arch/arm/include/asm/firmware.h |  2 +-
>  arch/arm/mach-exynos/common.h   |  5 ++++
>  arch/arm/mach-exynos/exynos.c   |  5 +++-
>  arch/arm/mach-exynos/firmware.c | 34 ++++++++++++++++-------
>  arch/arm/mach-exynos/pm.c       | 60 ++++++++++++++++++++++++-----------------
>  5 files changed, 71 insertions(+), 35 deletions(-)
> 
> --
> 1.8.2.3

