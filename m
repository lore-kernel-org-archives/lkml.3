Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbaJCXfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:35:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbaJCWDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 323/357] media: af9033: update IT9135 tuner inittabs
Date: Fri,  3 Oct 2014 14:31:49 -0700
Message-Id: <20141003212943.166696691@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bimow Chen <Bimow.Chen@ite.com.tw>

commit 0df6580c5fc115034de29aa52af5cf6bd83d37d8 upstream.

Update IT9135 BX tuner config 60 and 61 inittabs.

[crope@iki.fi: removed two reg writes from driver init itself]
Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
 drivers/media/dvb-frontends/af9033_priv.h |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -1418,7 +1418,7 @@ static const struct reg_val tuner_init_i
 	{ 0x800068, 0x0a },
 	{ 0x80006a, 0x03 },
 	{ 0x800070, 0x0a },
-	{ 0x800071, 0x05 },
+	{ 0x800071, 0x0a },
 	{ 0x800072, 0x02 },
 	{ 0x800075, 0x8c },
 	{ 0x800076, 0x8c },
@@ -1484,7 +1484,6 @@ static const struct reg_val tuner_init_i
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xbe },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xbe },
@@ -1510,7 +1509,6 @@ static const struct reg_val tuner_init_i
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xac },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x1e },
 	{ 0x800153, 0xbc },
 	{ 0x800178, 0x09 },
@@ -1522,9 +1520,10 @@ static const struct reg_val tuner_init_i
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xa0 },
 	{ 0x800190, 0x5a },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
@@ -1699,7 +1698,6 @@ static const struct reg_val tuner_init_i
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xc8 },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xc6 },
@@ -1725,7 +1723,6 @@ static const struct reg_val tuner_init_i
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xa8 },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x28 },
 	{ 0x800153, 0xcc },
 	{ 0x800178, 0x09 },
@@ -1737,9 +1734,10 @@ static const struct reg_val tuner_init_i
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xfb },
 	{ 0x800190, 0x5c },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },


