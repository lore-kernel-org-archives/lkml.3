Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbbAIPM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:12:58 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36902 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757951AbbAIPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:12:53 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org, peter.griffin@linaro.org
Subject: [PATCH 1/3] ARM: STi: Add STiH418 SoC support
Date: Fri,  9 Jan 2015 16:11:44 +0100
Message-Id: <1420816306-11305-2-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
References: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_05:2015-01-09,2015-01-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to STiH418 SoC.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 Documentation/arm/sti/stih418-overview.txt    | 20 ++++++++++++++++++++
 Documentation/devicetree/bindings/arm/sti.txt |  4 ++++
 arch/arm/mach-sti/board-dt.c                  |  1 +
 3 files changed, 25 insertions(+)
 create mode 100644 Documentation/arm/sti/stih418-overview.txt

diff --git a/Documentation/arm/sti/stih418-overview.txt b/Documentation/arm/sti/stih418-overview.txt
new file mode 100644
index 0000000..1cd8fc8
--- /dev/null
+++ b/Documentation/arm/sti/stih418-overview.txt
@@ -0,0 +1,20 @@
+			STiH418 Overview
+			================
+
+Introduction
+------------
+
+    The STiH418 is the new generation of SoC for UHDp60 set-top boxes
+    and server/connected client application for satellite, cable, terrestrial
+    and IP-STB markets.
+
+    Features
+    - ARM Cortex-A9 1.5 GHz quad core CPU (28nm)
+    - SATA2, USB 3.0, PCIe, Gbit Ethernet
+    - HEVC L5.1 Main 10
+    - VP9
+
+  Document Author
+  ---------------
+
+  Maxime Coquelin <maxime.coquelin@st.com>, (c) 2015 ST Microelectronics
diff --git a/Documentation/devicetree/bindings/arm/sti.txt b/Documentation/devicetree/bindings/arm/sti.txt
index 92f16c7..d70ec35 100644
--- a/Documentation/devicetree/bindings/arm/sti.txt
+++ b/Documentation/devicetree/bindings/arm/sti.txt
@@ -13,3 +13,7 @@ Boards with the ST STiH407 SoC shall have the following properties:
 Required root node property:
 compatible = "st,stih407";
 
+Boards with the ST STiH418 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih418";
+
diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 3cf6ef8..b067390 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -18,6 +18,7 @@ static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415",
 	"st,stih416",
 	"st,stih407",
+	"st,stih418",
 	NULL
 };
 
-- 
1.9.1

