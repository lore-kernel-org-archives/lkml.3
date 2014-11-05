Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbaKER1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:27:44 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35080 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756213AbaKER05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:57 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 7/9] tty: Document defunct ASYNC_SPLIT_TERMIOS flag in uapi header
Date: Wed,  5 Nov 2014 12:26:30 -0500
Message-Id: <1415208392-16189-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last vestige of ASYNC_SPLIT_TERMIOS was removed by commit
'cris: Remove obsolete ASYNC_SPLIT_TERMIOS behavior'. Mark the flag
as defunct in the uapi header.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/uapi/linux/tty_flags.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
index 4e021e3..d2bc4ff 100644
--- a/include/uapi/linux/tty_flags.h
+++ b/include/uapi/linux/tty_flags.h
@@ -14,7 +14,7 @@
 				    * on the callout port */
 #define ASYNCB_FOURPORT		 1 /* Set OU1, OUT2 per AST Fourport settings */
 #define ASYNCB_SAK		 2 /* Secure Attention Key (Orange book) */
-#define ASYNCB_SPLIT_TERMIOS	 3 /* Separate termios for dialin/callout */
+#define ASYNCB_SPLIT_TERMIOS	 3 /* [x] Separate termios for dialin/callout */
 #define ASYNCB_SPD_HI		 4 /* Use 56000 instead of 38400 bps */
 #define ASYNCB_SPD_VHI		 5 /* Use 115200 instead of 38400 bps */
 #define ASYNCB_SKIP_TEST	 6 /* Skip UART test during autoconfiguration */
-- 
2.1.3

