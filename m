Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3JWLXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:23:02 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:43325 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3JWLXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:23:00 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: peter@hurleysoftware.com, gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, jhovold@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] tty: Add C_MSPAR(tty)
Date: Wed, 23 Oct 2013 13:18:21 +0200
Message-Id: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing C_MSPAR(tty) macro.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/tty.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 64f8646..630678d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -137,6 +137,7 @@ struct tty_bufhead {
 #define C_CLOCAL(tty)	_C_FLAG((tty), CLOCAL)
 #define C_CIBAUD(tty)	_C_FLAG((tty), CIBAUD)
 #define C_CRTSCTS(tty)	_C_FLAG((tty), CRTSCTS)
+#define C_MSPAR(tty)	_C_FLAG((tty), CMSPAR)
 
 #define L_ISIG(tty)	_L_FLAG((tty), ISIG)
 #define L_ICANON(tty)	_L_FLAG((tty), ICANON)
-- 
1.8.4.rc3

