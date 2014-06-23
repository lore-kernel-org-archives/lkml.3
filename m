Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaFWNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:34:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60772 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457AbaFWN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 12/21] kgr: add MAINTAINERS entry
Date: Mon, 23 Jun 2014 15:29:26 +0200
Message-Id: <1403530175-29217-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
References: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
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

