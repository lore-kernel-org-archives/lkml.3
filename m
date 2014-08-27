Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbaH0OZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:25:19 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47629 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972AbaH0OZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:25:11 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        afaerber@suse.de, Nick Dyer <nick.dyer@itdev.co.uk>,
        Yufeng Shen <miletus@chromium.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 2/3] ARM: exynos_defconfig: Enable Atmel maXTouch support
Date: Wed, 27 Aug 2014 16:24:46 +0200
Message-Id: <1409149487-23582-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409149487-23582-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1409149487-23582-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Exynos based Chromebooks have an Atmel trackpad so enable
support for it by default will make easier for users.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/configs/exynos_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 676c744..3d1a435 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -60,6 +60,7 @@ CONFIG_KEYBOARD_CROS_EC=y
 # CONFIG_MOUSE_PS2 is not set
 CONFIG_MOUSE_CYAPA=y
 CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_ATMEL_MXT=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_SAMSUNG=y
 CONFIG_SERIAL_SAMSUNG_CONSOLE=y
-- 
2.0.1

