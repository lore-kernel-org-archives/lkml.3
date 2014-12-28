Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaL1GpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 01:45:07 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:46392 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaL1GpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 01:45:03 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] drivers/edac: Fix a typo in comments
Date: Sun, 28 Dec 2014 12:44:45 +0600
Message-Id: <1419749085-7128-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g98acd41.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 drivers/edac/mpc85xx_edac.c | 2 +-
 drivers/edac/mpc85xx_edac.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index ffb1a9a..1fa76a5 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -1,5 +1,5 @@
 /*
- * Freescale MPC85xx Memory Controller kenel module
+ * Freescale MPC85xx Memory Controller kernel module
  *
  * Parts Copyrighted (c) 2013 by Freescale Semiconductor, Inc.
  *
diff --git a/drivers/edac/mpc85xx_edac.h b/drivers/edac/mpc85xx_edac.h
index 8c62564..4498baf 100644
--- a/drivers/edac/mpc85xx_edac.h
+++ b/drivers/edac/mpc85xx_edac.h
@@ -1,5 +1,5 @@
 /*
- * Freescale MPC85xx Memory Controller kenel module
+ * Freescale MPC85xx Memory Controller kernel module
  * Author: Dave Jiang <djiang@mvista.com>
  *
  * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
-- 
2.2.1.202.g98acd41.dirty

