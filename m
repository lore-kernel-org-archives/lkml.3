Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbbAUL4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:56:41 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51665 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbAUL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:56:33 -0500
Date: Wed, 21 Jan 2015 13:56:06 -0900
From: Ahmad Hassan <ahmad.hassan612@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, vinc94@gmail.com, roberta.dobrescu@gmail.com,
        sachin.kamat@samsung.com, ebru.akagunduz@gmail.com,
        damm+renesas@opensource.se, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: emxx_udc: remove macro ERR
Message-ID: <00e55cbac49f87ee26b8e4c47aa2111582391ae8.1421880617.git.ahmad.hassan612@gmail.com>
References: <cover.1421880617.git.ahmad.hassan612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1421880617.git.ahmad.hassan612@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed ERR macro since it is not used anymore in the emxx_udc.c file.

Signed-off-by: Ahmad Hassan <ahmad.hassan612@gmail.com>
---
 drivers/staging/emxx_udc/emxx_udc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.h b/drivers/staging/emxx_udc/emxx_udc.h
index ee1b80d..0758cd5 100644
--- a/drivers/staging/emxx_udc/emxx_udc.h
+++ b/drivers/staging/emxx_udc/emxx_udc.h
@@ -644,6 +644,5 @@ typedef volatile union {
 } USB_REG_ACCESS;
 
 /*-------------------------------------------------------------------------*/
-#define ERR(stuff...)		printk(KERN_ERR "udc: " stuff)
 
 #endif  /* _LINUX_EMXX_H */
-- 
2.2.1

