Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbaE3Qlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:41:45 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:41511 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbaE3Qlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:41:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNAPOziFNXQxV9/2dsb2JhbABZgwerRgaYGoEJF3SDAiOBGjeIRgHXCBeFVYgZZB2EKgSPRYo5ky2DOjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/1] fs/proc/vmcore.c: remove NULL assignment on static
Date: Fri, 30 May 2014 18:41:38 +0200
Message-Id: <1401468098-7727-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to NULL

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/proc/vmcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 6a8e785..382aa89 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -42,7 +42,7 @@ static size_t elfnotes_sz;
 /* Total size of vmcore file. */
 static u64 vmcore_size;
 
-static struct proc_dir_entry *proc_vmcore = NULL;
+static struct proc_dir_entry *proc_vmcore;
 
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
-- 
1.8.4.5

