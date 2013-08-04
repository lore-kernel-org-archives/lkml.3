Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3HDS6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:58:09 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49555 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3HDS6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:58:06 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dsd@laptop.org, jon.nettleton@gmail.com, m.chehab@samsung.com,
        akpm@linux-foundation.org, cesarb@cesarb.net, davem@davemloft.net,
        hans.verkuil@cisco.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH] Staging: olpc_dcon: updating MAINTAINERS
Date: Sun,  4 Aug 2013 20:57:43 +0200
Message-Id: <1375642664-7260-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon and Chris Ball are not longer at OLPC.
Daniel Drake is the new OLPC go-to guy. And I wanna
also be CC'd on DCON and other OLPC patches.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d83f70f..2076caa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7877,11 +7877,11 @@ S:	Maintained
 F:	drivers/staging/nvec/
 
 STAGING - OLPC SECONDARY DISPLAY CONTROLLER (DCON)
-M:	Andres Salomon <dilinger@queued.net>
-M:	Chris Ball <cjb@laptop.org>
+M:	Jens Frederich <jfrederich@gmail.com>
+M:	Daniel Drake <dsd@laptop.org>
 M:	Jon Nettleton <jon.nettleton@gmail.com>
 W:	http://wiki.laptop.org/go/DCON
-S:	Odd Fixes
+S:	Maintained
 F:	drivers/staging/olpc_dcon/
 
 STAGING - OZMO DEVICES USB OVER WIFI DRIVER
diff --git a/drivers/staging/olpc_dcon/TODO b/drivers/staging/olpc_dcon/TODO
index 886e46e..8853991 100644
--- a/drivers/staging/olpc_dcon/TODO
+++ b/drivers/staging/olpc_dcon/TODO
@@ -9,6 +9,5 @@ TODO:
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 copy:
-	Andres Salomon <dilinger@queued.net>
-	Chris Ball <cjb@laptop.org>
-	Jon Nettleton <jon.nettleton@gmail.com>
+	Daniel Drake <dsd@laptop.org>
+	Jens Frederich <jfrederich@gmail.com>
-- 
1.7.9.5

