Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbbAPQso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:48:44 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:50370 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbbAPQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:48:42 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: swarren@wwwdotorg.org, lee@kernel.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 3/4] ARM: bcm2835: Add header file for pinctrl constants
Date: Fri, 16 Jan 2015 16:48:16 +0000
Message-Id: <1421426897-27225-4-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
References: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K0:Xw8qPL28i56tAegpQNjF80vLhIwdAZmXlJt7o0LwwJvxv53FJhZ
 sIBsGBk/izHhJp7srX4FnSTbzaNHgNbP6YKTxNz5lmGekj1V4lm5hxfHsuycM4vE/uig8Sv
 5HFwjyO9chwGoFhbrldck4M4c1bZMg8av0/DnZfasP/moyw6/3uim9u9OO8oVLxPKHYAIor
 iMe4sun/WDxhoGJ3rxkSg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new header file defines pincontrol constants to use
from bcm2835 DTS files for pincontrol properties option.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 include/dt-bindings/pinctrl/bcm2835.h |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 include/dt-bindings/pinctrl/bcm2835.h

diff --git a/include/dt-bindings/pinctrl/bcm2835.h b/include/dt-bindings/pinctrl/bcm2835.h
new file mode 100644
index 0000000..6f0bc37
--- /dev/null
+++ b/include/dt-bindings/pinctrl/bcm2835.h
@@ -0,0 +1,27 @@
+/*
+ * Header providing constants for bcm2835 pinctrl bindings.
+ *
+ * Copyright (C) 2015 Stefan Wahren <stefan.wahren@i2se.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#ifndef __DT_BINDINGS_PINCTRL_BCM2835_H__
+#define __DT_BINDINGS_PINCTRL_BCM2835_H__
+
+/* brcm,function property */
+#define BCM2835_FSEL_GPIO_IN	0
+#define BCM2835_FSEL_GPIO_OUT	1
+#define BCM2835_FSEL_ALT5	2
+#define BCM2835_FSEL_ALT4	3
+#define BCM2835_FSEL_ALT0	4
+#define BCM2835_FSEL_ALT1	5
+#define BCM2835_FSEL_ALT2	6
+#define BCM2835_FSEL_ALT3	7
+
+#endif /* __DT_BINDINGS_PINCTRL_BCM2835_H__ */
-- 
1.7.9.5

