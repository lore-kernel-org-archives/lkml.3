Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaCCKK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:10:26 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:36657 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaCCKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:10:22 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com
Cc: plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v5 7/9] at91: updated the at91_dt_defconfig with support for the ADS7846
Date: Mon,  3 Mar 2014 11:06:00 +0100
Message-Id: <1393841162-25339-8-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides touchscreen support to the at91sam9261ek

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/configs/at91_dt_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index 3c6905d..aaa322d 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -120,6 +120,7 @@ CONFIG_INPUT_EVDEV=y
 CONFIG_KEYBOARD_GPIO=y
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_ADS7846=y
 # CONFIG_SERIO is not set
 CONFIG_LEGACY_PTY_COUNT=4
 CONFIG_SERIAL_ATMEL=y
-- 
1.9.0

