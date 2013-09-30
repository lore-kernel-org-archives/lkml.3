Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3I3MGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:06:37 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:50646 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3I3MGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:06:35 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: imx: Include linux/err.h
Date: Mon, 30 Sep 2013 14:04:51 +0200
Message-Id: <1380542691-24756-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IS_ERR() macro is defined in the linux/err.h header file, so include
it explicitly.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-imx/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpu.c b/arch/arm/mach-imx/cpu.c
index fae2c9a..ba3b498 100644
--- a/arch/arm/mach-imx/cpu.c
+++ b/arch/arm/mach-imx/cpu.c
@@ -1,4 +1,4 @@
-
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/of.h>
-- 
1.8.4

