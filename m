Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3KETzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:55:52 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4517 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab3KETzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:55:44 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        "Kumar Gala" <galak@codeaurora.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Tim Kryger" <tim.kryger@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH V2 2/3] ARM: configs:enable thermal framework for
 bcm281xx
Date: Tue, 5 Nov 2013 11:54:43 -0800
Message-ID: <1383681284-17643-3-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
References: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E6792AC1505061213-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the thermal framework and hwmon interface for Broadcom
bcm281xx SoCs.

Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Acked-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/configs/bcm_defconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index efb0132..a600b61 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -84,7 +84,9 @@ CONFIG_SERIAL_8250_DW=y
 CONFIG_HW_RANDOM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
-# CONFIG_HWMON is not set
+CONFIG_THERMAL=y
+CONFIG_THERMAL_OF=y
+CONFIG_HWMON=y
 CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
-- 
1.7.9.5


