Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbaD3Oeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:34:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52331 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759212AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [RFC 13/16] kgr: add MAINTAINERS entry
Date: Wed, 30 Apr 2014 16:30:46 +0200
Message-Id: <1398868249-26169-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Matz <matz@suse.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea44a57f790e..1b2e692b398f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5182,6 +5182,15 @@ F:	include/linux/kdb.h
 F:	include/linux/kgdb.h
 F:	kernel/debug/
 
+KGRAFT
+M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Slaby <jslaby@suse.cz>
+M:	Michael Matz <matz@suse.de>
+M:	Vojtech Pavlik <vojtech@suse.cz>
+F:	include/linux/kgr.h
+F:	kernel/kgr.c
+F:	tools/kgraft/
+
 KMEMCHECK
 M:	Vegard Nossum <vegardno@ifi.uio.no>
 M:	Pekka Enberg <penberg@kernel.org>
-- 
1.9.2

