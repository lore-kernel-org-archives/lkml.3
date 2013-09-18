Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3IRVfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:35:30 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48845 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3IRVf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:35:29 -0400
Date: Thu, 19 Sep 2013 03:05:18 +0530
From: Anoop Thomas Mathew <atm@profoundis.com>
To: akpm@linux-foundation.org
Cc: holt@sgi.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixed typo in word 'implementations' in reboot.h
Message-ID: <20130918213511.GA14297@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anoop Thomas Mathew <atm@profoundis.com>
---
 include/linux/reboot.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 8e00f9f..0ff569d 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -52,7 +52,7 @@ struct pt_regs;
 extern void machine_crash_shutdown(struct pt_regs *);
 
 /*
- * Architecture independent implemenations of sys_reboot commands.
+ * Architecture independent implementations of sys_reboot commands.
  */
 
 extern void kernel_restart_prepare(char *cmd);
-- 
1.7.9.5

