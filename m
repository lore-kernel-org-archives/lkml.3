Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3A1Nwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:52:47 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:33059 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757180Ab3A1Nwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:52:45 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, <arm@kernel.org>
Subject: [PATCH 5/5] ARM: ux500: select the DB8540 pin controller
Date: Mon, 28 Jan 2013 14:52:31 +0100
Message-ID: <1359381151-28127-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The pin controller is an inherent part of the SoC, without
it the system will not boot, thus it needs to be selected
from Kconfig.

Cc: arm@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Requesting ACK from ARM SoC on this patch.
---
 arch/arm/mach-ux500/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 5a12a7a..3e5bbd0 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -19,6 +19,7 @@ config UX500_SOC_DB8500
 	select CPU_FREQ_TABLE if CPU_FREQ
 	select MFD_DB8500_PRCMU
 	select PINCTRL_DB8500
+	select PINCTRL_DB8540
 	select PINCTRL_AB8500
 	select PINCTRL_AB8505
 	select PINCTRL_AB9540
-- 
1.7.11.3

