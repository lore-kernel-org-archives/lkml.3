Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3CTO0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:26:35 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52960 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab3CTO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:26:33 -0400
From: Alice Ferrazzi <alice.ferrazzi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>
Subject: [PATCH] Staging: media: solo6x10: v4l2-enc: Fixed C99 comment
Date: Wed, 20 Mar 2013 23:26:21 +0900
Message-Id: <1363789581-12782-1-git-send-email-alice.ferrazzi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed do not use C99 // comments.

Signed-off-by: Alice Ferrazzi <alice.ferrazzi@gmail.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 4977e86..8f4ec1b 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -466,7 +466,7 @@ static void write_bytes(u8 **out, unsigned *bits, const u8 *src, unsigned count)
 static void write_bits(u8 **out, unsigned *bits, u32 value, unsigned count)
 {
 
-	value <<= 32 - count; // shift to the right
+	value <<= 32 - count; /* shift to the right */
 
 	while (count--) {
 		**out <<= 1;
-- 
1.7.10.4

