Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaF3MAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:00:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52058 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/181] usb: qcserial: fix multiline comment coding style
Date: Mon, 30 Jun 2014 13:51:50 +0200
Message-Id: <4b54f77f70bc9eb5070b5e22775b40f615493742.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ce1b066136a30079c4e6e81e015ad9bc2180d46f upstream.

Use a consistent style for all multiline comments.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/qcserial.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 6c0a542e8ec1..e282155dd4a1 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -225,12 +225,14 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	/* default to enabling interface */
 	altsetting = 0;
 
-	/* Composite mode; don't bind to the QMI/net interface as that
+	/*
+	 * Composite mode; don't bind to the QMI/net interface as that
 	 * gets handled by other drivers.
 	 */
 
 	if (is_gobi1k) {
-		/* Gobi 1K USB layout:
+		/*
+		 * Gobi 1K USB layout:
 		 * 0: DM/DIAG (use libqcdm from ModemManager for communication)
 		 * 1: serial port (doesn't respond)
 		 * 2: AT-capable modem port
@@ -244,7 +246,8 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		else
 			altsetting = -1;
 	} else {
-		/* Gobi 2K+ USB layout:
+		/*
+		 * Gobi 2K+ USB layout:
 		 * 0: QMI/net
 		 * 1: DM/DIAG (use libqcdm from ModemManager for communication)
 		 * 2: AT-capable modem port
-- 
2.0.0

