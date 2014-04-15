Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaDOIHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:07:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37918 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbaDOIHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:07:30 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: berlin: add the LIBGPIO as a dependency for the BG2Q
Date: Tue, 15 Apr 2014 10:07:24 +0200
Message-Id: <1397549245-3338-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BG2Q has GPIOs driven by the dwapb GPIO driver. Add the LIBGPIO as a
dependency to be able to support them.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/mach-berlin/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index 291f1cac6c3d..c31968712095 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -28,6 +28,7 @@ config MACH_BERLIN_BG2Q
 	select CPU_V7
 	select HAVE_ARM_TWD if SMP
 	select HAVE_SMP
+	select ARCH_REQUIRE_GPIOLIB
 
 endmenu
 
-- 
1.8.3.2

