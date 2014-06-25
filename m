Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbaFYLJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41097 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755432AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -repost 12/21] kgr: add MAINTAINERS entry
Date: Wed, 25 Jun 2014 13:07:06 +0200
Message-Id: <1403694435-3180-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Vojtech Pavlik <vojtech@suse.cz>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3f2e171047b9..73733eb50bb3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5239,6 +5239,15 @@ F:	include/linux/kdb.h
 F:	include/linux/kgdb.h
 F:	kernel/debug/
 
+KGRAFT
+M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Slaby <jslaby@suse.cz>
+M:	Vojtech Pavlik <vojtech@suse.cz>
+F:	arch/x86/include/asm/kgraft.h
+F:	include/linux/kgraft.h
+F:	kernel/kgraft.c
+F:	samples/kgraft/
+
 KMEMCHECK
 M:	Vegard Nossum <vegardno@ifi.uio.no>
 M:	Pekka Enberg <penberg@kernel.org>
-- 
2.0.0

