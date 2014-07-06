Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaGFJGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:06:07 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:61522 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaGFJGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:06:03 -0400
Date: Sun, 6 Jul 2014 12:05:53 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, sachin.kamat@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH next-20140704]: staging/rtl8821ae/debug.c: sparse warning
 correction
Message-ID: <20140706090553.GB16760@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Sparse warning correction:

vers/staging/rtl8821ae/debug.c:80:23: warning: symbol 'proc_topdir' was
not declared. Should it be static?

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---
diff --git a/drivers/staging/rtl8821ae/debug.c b/drivers/staging/rtl8821ae/debug
index 8aefbf1..e4a19ba 100644
--- a/drivers/staging/rtl8821ae/debug.c
+++ b/drivers/staging/rtl8821ae/debug.c
@@ -77,7 +77,7 @@ void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
        /*Init Debug flag enable condition */
 }
 
-struct proc_dir_entry *proc_topdir;
+static struct proc_dir_entry *proc_topdir;
 static int rtl_proc_get_mac_0(struct seq_file *m, void *v)
 {
        struct ieee80211_hw *hw = m->private;
