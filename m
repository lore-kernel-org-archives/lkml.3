Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaGAVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:53:57 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:51061 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbaGAVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:49 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 44/50] mars: add new file include/linux/mars_light/mars_proc.h
Date: Tue,  1 Jul 2014 23:47:24 +0200
Message-Id: <1404251250-22992-45-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/mars_light/mars_proc.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 include/linux/mars_light/mars_proc.h

diff --git a/include/linux/mars_light/mars_proc.h b/include/linux/mars_light/mars_proc.h
new file mode 100644
index 0000000..cd76701
--- /dev/null
+++ b/include/linux/mars_light/mars_proc.h
@@ -0,0 +1,18 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef MARS_PROC_H
+#define MARS_PROC_H
+
+typedef char * (*xio_info_fn)(void);
+
+extern xio_info_fn xio_info;
+
+extern int min_free_kbytes;
+
+/***********************************************************************/
+
+/*  init */
+
+extern int init_xio_proc(void);
+extern void exit_xio_proc(void);
+
+#endif
-- 
2.0.0

