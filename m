Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaJNQoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:44:55 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:11574 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbaJNQoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:44:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswNACZSPVRbtAZ+/2dsb2JhbABbgw6BK7h2BQFzkj+HV4EWFwF9hAoCUyOBCRE3iEIBt1WPR4YgiiUdhDUFkVGIdoMEjFyJNYFHAWyBRTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 1/1 linux-next] fs/jffs2/nodelist.h: remove unnecessary __constant_ prefix
Date: Tue, 14 Oct 2014 18:44:45 +0200
Message-Id: <1413305085-7318-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit fbdb8138cf0c
("checkpatch: warn on uses of __constant_<foo> functions")

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jffs2/nodelist.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/nodelist.h b/fs/jffs2/nodelist.h
index fa35ff7..9f0d547 100644
--- a/fs/jffs2/nodelist.h
+++ b/fs/jffs2/nodelist.h
@@ -48,8 +48,8 @@
 #define cpu_to_je32(x) ((jint32_t){cpu_to_be32(x)})
 #define cpu_to_jemode(x) ((jmode_t){cpu_to_be32(os_to_jffs2_mode(x))})
 
-#define constant_cpu_to_je16(x) ((jint16_t){__constant_cpu_to_be16(x)})
-#define constant_cpu_to_je32(x) ((jint32_t){__constant_cpu_to_be32(x)})
+#define constant_cpu_to_je16(x) ((jint16_t){cpu_to_be16(x)})
+#define constant_cpu_to_je32(x) ((jint32_t){cpu_to_be32(x)})
 
 #define je16_to_cpu(x) (be16_to_cpu(x.v16))
 #define je32_to_cpu(x) (be32_to_cpu(x.v32))
@@ -59,8 +59,8 @@
 #define cpu_to_je32(x) ((jint32_t){cpu_to_le32(x)})
 #define cpu_to_jemode(x) ((jmode_t){cpu_to_le32(os_to_jffs2_mode(x))})
 
-#define constant_cpu_to_je16(x) ((jint16_t){__constant_cpu_to_le16(x)})
-#define constant_cpu_to_je32(x) ((jint32_t){__constant_cpu_to_le32(x)})
+#define constant_cpu_to_je16(x) ((jint16_t){cpu_to_le16(x)})
+#define constant_cpu_to_je32(x) ((jint32_t){cpu_to_le32(x)})
 
 #define je16_to_cpu(x) (le16_to_cpu(x.v16))
 #define je32_to_cpu(x) (le32_to_cpu(x.v32))
-- 
1.9.3

