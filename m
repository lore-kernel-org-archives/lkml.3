Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaKGESA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:18:00 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60581 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaKGER6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:17:58 -0500
From: Michael Marineau <michael.marineau@coreos.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Marineau <michael.marineau@coreos.com>,
        David Howells <dhowells@redhat.com>,
        James Solner <solner@alcatel-lucent.com>
Subject: [PATCH] Document correct module signature kernel parameter
Date: Thu,  6 Nov 2014 20:17:27 -0800
Message-Id: <1415333847-14543-1-git-send-email-michael.marineau@coreos.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter is module.sig_enforce, not enforcemodulesig. The latter
appears to be from before this functionality was merged into mainline.

Signed-off-by: Michael Marineau <michael.marineau@coreos.com>
---
 Documentation/module-signing.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index 09c2382..6e5262e 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -222,7 +222,7 @@ signature checking is all done within the kernel.
 NON-VALID SIGNATURES AND UNSIGNED MODULES
 =========================================
 
-If CONFIG_MODULE_SIG_FORCE is enabled or enforcemodulesig=1 is supplied on
+If CONFIG_MODULE_SIG_FORCE is enabled or module.sig_enforce=1 is supplied on
 the kernel command line, the kernel will only load validly signed modules
 for which it has a public key.   Otherwise, it will also load modules that are
 unsigned.   Any module for which the kernel has a key, but which proves to have
-- 
2.0.4

