Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAXMuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:50:12 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:59458 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaAXMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 04/15] ARM: shmobile: genmai defconfig: Enable RSPI
Date: Fri, 24 Jan 2014 13:49:40 +0100
Message-Id: <1390567791-8988-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - No changes

 arch/arm/configs/genmai_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/genmai_defconfig b/arch/arm/configs/genmai_defconfig
index ede35f400df2..401285305251 100644
--- a/arch/arm/configs/genmai_defconfig
+++ b/arch/arm/configs/genmai_defconfig
@@ -79,6 +79,8 @@ CONFIG_SERIAL_SH_SCI_NR_UARTS=10
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_I2C_SH_MOBILE=y
+CONFIG_SPI=y
+CONFIG_SPI_RSPI=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
 CONFIG_RCAR_THERMAL=y
-- 
1.7.9.5

