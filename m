Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaE3Jj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:39:26 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42356 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbaE3JjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:39:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, ajitpal.singh@st.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Subject: [PATCH 6/6] ARM: multi_v7_defconfig: Configure in ST's Thermal Controller
Date: Fri, 30 May 2014 10:38:35 +0100
Message-Id: <1401442715-6350-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index d4e8a47..dcc4e3e 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -204,6 +204,8 @@ CONFIG_SENSORS_LM90=y
 CONFIG_THERMAL=y
 CONFIG_DOVE_THERMAL=y
 CONFIG_ARMADA_THERMAL=y
+CONFIG_ST_THERMAL_SYSCFG=y
+CONFIG_ST_THERMAL_MEMMAP=y
 CONFIG_WATCHDOG=y
 CONFIG_ORION_WATCHDOG=y
 CONFIG_MFD_AS3722=y
-- 
1.8.3.2

