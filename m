Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab3APDrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:47:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35843 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758401Ab3APDrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:47:43 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH V4 2/3] ARM: davinci: da8xx defconfig: enable pinctrl config option
Date: Wed, 16 Jan 2013 09:18:21 +0530
Message-ID: <1358308102-8169-3-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358308102-8169-1-git-send-email-anilkumar.v@ti.com>
References: <1358308102-8169-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl related config option in da8xx_omapl_defconfig

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 f292239... 0892db4... M	arch/arm/configs/da8xx_omapl_defconfig
 arch/arm/configs/da8xx_omapl_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index f292239..0892db4 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -81,6 +81,7 @@ CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_DAVINCI=y
+CONFIG_PINCTRL_SINGLE=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_REGULATOR=y
-- 
1.7.4.1

