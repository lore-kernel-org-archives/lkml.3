Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFFJhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:37:23 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:44474 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbaFFJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:37:22 -0400
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/2] ARM: at91/sama5_defconfig: enable sound support
Date: Fri, 6 Jun 2014 17:37:06 +0800
Message-ID: <1402047426-4058-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1402047426-4058-1-git-send-email-voice.shen@atmel.com>
References: <1402047426-4058-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/configs/sama5_defconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index dc3881e..c8613f0 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -144,6 +144,11 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
 # CONFIG_BACKLIGHT_GENERIC is not set
 CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_SOUND=y
+CONFIG_SND=y
+CONFIG_SND_SOC=y
+CONFIG_SND_ATMEL_SOC=y
+CONFIG_SND_ATMEL_SOC_WM8904=y
 # CONFIG_HID_GENERIC is not set
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-- 
1.8.5.2

