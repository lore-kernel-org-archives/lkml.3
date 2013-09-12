Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3ILAjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:39:24 -0400
Received: from mail.nt1.in ([62.90.139.210]:41721 "EHLO mail.nt1.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab3ILAjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:39:22 -0400
Date: Thu, 12 Sep 2013 03:39:19 +0300
From: Regid Ichira <regid23@nt1.in>
To: "Steven \"Mr. Procrastinator\" Rostedt" <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] README: Alternative configuration commands does not mention
 make listnewconfig
Message-ID: <20130912003919.GG8821@nt1.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to the tip of linux.git,
                      VERSION = 3 PATCHLEVEL = 11 SUBLEVEL = 0
Signed-off-by: Regid Ichira <regid23@nt1.in>
---
 README | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README b/README
index a24ec89..f10c16f 100644
--- a/README
+++ b/README
@@ -228,6 +228,10 @@ CONFIGURING the kernel:
      "make localyesconfig" Similar to localmodconfig, except it will convert
                            all module options to built in (=y) options.
 
+     "make listnewconfig"  Based on the contents of your existing ./.config
+                        file, print all the new config symbols.  One at a
+                        line.
+
    You can find more information on using the Linux kernel config tools
    in Documentation/kbuild/kconfig.txt.
 
-- 
1.8.4.rc3
