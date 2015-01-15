Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbbAODwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 22:52:50 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:62082 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAODws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 22:52:48 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Rorvick <chris@rorvick.com>
Subject: [PATCH] usb: Fix typo in `struct usb_host_interface' comment
Date: Wed, 14 Jan 2015 21:52:28 -0600
Message-Id: <1421293948-10901-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The descriptor member `bNumEndpoints' is plural.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 include/linux/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index f89c24a..4add566 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -82,7 +82,7 @@ struct usb_host_interface {
 	int extralen;
 	unsigned char *extra;   /* Extra descriptors */
 
-	/* array of desc.bNumEndpoint endpoints associated with this
+	/* array of desc.bNumEndpoints endpoints associated with this
 	 * interface setting.  these will be in no particular order.
 	 */
 	struct usb_host_endpoint *endpoint;
-- 
2.1.0

