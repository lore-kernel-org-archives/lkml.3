Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbaGAObu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:31:50 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58289 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbaGAObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:31:47 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 2/3] ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
Date: Tue,  1 Jul 2014 15:30:46 +0100
Message-Id: <1404225047-9495-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/mach-sti/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index 878e9ec..8825bc9 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -42,4 +42,14 @@ config SOC_STIH416
 	  and other digital audio/video applications using Flattened Device
 	  Trees.
 
+config SOC_STIH407
+	bool "STiH407 STMicroelectronics Consumer Electronics family"
+	default y
+	select STIH407_RESET
+	help
+	  This enables support for STMicroelectronics Digital Consumer
+	  Electronics family StiH407 parts, targetted at set-top-box
+	  and other digital audio/video applications using Flattened Device
+	  Trees.
+
 endif
-- 
1.9.1

