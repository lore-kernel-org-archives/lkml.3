Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966251Ab3HHTYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:24:36 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1227 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966205Ab3HHTYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:24:35 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Christian Daudt" <csd@broadcom.com>
To: "Christian Daudt" <csd@broadcom.com>
cc: "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Olof Johansson" <olof@lixom.net>,
        "Markus Mayer" <markus.mayer@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: bcm: Rename board_bcm
Date: Thu, 8 Aug 2013 12:24:23 -0700
Message-ID: <1375989863-17144-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E1D300931W82353273-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support multiple SoC models in the mach-bcm
directory, board_bcm.c is being renamed board_bcm281xx.c

Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index 6adb6aec..873817e 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -10,6 +10,6 @@
 # of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 
-obj-$(CONFIG_ARCH_BCM)		:= board_bcm.o bcm_kona_smc.o bcm_kona_smc_asm.o
+obj-$(CONFIG_ARCH_BCM)		:= board_bcm281xx.o bcm_kona_smc.o bcm_kona_smc_asm.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm281xx.c
similarity index 100%
rename from arch/arm/mach-bcm/board_bcm.c
rename to arch/arm/mach-bcm/board_bcm281xx.c
-- 
1.7.10.4


