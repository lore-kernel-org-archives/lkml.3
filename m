Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206AbaGOTSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:18:18 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38030 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbaGOTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:18:15 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] alpha: checkpatch whitespace errors in misc.c
Date: Tue, 15 Jul 2014 15:18:06 -0400
Message-Id: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch runs cleanfile against this file in order to remove all
outstanding whitespace errors caught when I ran checkpatch on it.
---
 arch/alpha/boot/misc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 3ff9a95..3f86c3e 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -1,7 +1,7 @@
 /*
  * misc.c
- * 
- * This is a collection of several routines from gzip-1.0.3 
+ *
+ * This is a collection of several routines from gzip-1.0.3
  * adapted for Linux.
  *
  * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
@@ -10,7 +10,7 @@
  *
  * Nicolas Pitre <nico@visuaide.com>  1999/04/14 :
  *  For this code to run directly from Flash, all constant variables must
- *  be marked with 'const' and all other variables initialized at run-time 
+ *  be marked with 'const' and all other variables initialized at run-time
  *  only.  This way all non constant variables will end up in the bss segment,
  *  which should point to addresses in RAM and cleared to 0 on start.
  *  This allows for a much quicker boot time.
-- 
1.9.1

