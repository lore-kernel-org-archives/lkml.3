Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3LPPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:43:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab3LPPnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:43:46 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 4/4] ARM: keystone_defconfig: enable LED support
Date: Mon, 16 Dec 2013 18:39:40 +0200
Message-ID: <1387211981-26045-5-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
References: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Keystone GPIO functionality is ready for use, so LED support can be
enabled in config.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/configs/keystone_defconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index e911f7f..fb1eb8a 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -161,3 +161,11 @@ CONFIG_CRYPTO_USER_API_SKCIPHER=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_DAVINCI=y
+CONFIG_LEDS_CLASS=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_ONESHOT=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_BACKLIGHT=y
+CONFIG_LEDS_TRIGGER_GPIO=y
-- 
1.7.9.5

