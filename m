Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3GTXIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:08:16 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61161 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3GTXHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:45 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] mfd: mcp: add missing linux/device.h header
Date: Sun, 21 Jul 2013 01:07:42 +0200
Message-Id: <1374361662-3094-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
linux/include/linux/mfd/mcp.h:22:16: error: field 'attached_device' has incomplete type
linux/include/linux/mfd/mcp.h:48:23: error: field 'drv' has incomplete type

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 include/linux/mfd/mcp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mfd/mcp.h b/include/linux/mfd/mcp.h
index a9e8bd1..f682953 100644
--- a/include/linux/mfd/mcp.h
+++ b/include/linux/mfd/mcp.h
@@ -10,6 +10,8 @@
 #ifndef MCP_H
 #define MCP_H
 
+#include <linux/device.h>
+
 struct mcp_ops;
 
 struct mcp {
-- 
1.8.1.5

