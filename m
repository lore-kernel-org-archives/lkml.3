Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3GTXIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:08:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63745 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3GTXHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:43 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] mfd: ucb1x00: explicitely include linux/device.h
Date: Sun, 21 Jul 2013 01:07:39 +0200
Message-Id: <1374361659-3064-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
linux/include/linux/mfd/ucb1x00.h:137:17: error: field 'dev' has incomplete type

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 include/linux/mfd/ucb1x00.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mfd/ucb1x00.h b/include/linux/mfd/ucb1x00.h
index 28af417..88f90cb 100644
--- a/include/linux/mfd/ucb1x00.h
+++ b/include/linux/mfd/ucb1x00.h
@@ -10,6 +10,7 @@
 #ifndef UCB1200_H
 #define UCB1200_H
 
+#include <linux/device.h>
 #include <linux/mfd/mcp.h>
 #include <linux/gpio.h>
 #include <linux/mutex.h>
-- 
1.8.1.5

