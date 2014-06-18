Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaFRRjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:39:45 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:29295 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbaFRRjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:39:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0KAEfOoVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZkogQsXdYRgI4EaN4hGAc0/hWKIL2QdhC0EmkOTWINEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/1] fs/udf/file.c: use linux/uaccess.h
Date: Wed, 18 Jun 2014 19:38:24 +0200
Message-Id: <1403113104-7436-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/udf/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index d80738f..72b8dae 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -27,7 +27,7 @@
 
 #include "udfdecl.h"
 #include <linux/fs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/string.h> /* memset */
 #include <linux/capability.h>
-- 
1.8.4.5

