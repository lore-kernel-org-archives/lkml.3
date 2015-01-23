Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbbAWNKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:10:13 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:39690 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbbAWNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:10:09 -0500
Date: Fri, 23 Jan 2015 15:09:08 +0200
From: Ahmad Hassan <ahmad.hassan612@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, vinc94@gmail.com, roberta.dobrescu@gmail.com,
        sachin.kamat@samsung.com, ebru.akagunduz@gmail.com,
        damm+renesas@opensource.se, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 v2] staging: emxx_udc: remove macro ERR
Message-ID: <20150123130908.GA30159@Arch-Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dath line at the end of file

Signed-off-by: Ahmad Hassan <ahmad.hassan612@gmail.com>
---
 drivers/staging/emxx_udc/emxx_udc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/emxx_udc/emxx_udc.h b/drivers/staging/emxx_udc/emxx_udc.h
index d984bd2..7929c65 100644
--- a/drivers/staging/emxx_udc/emxx_udc.h
+++ b/drivers/staging/emxx_udc/emxx_udc.h
@@ -644,3 +644,7 @@ typedef volatile union {
 } USB_REG_ACCESS;
 
 #endif  /* _LINUX_EMXX_H */
+
+
+04f287a
+00e55cb
\ No newline at end of file
-- 
2.2.1

