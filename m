Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3CSJwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:55 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16898 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3CSJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYCANk0SFFbdWObgWdsb2JhbABDh2a9PIFbFg4BARYmKIIlAQV5EFFXBhOIGLIxkCGPDgeDQAOWX4Efkm47
X-IPAS-Result: ArYCANk0SFFbdWObgWdsb2JhbABDh2a9PIFbFg4BARYmKIIlAQV5EFFXBhOIGLIxkCGPDgeDQAOWX4Efkm47
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18789998"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 9/9] staging/sb105x: add TODO file
Date: Tue, 19 Mar 2013 10:51:30 +0100
Message-Id: <1363686690-27090-10-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/TODO |    6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 drivers/staging/sb105x/TODO

diff --git a/drivers/staging/sb105x/TODO b/drivers/staging/sb105x/TODO
new file mode 100644
index 0000000..518346f
--- /dev/null
+++ b/drivers/staging/sb105x/TODO
@@ -0,0 +1,6 @@
+TODO:
+        - checkpatch.pl cleanups
+	- Fix sparse issues
+	- Fix coding style issues
+	- Improve TTY support: tty_port
+	- Use struct uart_driver defined in <linux/serial_core.h>
-- 
1.7.10.4

