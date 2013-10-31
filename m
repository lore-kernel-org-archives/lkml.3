Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3JaNkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:40:05 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:55110 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3JaNkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:40:02 -0400
From: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH] serial: omap: fix missing comma
Date: Thu, 31 Oct 2013 09:39:58 -0400
Message-Id: <fa11da334af37a035497c235fa9f5f5cfe11adec.1383226313.git.philippe.proulx@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
---
 drivers/tty/serial/omap-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 97c07f6..fa511eb 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1723,7 +1723,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	if (!up->port.uartclk) {
 		up->port.uartclk = DEFAULT_CLK_SPEED;
 		dev_warn(&pdev->dev,
-			 "No clock speed specified: using default: %d\n"
+			 "No clock speed specified: using default: %d\n",
 			 DEFAULT_CLK_SPEED);
 	}
 
-- 
1.8.4.2

