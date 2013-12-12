Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LLNn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:43:29 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:51550 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3LLNn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:43:28 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] MAINTAINERS: add gpio subsystem git tree
Date: Thu, 12 Dec 2013 15:43:00 +0200
Message-Id: <6e8200a86fb95c814f3f7211477547baab2efa73.1386855780.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 13c15c8..6e0c4eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3767,6 +3767,7 @@ GPIO SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
 L:	linux-gpio@vger.kernel.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
 F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
-- 
1.8.5.1

