Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3I0Wj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:39:58 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2409 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab3I0Wjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:39:51 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH v2 2/3] ARM: bcm281xx: Turn on Thermal and HWMON
 drivers.
Date: Fri, 27 Sep 2013 15:37:33 -0700
Message-ID: <1380321454-16216-3-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E58D7B70UO11863343-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the thermal and HWMON drivers for Broadcom bcm281xx SoCs.

Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
---
 arch/arm/configs/bcm_defconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 6e49310..1474661 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -83,7 +83,8 @@ CONFIG_SERIAL_8250_DW=y
 CONFIG_HW_RANDOM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
-# CONFIG_HWMON is not set
+CONFIG_THERMAL=y
+CONFIG_HWMON=y
 CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
-- 
1.7.9.5


