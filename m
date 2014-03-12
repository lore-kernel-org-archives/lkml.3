Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaCLJMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:12:18 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54849 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaCLJMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:12:15 -0400
X-Greylist: delayed 1068 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2014 05:12:15 EDT
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v4 1/6] ARM: STi: Add STiH407 SoC support
Date: Wed, 12 Mar 2014 09:50:05 +0100
Message-Id: <1394614210-15698-2-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_03:2014-03-11,2014-03-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to STiH407 SoC.

Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 Documentation/arm/sti/stih407-overview.txt    | 18 ++++++++++++++++++
 Documentation/devicetree/bindings/arm/sti.txt | 15 +++++++++++++++
 arch/arm/mach-sti/board-dt.c                  |  1 +
 3 files changed, 34 insertions(+)
 create mode 100644 Documentation/arm/sti/stih407-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/sti.txt

diff --git a/Documentation/arm/sti/stih407-overview.txt b/Documentation/arm/sti/stih407-overview.txt
new file mode 100644
index 0000000..3343f32
--- /dev/null
+++ b/Documentation/arm/sti/stih407-overview.txt
@@ -0,0 +1,18 @@
+			STiH407 Overview
+			================
+
+Introduction
+------------
+
+    The STiH407 is the new generation of SoC for Multi-HD, AVC set-top boxes
+    and server/connected client application for satellite, cable, terrestrial
+    and IP-STB markets.
+
+    Features
+    - ARM Cortex-A9 1.5 GHz dual core CPU (28nm)
+    - SATA2, USB 3.0, PCIe, Gbit Ethernet
+
+  Document Author
+  ---------------
+
+  Maxime Coquelin <maxime.coquelin@st.com>, (c) 2014 ST Microelectronics
diff --git a/Documentation/devicetree/bindings/arm/sti.txt b/Documentation/devicetree/bindings/arm/sti.txt
new file mode 100644
index 0000000..92f16c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/sti.txt
@@ -0,0 +1,15 @@
+ST STi Platforms Device Tree Bindings
+---------------------------------------
+
+Boards with the ST STiH415 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih415";
+
+Boards with the ST STiH416 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih416";
+
+Boards with the ST STiH407 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih407";
+
diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 1217fb5..df731f2 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -36,6 +36,7 @@ static void __init stih41x_machine_init(void)
 static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415",
 	"st,stih416",
+	"st,stih407",
 	NULL
 };
 
-- 
1.9.0

