Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaBKQ0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:26:03 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52999 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBKQZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:25:49 -0500
From: Richard Genoud <richard.genoud@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] trivial: gpio: update path to documentation
Date: Tue, 11 Feb 2014 17:25:35 +0100
Message-Id: <1392135935-420-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 include/linux/gpio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index b581b13d29d9..85aa5d0b9357 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -3,7 +3,7 @@
 
 #include <linux/errno.h>
 
-/* see Documentation/gpio.txt */
+/* see Documentation/gpio/gpio-legacy.txt */
 
 /* make these flag values available regardless of GPIO kconfig options */
 #define GPIOF_DIR_OUT	(0 << 0)
-- 
1.8.5

