Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3JRPPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:15:11 -0400
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:54642 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab3JRPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:15:09 -0400
X-Originating-IP: 109.242.145.197
From: Aldo Iljazi <me@aldo.io>
To: marek.belisko@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ft1000: fixed two coding style issues
Date: Fri, 18 Oct 2013 18:14:31 +0300
Message-Id: <1382109271-20180-1-git-send-email-me@aldo.io>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed two coding style issues, specifically:

ft1000_proc.c:35: ERROR: space required before the open parenthesis '('
ft1000_proc.c:42: ERROR: space required before the open parenthesis '('

Signed-off-by: Aldo Iljazi <me@aldo.io>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index b2330f1..88f6f9c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -32,14 +32,14 @@
 
 #define seq_putx(m, message, size, var) \
 	seq_printf(m, message);	\
-	for(i = 0; i < (size - 1); i++) { \
+	for (i = 0; i < (size - 1); i++) { \
 		seq_printf(m, "%02x:", var[i]); \
 	} \
 	seq_printf(m, "%02x\n", var[i])
 
 #define seq_putd(m, message, size, var) \
 	seq_printf(m, message); \
-	for(i = 0; i < (size - 1); i++) { \
+	for (i = 0; i < (size - 1); i++) { \
 		seq_printf(m, "%d.", var[i]); \
 	} \
 	seq_printf(m, "%d\n", var[i])
-- 
1.8.3.2

