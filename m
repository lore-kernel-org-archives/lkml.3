Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbaEFJY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:24:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56028 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEFJYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:24:53 -0400
From: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
Subject: [PATCH] Fixing Coding style Warnings in file drivers/staging/comedi/drivers/das08.h
Date: Tue,  6 May 2014 14:54:33 +0530
Message-Id: <1399368273-1632-1-git-send-email-sheetal.tigadoli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch fixes coding style warnings such as 'lines exceeding 80 characters limit' & 
 'lines begining with space character', in file drivers/staging/comedi/drivers/das08.h

 This patch is sent to complete one of Eudyptula Challenges

Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
---
 drivers/staging/comedi/drivers/das08.h |   56 +++++++++++++++++---------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.h b/drivers/staging/comedi/drivers/das08.h
index 2a30d76..741b36b 100644
--- a/drivers/staging/comedi/drivers/das08.h
+++ b/drivers/staging/comedi/drivers/das08.h
@@ -1,25 +1,24 @@
 /*
-    das08.h
-
-    Header for das08.c and das08_cs.c
-
-    Copyright (C) 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-*/
+ *  das08.h
+ *
+ *  Header for das08.c and das08_cs.c
+ *
+ *  Copyright (C) 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #ifndef _DAS08_H
 #define _DAS08_H
@@ -50,7 +49,8 @@ struct das08_board_struct {
 };
 
 struct i8254_struct {
-	int channels;		/*  available channels. Some could be used internally. */
+	int channels;		/*  available channels. Some could be used
+				    internally. */
 	int logic2phys[3];	/*  to know which physical channel is. */
 	int mode[3];		/*  the index is the real counter. */
 	unsigned int iobase;
@@ -62,11 +62,15 @@ struct i8254_struct {
 #define I8254_CTRL 3
 
 struct das08_private_struct {
-	unsigned int do_mux_bits;	/*  bits for do/mux register on boards without separate do register */
-	unsigned int do_bits;	/*  bits for do register on boards with register dedicated to digital out only */
+	unsigned int do_mux_bits;	/*  bits for do/mux register on boards
+					    without separate do register */
+	unsigned int do_bits;		/*  bits for do register on boards
+					    with register dedicated to digital
+					    out only */
 	const unsigned int *pg_gainlist;
-	struct pci_dev *pdev;	/*  struct for pci-das08 */
-	unsigned int pci_iobase;	/*  additional base address for pci-das08 */
+	struct pci_dev *pdev;		/*  struct for pci-das08 */
+	unsigned int pci_iobase;	/*  additional base address for
+					    pci-das08 */
 	struct i8254_struct i8254;
 };
 
-- 
1.7.9.5

