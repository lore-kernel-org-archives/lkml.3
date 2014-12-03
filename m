Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaLCSfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:35:00 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42429 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:34:59 -0500
Date: Wed, 3 Dec 2014 19:34:42 +0100
From: Sam van Kampen <sam@tehsvk.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Bajumpaa <cbajumpa@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH] Staging: line6: fix parentheses around macro in usbdefs.h
Message-ID: <20141203183442.GA3480@nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the error "Macros with complex values should be enclosed in
parentheses", as reported by checkpatch.pl.

Signed-off-by: Sam van Kampen <sam@tehsvk.net>
---
 drivers/staging/line6/usbdefs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index 2d1cc47..48958b5 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -40,7 +40,7 @@
 #define LINE6_DEVID_TONEPORT_UX2  0x4142
 #define LINE6_DEVID_VARIAX        0x534d
 
-#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
+#define LINE6_BIT(x) (LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x)
 
 enum {
 	LINE6_INDEX_BASSPODXT,
-- 
2.0.4
