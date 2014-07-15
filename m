Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbaGOTcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:32:39 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:8842 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932890AbaGOTch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:32:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokRAJaAxVNbsm9N/2dsb2JhbABZgw6BKaw8CwUBbpwAgRAXdYRgI4ECGDeILgMVAcMYDYcihXuHI4FJZB2ELQWQH4h5ggCOCYYcg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ubifs/io.c: kernel-doc warning fix
Date: Tue, 15 Jul 2014 21:33:51 +0200
Message-Id: <1405452831-10201-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/data/timer

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 2290d58..fb08b0c 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -431,7 +431,7 @@ void ubifs_prep_grp_node(struct ubifs_info *c, void *node, int len, int last)
 
 /**
  * wbuf_timer_callback - write-buffer timer callback function.
- * @data: timer data (write-buffer descriptor)
+ * @timer: timer data (write-buffer descriptor)
  *
  * This function is called when the write-buffer timer expires.
  */
-- 
1.8.4.5

