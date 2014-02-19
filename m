Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaBSWOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:14:04 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:42562 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaBSWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:14:03 -0500
From: stefan.seyfried@googlemail.com
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>
Subject: [PATCH] Makefile: fix syntax error in warning message
Date: Wed, 19 Feb 2014 23:13:39 +0100
Message-Id: <1392848019-24114-1-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife+kernel@b1-systems.com>

---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 893d6f0..eeaf3e7 100644
--- a/Makefile
+++ b/Makefile
@@ -606,7 +606,7 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
     $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
-	      -fstack-protector not supported by compiler))
+	      -fstack-protector not supported by compiler)
   endif
 else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
   stackp-flag := -fstack-protector-strong
-- 
1.8.5.2


Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
