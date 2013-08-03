Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3HCVLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 17:11:52 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49796 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3HCVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 17:11:51 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dilinger@queued.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org,
        Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH] Staging: olpc_dcon: Already completed TODO entry removed
Date: Sat,  3 Aug 2013 23:11:39 +0200
Message-Id: <1375564299-9142-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TODO entry - drop global variables, use a proper olpc_dcon_priv
struct - is already finished. The driver has no global variables.
It uses the private structure 'dcon_priv'.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>

diff --git a/drivers/staging/olpc_dcon/TODO b/drivers/staging/olpc_dcon/TODO
index f378e84..886e46e 100644
--- a/drivers/staging/olpc_dcon/TODO
+++ b/drivers/staging/olpc_dcon/TODO
@@ -3,7 +3,6 @@ TODO:
 	  share more code
 	- allow simultaneous XO-1 and XO-1.5 support
 	- console event notifier support
-	- drop global variables, use a proper olpc_dcon_priv struct
 	- audit code for unnecessary code; old unsupported prototype
 	  workarounds, ancient variables (noaa?), etc
 	- verify sane i2c API usage, update to new stuff if necessary
-- 
1.7.9.5

