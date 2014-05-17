Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311AbaEQRrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:47:18 -0400
Received: from v22013021537510585.yourvserver.net ([37.221.193.202]:39744 "EHLO
	finitebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964867AbaEQRrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:47:14 -0400
From: Marcus Farkas <marcus.farkas@finitebox.com>
To: gregkh@linuxfoundation.org
Cc: Marcus Farkas <marcus.farkas@finitebox.com>, linux-kernel@vger.kernel.org,
        larry.finger@lwfinger.net, florian.c.schilhabel@googlemail.com
Subject: [PATCH 1/3] staging: rtl8712: fix missing blank lines after declarations
Date: Sat, 17 May 2014 19:38:29 +0200
Message-Id: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following checkpatch warnings:

rtl8712/rtl871x_security.c
    - 275: WARNING: Missing a blank line after declarations
    - 768: WARNING: Missing a blank line after declarations
    - 801: WARNING: Missing a blank line after declarations

Signed-off-by: Marcus Farkas <marcus.farkas@finitebox.com>
---
 drivers/staging/rtl8712/rtl871x_security.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 5ffc489..b053a4d 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -272,6 +272,7 @@ static void secmicputuint32(u8 *p, u32 val)
 /* Convert from Us4Byte32 to Byte[] in a portable way */
 {
 	long i;
+
 	for (i = 0; i < 4; i++) {
 		*p++ = (u8) (val & 0xff);
 		val >>= 8;
@@ -765,6 +766,7 @@ static void xor_128(u8 *a, u8 *b, u8 *out)
 static void xor_32(u8 *a, u8 *b, u8 *out)
 {
 	sint i;
+
 	for (i = 0; i < 4; i++)
 		out[i] = a[i] ^ b[i];
 }
@@ -798,6 +800,7 @@ static void next_key(u8 *key, sint round)
 static void byte_sub(u8 *in, u8 *out)
 {
 	sint i;
+
 	for (i = 0; i < 16; i++)
 		out[i] = sbox(in[i]);
 }
-- 
1.9.2

