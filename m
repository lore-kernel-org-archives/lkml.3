Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaKSI2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:28:06 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51810 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbaKSI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:27:36 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, alexandre.torgue@st.com
Subject: [PATCH 6/7] ARM: multi_v7_defconfig: Enable stih407 usb picophy
Date: Wed, 19 Nov 2014 08:27:11 +0000
Message-Id: <1416385632-5832-7-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org>
References: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the picoPHY usb phy which is used by
the usb2 and usb3 host controllers when controlling usb2/1.1
devices. It is found in stih407 family SoC's from STMicroelectronics.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index e13ab7e..ac7b536 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -427,6 +427,7 @@ CONFIG_OMAP_USB2=y
 CONFIG_TI_PIPE3=y
 CONFIG_PHY_MIPHY365X=y
 CONFIG_PHY_STIH41X_USB=y
+CONFIG_PHY_STIH407_USB=y
 CONFIG_PHY_SUN4I_USB=y
 CONFIG_EXT4_FS=y
 CONFIG_VFAT_FS=y
-- 
1.9.1

