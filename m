Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3LRHpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:45:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:25605 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab3LRHpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:45:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="446157093"
Subject: tty: Removing the deprecated function tty_vhangup_locked()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, chao.bi@intel.com,
        jin.xiao@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Dec 2013 15:48:23 +0800
Message-ID: <1387352903.3650.62.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The function tty_vhangup_locked() was deprecated, removed it
from the tty.h also.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 include/linux/tty.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 97d660e..a98c85f 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -422,7 +422,6 @@ extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
-extern void tty_vhangup_locked(struct tty_struct *tty);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
-- 
1.7.9.5



