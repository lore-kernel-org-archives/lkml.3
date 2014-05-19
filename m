Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaESQqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:46:23 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:35040 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaESQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:43:42 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] clk: berlin: add binding include for Berlin SoC clock ids
Date: Mon, 19 May 2014 18:43:23 +0200
Message-Id: <1400517811-24668-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a dt-binding include for Marvell Berlin BG2/BG2CD and BG2Q
core clock IDs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Changelog:
v1->v2:
- separate patch to allow to use it in the driver (Suggested by Alexandre
  Belloni)

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 include/dt-bindings/clock/berlin2.h  | 45 ++++++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/berlin2q.h | 31 +++++++++++++++++++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 include/dt-bindings/clock/berlin2.h
 create mode 100644 include/dt-bindings/clock/berlin2q.h

diff --git a/include/dt-bindings/clock/berlin2.h b/include/dt-bindings/clock/berlin2.h
new file mode 100644
index 000000000000..0c30800175df
--- /dev/null
+++ b/include/dt-bindings/clock/berlin2.h
@@ -0,0 +1,45 @@
+/*
+ * Berlin2 BG2/BG2CD clock tree IDs
+ */
+
+#define CLKID_SYS		0
+#define CLKID_CPU		1
+#define CLKID_DRMFIGO		2
+#define CLKID_CFG		3
+#define CLKID_GFX		4
+#define CLKID_ZSP		5
+#define CLKID_PERIF		6
+#define CLKID_PCUBE		7
+#define CLKID_VSCOPE		8
+#define CLKID_NFC_ECC		9
+#define CLKID_VPP		10
+#define CLKID_APP		11
+#define CLKID_AUDIO0		12
+#define CLKID_AUDIO2		13
+#define CLKID_AUDIO3		14
+#define CLKID_AUDIO1		15
+#define CLKID_GFX3D_CORE	16
+#define CLKID_GFX3D_SYS		17
+#define CLKID_ARC		18
+#define CLKID_VIP		19
+#define CLKID_SDIO0XIN		20
+#define CLKID_SDIO1XIN		21
+#define CLKID_GFX3D_EXTRA	22
+#define CLKID_GC360		23
+#define CLKID_SDIO_DLLMST	24
+#define CLKID_GETH0		25
+#define CLKID_GETH1		26
+#define CLKID_SATA		27
+#define CLKID_AHBAPB		28
+#define CLKID_USB0		29
+#define CLKID_USB1		30
+#define CLKID_PBRIDGE		31
+#define CLKID_SDIO0		32
+#define CLKID_SDIO1		33
+#define CLKID_NFC		34
+#define CLKID_SMEMC		35
+#define CLKID_AUDIOHD		36
+#define CLKID_VIDEO0		37
+#define CLKID_VIDEO1		38
+#define CLKID_VIDEO2		39
+#define CLKID_TWD		40
diff --git a/include/dt-bindings/clock/berlin2q.h b/include/dt-bindings/clock/berlin2q.h
new file mode 100644
index 000000000000..287fc3b4afb2
--- /dev/null
+++ b/include/dt-bindings/clock/berlin2q.h
@@ -0,0 +1,31 @@
+/*
+ * Berlin2 BG2Q clock tree IDs
+ */
+
+#define CLKID_SYS		0
+#define CLKID_DRMFIGO		1
+#define CLKID_CFG		2
+#define CLKID_GFX2D		3
+#define CLKID_ZSP		4
+#define CLKID_PERIF		5
+#define CLKID_PCUBE		6
+#define CLKID_VSCOPE		7
+#define CLKID_NFC_ECC		8
+#define CLKID_VPP		9
+#define CLKID_APP		10
+#define CLKID_SDIO0XIN		11
+#define CLKID_SDIO1XIN		12
+#define CLKID_GFX2DAXI		13
+#define CLKID_GETH0		14
+#define CLKID_SATA		15
+#define CLKID_AHBAPB		16
+#define CLKID_USB0		17
+#define CLKID_USB1		18
+#define CLKID_USB2		19
+#define CLKID_USB3		20
+#define CLKID_PBRIDGE		21
+#define CLKID_SDIO		22
+#define CLKID_NFC		23
+#define CLKID_SMEMC		24
+#define CLKID_PCIE		25
+#define CLKID_TWD		26
-- 
1.9.1

