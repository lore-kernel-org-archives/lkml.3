Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaIKREt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:04:49 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:52331 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaIKRDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:03:07 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        b.zolnierkie@samsung.com, patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: [PATCH v3 3/4] MAINTAINERS: Add phy-stih407-usb.c file to ARCH/STI architecture
Date: Thu, 11 Sep 2014 18:02:46 +0100
Message-Id: <1410454967-21500-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
References: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new phy-stih407-usb.c usb phy driver found on
STMicroelectronics stih407 consumer electronics SoC's into the STI
arch section of the maintainers file.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf24bb5..3ccb4cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1398,6 +1398,7 @@ F:	drivers/media/rc/st_rc.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/tty/serial/st-asc.c
 F:	drivers/mmc/host/sdhci-st.c
+F:	drivers/phy/phy-stih407-usb.c
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-- 
1.9.1

