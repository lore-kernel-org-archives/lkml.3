Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaKTPMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:12:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64890 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaKTPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:12:10 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-06-546e04c814e4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 0/4] ARM: EXYNOS: cpuidle: add AFTR mode support for Exynos3250
Date: Thu, 20 Nov 2014 16:11:45 +0100
Message-id: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO5JlrwQg97tTBYbZ6xntZj3Wdai
	d8FVNov+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+TxapdfxgduDx2zrrL7rFpVSeb
	x51re9g8Ni+p9+jbsorR4/MmuQC2KC6blNSczLLUIn27BK6M17uPsxZ846yY9/YZewNjF0cX
	IyeHhICJxMSF15ggbDGJC/fWs3UxcnEICUxnlHj47R0LhNPFJPHq3QKwKjYBK4mJ7asYQWwR
	AVeJOVcmMYIUMQssZJKY9fYJO0hCWMBfYv78XjYQm0VAVWLusUdAkzg4eAU8JB4tsYPYpijR
	/WwC2wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkPpmfQOxlUNFocYBTgYlXh4
	EyxyQ4RYE8uKK3MPMUpwMCuJ8C58DxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe+MmUEogPbEk
	NTs1tSC1CCbLxMEp1cDYI7aMU/rLrnruuIYr+p0Zz/s3d2dedlFawJypF553mWHKrv9Ldxx5
	0WMzTfRtYYbyxcvHtTRuL7/fGVfEsMv158klhXMLrwjzvDRbupV7sYgp65S+iUHlsxo+vndQ
	PWvxvemVaND//PDYUxvSS80fm1VtYPW6u0ttArOvqB5fQaXLwef+PJxKLMUZiYZazEXFiQDD
	e3HMIQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds support for AFTR idle mode on boards with
Exynos3250 SoC and allows EXYNOS cpuidle driver usage on these
boards.

It has been tested on Samsung Rinato board (Gear 2).

Depends on:
- for-next branch of linux-samsung.git kernel tree
  (or next-20141114 branch of linux-next kernel tree)
- [PATCH v5] ARM: EXYNOS: add Exynos3250 PMU support
  (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg39109.html)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (4):
  ARM: EXYNOS: fix CPU1 hotplug for AFTR mode on Exynos3250
  ARM: EXYNOS: add code for setting/clearing boot flag
  ARM: EXYNOS: cpuidle: add AFTR mode support for Exynos3250
  ARM: EXYNOS: cpuidle: allow driver usage on Exynos3250 SoC

 arch/arm/mach-exynos/common.h   |  6 ++++++
 arch/arm/mach-exynos/exynos.c   | 26 ++++++++++++++++++++++++++
 arch/arm/mach-exynos/firmware.c |  8 +++++++-
 arch/arm/mach-exynos/platsmp.c  | 19 +++++++++++++++++--
 arch/arm/mach-exynos/pm.c       | 12 +++++++++++-
 arch/arm/mach-exynos/regs-pmu.h |  2 ++
 arch/arm/mach-exynos/smc.h      |  9 +++++++++
 7 files changed, 78 insertions(+), 4 deletions(-)

-- 
1.8.2.3

