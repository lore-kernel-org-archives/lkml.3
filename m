Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3JZABu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 20:01:50 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4154 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3JZABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 20:01:46 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Tim Kryger" <tim.kryger@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH 2/3] ARM: configs:enable thermal framework for bcm281xx
Date: Fri, 25 Oct 2013 17:00:28 -0700
Message-ID: <1382745629-1123-3-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382745629-1123-1-git-send-email-wendy.ng@broadcom.com>
References: <1382745629-1123-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E75D9C01SC1674938-01-01
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


