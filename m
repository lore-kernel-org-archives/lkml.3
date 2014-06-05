Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaFEPH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:07:59 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:39043 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaFEPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:07:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, ajitpal.singh@st.com,
        edubezval@gmail.com, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com
Subject: [PATCH 6/6] ARM: multi_v7_defconfig: Configure in ST's Thermal Controller
Date: Thu,  5 Jun 2014 16:06:59 +0100
Message-Id: <1401980819-19962-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
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

