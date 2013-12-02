Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3LBOkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:40:04 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:48175 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3LBOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:39:59 -0500
X-Greylist: delayed 2302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 09:39:59 EST
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: trivial@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] trivial: fix typo in DEVTMPFS_MOUNT help text
Date: Mon,  2 Dec 2013 10:59:39 -0300
Message-Id: <1385992779-15544-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rootfs was missing its f.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/base/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index e373671..ec36e77 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -49,7 +49,7 @@ config DEVTMPFS_MOUNT
 	  with the commandline parameter: devtmpfs.mount=0|1.
 	  This option does not affect initramfs based booting, here
 	  the devtmpfs filesystem always needs to be mounted manually
-	  after the roots is mounted.
+	  after the rootfs is mounted.
 	  With this option enabled, it allows to bring up a system in
 	  rescue mode with init=/bin/sh, even when the /dev directory
 	  on the rootfs is completely empty.
-- 
1.8.4.2

