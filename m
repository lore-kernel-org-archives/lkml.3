Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaKQNdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:33:47 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752080AbaKQNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:33:16 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, kishon@ti.com, p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, arnd@arndb.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: berlin: do not select RESET_CONTROLLER
Date: Mon, 17 Nov 2014 14:33:12 +0100
Message-Id: <1416231192-27056-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESET_CONTROLLER is meant to be user-selectable. To respect that,
do not select it automatically when using ARCH_BERLIN.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/mach-berlin/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index 5803f773a065..51582c73a53f 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -7,7 +7,6 @@ menuconfig ARCH_BERLIN
 	select DW_APB_ICTL
 	select DW_APB_TIMER_OF
 	select PINCTRL
-	select RESET_CONTROLLER
 
 if ARCH_BERLIN
 
-- 
2.1.0

