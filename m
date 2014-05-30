Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbaE3QsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:48:15 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:18664 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbaE3QsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:48:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNAAu2iFNXQxV9/2dsb2JhbABZgwerRgaYGoEJF3SDAiOBGjeIRgHXBxeFVYgZZB2EKgSPRYo5ixuIEoM6O4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 1/1] fs/proc/consoles: replace seq_printf by seq_puts
Date: Fri, 30 May 2014 18:48:08 +0200
Message-Id: <1401468488-9106-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/proc/consoles.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
index 290ba85..cb47c7e 100644
--- a/fs/proc/consoles.c
+++ b/fs/proc/consoles.c
@@ -55,7 +55,7 @@ static int show_console_dev(struct seq_file *m, void *v)
 	if (dev)
 		seq_printf(m, " %4d:%d", MAJOR(dev), MINOR(dev));
 
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	return 0;
 }
-- 
1.8.4.5

