Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaGVOw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:52:58 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61574 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbaGVOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:52:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, dbaryshkov@gmail.com
Subject: [PATCH 5/5] ARM: multi_v7_defconfig: Enable ST's Power Reset driver
Date: Tue, 22 Jul 2014 15:52:32 +0100
Message-Id: <1406040752-25229-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5348364..1878e8d 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -221,6 +221,7 @@ CONFIG_CHARGER_TPS65090=y
 CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
 CONFIG_POWER_RESET_SUN6I=y
+CONFIG_POWER_RESET_ST=y
 CONFIG_SENSORS_LM90=y
 CONFIG_THERMAL=y
 CONFIG_ARMADA_THERMAL=y
-- 
1.8.3.2

