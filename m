Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaAPITw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:19:52 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:58582 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAPITv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:19:51 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCHv2 1/2] ARM: dts: imx53: add another pingroup for NAND pads
Date: Thu, 16 Jan 2014 09:15:22 +0100
Message-Id: <1389860123-14874-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389860123-14874-1-git-send-email-LW@KARO-electronics.de>
References: <1389860123-14874-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 arch/arm/boot/dts/imx53-pingrp.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-pingrp.h b/arch/arm/boot/dts/imx53-pingrp.h
index ac8e73d..f8d7d9c 100644
--- a/arch/arm/boot/dts/imx53-pingrp.h
+++ b/arch/arm/boot/dts/imx53-pingrp.h
@@ -300,6 +300,23 @@
 	MX53_PAD_PATA_DATA6__EMI_NANDF_D_6		0xa4 \
 	MX53_PAD_PATA_DATA7__EMI_NANDF_D_7		0xa4
 
+#define MX53_NAND_PINGRP2 \
+	MX53_PAD_NANDF_WE_B__EMI_NANDF_WE_B		0x4 \
+	MX53_PAD_NANDF_RE_B__EMI_NANDF_RE_B		0x4 \
+	MX53_PAD_NANDF_CLE__EMI_NANDF_CLE		0x4 \
+	MX53_PAD_NANDF_ALE__EMI_NANDF_ALE		0x4 \
+	MX53_PAD_NANDF_WP_B__EMI_NANDF_WP_B		0xe0 \
+	MX53_PAD_NANDF_RB0__EMI_NANDF_RB_0		0xe0 \
+	MX53_PAD_NANDF_CS0__EMI_NANDF_CS_0		0x4 \
+	MX53_PAD_EIM_DA0__EMI_NAND_WEIM_DA_0		0xa4 \
+	MX53_PAD_EIM_DA1__EMI_NAND_WEIM_DA_1		0xa4 \
+	MX53_PAD_EIM_DA2__EMI_NAND_WEIM_DA_2		0xa4 \
+	MX53_PAD_EIM_DA3__EMI_NAND_WEIM_DA_3		0xa4 \
+	MX53_PAD_EIM_DA4__EMI_NAND_WEIM_DA_4		0xa4 \
+	MX53_PAD_EIM_DA5__EMI_NAND_WEIM_DA_5		0xa4 \
+	MX53_PAD_EIM_DA6__EMI_NAND_WEIM_DA_6		0xa4 \
+	MX53_PAD_EIM_DA7__EMI_NAND_WEIM_DA_7		0xa4
+
 #define MX53_OWIRE_PINGRP1 \
 	MX53_PAD_GPIO_18__OWIRE_LINE			0x80000000
 
-- 
1.7.2.5

