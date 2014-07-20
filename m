Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaGTAoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 20:44:12 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:34886 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaGTAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 20:44:10 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/1] Staging: comedi: 8255.c Missing a blank line fixed
Date: Sun, 20 Jul 2014 03:43:11 +0300
Message-Id: <1405816991-8749-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'Missing a blank line after declarations' issue fixed and also tested
by 'make M=...'. It seems that after 'unsigned long iobase' declaration
a blank line is desperately needed.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/8255.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 46113a3..e591441 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -94,6 +94,7 @@ I/O port base address can be found in the output of 'lspci -v'.
 
 struct subdev_8255_private {
 	unsigned long iobase;
+
 	int (*io)(int, int, int, unsigned long);
 };
 
-- 
1.9.1

