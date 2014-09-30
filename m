Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaI3IEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:04:11 -0400
Received: from www17.your-server.de ([213.133.104.17]:55080 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaI3IEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:04:07 -0400
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2014 04:04:07 EDT
Message-ID: <1412062926.2769.4.camel@localhost.localdomain>
Subject: [PATCH] x86, spinlock: Include threads.h
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 30 Sep 2014 09:42:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NR_CPUS is used, but not included. Fix this.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 54f1c80..db586f0 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -3,6 +3,7 @@
 
 #include <linux/jump_label.h>
 #include <linux/atomic.h>
+#include <linux/threads.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>

