Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbaICPyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:54:07 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:45617 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaICPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:54:03 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] tty: doc: Fix typos in serial/tty
Date: Wed,  3 Sep 2014 17:53:48 +0200
Message-Id: <1409759628-25754-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in serial/tty

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 Documentation/serial/tty.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
index 540db41dfd5d..1e52d67d0abf 100644
--- a/Documentation/serial/tty.txt
+++ b/Documentation/serial/tty.txt
@@ -146,7 +146,7 @@ set_termios()		Notify the tty driver that the device's termios
 			driver function is responsible for modifying any
 			bits in the request it cannot fulfill to indicate
 			the actual modes being used. A device with no
-			hardware capability for change (eg a USB dongle or
+			hardware capability for change (e.g. a USB dongle or
 			virtual port) can provide NULL for this method.
 
 throttle()		Notify the tty driver that input buffers for the
@@ -258,7 +258,7 @@ put_char()	-	Stuff a single character onto the queue. The
 
 flush_chars()	-	Ask the kernel to write put_char queue
 
-write_room()	-	Return the number of characters tht can be stuffed
+write_room()	-	Return the number of characters that can be stuffed
 			into the port buffers without overflow (or less).
 			The ldisc is responsible for being intelligent
  			about multi-threading of write_room/write calls
-- 
2.0.0

