Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab3HTNxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:53:40 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59582 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3HTNxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:53:39 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dsd@laptop.org, jon.nettleton@gmail.com, dilinger@queued.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH] Staging: olpc_dcon: Removed more completed TODO entries
Date: Tue, 20 Aug 2013 15:53:06 +0200
Message-Id: <1377006786-8460-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Console event notifier support: No one I've asked knows what this
all about.
2. Audit code for unnecessary code: This is done.
3. Verify sane i2cAPI usage: This is also done.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>

diff --git a/drivers/staging/olpc_dcon/TODO b/drivers/staging/olpc_dcon/TODO
index 8853991..61c2e65 100644
--- a/drivers/staging/olpc_dcon/TODO
+++ b/drivers/staging/olpc_dcon/TODO
@@ -2,10 +2,6 @@ TODO:
 	- see if vx855 gpio API can be made similar enough to cs5535 so we can
 	  share more code
 	- allow simultaneous XO-1 and XO-1.5 support
-	- console event notifier support
-	- audit code for unnecessary code; old unsupported prototype
-	  workarounds, ancient variables (noaa?), etc
-	- verify sane i2c API usage, update to new stuff if necessary
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 copy:
-- 
1.7.9.5

