Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaGNOgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:36:18 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65500 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbaGNOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:33:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 05/11] ARM: multi_v7_defconfig: Enable ST's PWM driver
Date: Mon, 14 Jul 2014 15:33:26 +0100
Message-Id: <1405348412-7352-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index be1a345..4b9c96e 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -366,6 +366,7 @@ CONFIG_AK8975=y
 CONFIG_PWM=y
 CONFIG_PWM_TEGRA=y
 CONFIG_PWM_VT8500=y
+CONFIG_PWM_STI=y
 CONFIG_OMAP_USB2=y
 CONFIG_PHY_SUN4I_USB=y
 CONFIG_EXT4_FS=y
-- 
1.8.3.2

