Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3APJHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:07:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60224 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab3APJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:07:16 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH V5 2/3] ARM: davinci: da8xx defconfig: enable pinctrl config option
Date: Wed, 16 Jan 2013 14:37:40 +0530
Message-ID: <1358327261-9679-3-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358327261-9679-1-git-send-email-anilkumar.v@ti.com>
References: <1358327261-9679-1-git-send-email-anilkumar.v@ti.com>
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

