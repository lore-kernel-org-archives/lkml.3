Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216Ab3E2NhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:37:25 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43025 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935174Ab3E2NgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:36:25 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 1/4] ARM: ux540: Add ccu8540-uib-v3 Device Tree Machine
Date: Wed, 29 May 2013 15:33:24 +0200
Message-Id: <1369834407-30762-2-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

This board includes the U8540 platform and specifies only the
ST-Ericsson UIB version 3.

---
 arch/arm/boot/dts/Makefile           |  1 +
 arch/arm/boot/dts/ccu8540-uib-v3.dts | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)
 create mode 100644 arch/arm/boot/dts/ccu8540-uib-v3.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 1995988..29cb5db 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -159,6 +159,7 @@ dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
 	hrefprev60.dtb \
 	hrefv60plus.dtb \
 	ccu8540.dtb \
+	ccu8540-uib-v3.dtb 	\
 	ccu9540.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 	r8a7740-armadillo800eva.dtb \
diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
new file mode 100644
index 0000000..4b4982e
--- /dev/null
+++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
@@ -0,0 +1,16 @@
+/*
+ * Copyright 2012 ST-Ericsson AB
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include "ccu8540.dts"
+
+/ {
+	model = "ST-Ericsson U8540 platform with device tree UIB v3";
+};
-- 
1.8.1.1

