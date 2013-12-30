Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3L3G2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 01:28:34 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52289 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3L3G2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 01:28:33 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] mfd: Cleanup mfd-mcp-sa11x0.h header
Date: Mon, 30 Dec 2013 11:54:56 +0530
Message-Id: <1388384696-24291-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a1fd844c6e62 ("ARM: sa1100: move platform_data definitions")
moved the file to the current location but forgot to remove the pointer
to its previous location. Clean it up. While at it also change the header
file protection macros appropriately.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 include/linux/platform_data/mfd-mcp-sa11x0.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/platform_data/mfd-mcp-sa11x0.h b/include/linux/platform_data/mfd-mcp-sa11x0.h
index 4b2860ae3828..747cd6baf711 100644
--- a/include/linux/platform_data/mfd-mcp-sa11x0.h
+++ b/include/linux/platform_data/mfd-mcp-sa11x0.h
@@ -1,14 +1,12 @@
 /*
- *  arch/arm/mach-sa1100/include/mach/mcp.h
- *
  *  Copyright (C) 2005 Russell King.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef __ASM_ARM_ARCH_MCP_H
-#define __ASM_ARM_ARCH_MCP_H
+#ifndef __MFD_MCP_SA11X0_H
+#define __MFD_MCP_SA11X0_H
 
 #include <linux/types.h>
 
-- 
1.7.9.5

