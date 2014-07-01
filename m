Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbaGAVrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:47:43 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:8125 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaGAVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:37 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/50] mars: add new file include/linux/brick/lamport.h
Date: Tue,  1 Jul 2014 23:46:41 +0200
Message-Id: <1404251250-22992-2-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/lamport.h | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 include/linux/brick/lamport.h

diff --git a/include/linux/brick/lamport.h b/include/linux/brick/lamport.h
new file mode 100644
index 0000000..f567eee
--- /dev/null
+++ b/include/linux/brick/lamport.h
@@ -0,0 +1,10 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef LAMPORT_H
+#define LAMPORT_H
+
+#include <linux/time.h>
+
+extern void get_lamport(struct timespec *now);
+extern void set_lamport(struct timespec *old);
+
+#endif
-- 
2.0.0

