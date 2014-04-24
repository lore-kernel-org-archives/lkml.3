Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbaDXJb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:31:56 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64316 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbaDXJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:31:46 -0400
From: Leela Krishna Amudala <leela.krishna@linaro.org>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: daniel.lezcano@linaro.org, nicolas.pitre@linaro.org, kgene.kim@samsung.com,
        amit.kucheria@linaro.org
Subject: [PATCH 0/2] Add generic cpu power control functions for exynos
Date: Thu, 24 Apr 2014 15:01:57 +0530
Message-Id: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the generic cpu power control functions for
exynos based SoCs to power up/down and to know the status of the cpu.

Note: This series has been rebased on 3.15-rc1 and tested on 
Exynos based Origen(Cortex-A9) and Arndale-octa(Cortex A7,A15) boards.

Leela Krishna Amudala (2):
  ARM: EXYNOS: Add generic cpu power control functions for all exynos
    based SoCs
  ARM: EXYNOS: use generic exynos cpu power control functions

 arch/arm/mach-exynos/common.h   |    3 +++
 arch/arm/mach-exynos/platsmp.c  |    9 +++------
 arch/arm/mach-exynos/pm.c       |   36 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/regs-pmu.h |    6 ++++++
 4 files changed, 48 insertions(+), 6 deletions(-)

-- 
1.7.9.5

