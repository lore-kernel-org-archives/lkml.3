Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3EPUDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:03:13 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50438 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3EPUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:03:12 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, rob@landley.net
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] hdio.txt: fix typos
Date: Thu, 16 May 2013 23:02:40 +0300
Message-Id: <1368734560-6765-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example code contained incorrect ioctl call name.

Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 Documentation/ioctl/hdio.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index 18eb98c..69e4ed3 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -453,7 +453,7 @@ HDIO_GET_BUSSTATE		get the bus state of the hwif
 	usage:
 
 	  long state;
-	  ioctl(fd, HDIO_SCAN_HWIF, &state);
+	  ioctl(fd, HDIO_GET_BUSSTATE, &state);
 
 	inputs:		none
 
@@ -473,7 +473,7 @@ HDIO_SET_BUSSTATE		set the bus state of the hwif
 
 	  int state;
 	  ...
-	  ioctl(fd, HDIO_SCAN_HWIF, state);
+	  ioctl(fd, HDIO_SET_BUSSTATE, state);
 
 	inputs:
 	  Desired IDE power state.  One of BUSSTATE_OFF, BUSSTATE_ON,
-- 
1.7.12.4

