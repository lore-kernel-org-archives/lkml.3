Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3GDMgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:36:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51975 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab3GDMgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:36:02 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <joe@perches.com>, <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2 4/5] staging: ozwpan: Convert macro to function.
Date: Thu, 4 Jul 2013 13:35:30 +0100
Message-ID: <1372941331-9586-5-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372255013.2076.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozurbparanoia.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozurbparanoia.h b/drivers/staging/ozwpan/ozurbparanoia.h
index 00f5a3a..5080ea7 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.h
+++ b/drivers/staging/ozwpan/ozurbparanoia.h
@@ -10,8 +10,8 @@
 void oz_remember_urb(struct urb *urb);
 int oz_forget_urb(struct urb *urb);
 #else
-#define oz_remember_urb(__x)
-#define oz_forget_urb(__x)	0
+static inline void oz_remember_urb(struct urb *urb) {}
+static inline int oz_forget_urb(struct urb *urb) { return 0; }
 #endif /* WANT_URB_PARANOIA */
 
 
-- 
1.7.9.5

