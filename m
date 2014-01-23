Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaAWJ3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:29:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33903 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAWJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:29:11 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ARM: davinci: defconfig: drop CONFIG_REGULATOR_DUMMY
Date: Thu, 23 Jan 2014 14:57:39 +0530
Message-Id: <1390469259-11483-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch drops CONFIG_REGULATOR_DUMMY as this obsolete.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/configs/da8xx_omapl_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index 1571bea..c78de86 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -89,7 +89,6 @@ CONFIG_PINCTRL_SINGLE=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_REGULATOR=y
-CONFIG_REGULATOR_DUMMY=y
 CONFIG_REGULATOR_TPS6507X=y
 CONFIG_FB=y
 CONFIG_FB_DA8XX=y
-- 
1.7.9.5

