Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbbAZMQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:16:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38866 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbbAZMQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:16:07 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 7/7] ARM: omap2plus_defconfig: Enable EXTCON_GPIO_USB
Date: Mon, 26 Jan 2015 14:15:32 +0200
Message-ID: <1422274532-9488-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422274532-9488-1-git-send-email-rogerq@ti.com>
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is needed for USB cable type detection on dra7-evm,
dra72-evm and am57xx-beagle-x15.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/configs/omap2plus_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 667d9d5..7e10e58 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -326,6 +326,7 @@ CONFIG_DMADEVICES=y
 CONFIG_TI_EDMA=y
 CONFIG_DMA_OMAP=y
 CONFIG_EXTCON=y
+CONFIG_EXTCON_USB_GPIO=m
 CONFIG_EXTCON_PALMAS=y
 CONFIG_PWM=y
 CONFIG_PWM_TIECAP=y
-- 
2.1.0

