Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaFBCTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:19:55 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:46975 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaFBCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:19:53 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 1/3] staging: vt6655: update out-of-date function declaration
Date: Sun,  1 Jun 2014 22:19:31 -0400
Message-Id: <1401675573-27734-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function iwctl_siwscan() is defined in iwctl.c as:
int iwctl_siwscan(struct net_device *dev,
		  struct iw_request_info *info,
		  struct iw_point *wrq,
		  char *extra)
{
  ...

This patch updates iwctl.h so that the type of the 3rd parameter (*wqr) in the
function declaration matches the definition.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/iwctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
index 871bd7c..4ad5e48 100644
--- a/drivers/staging/vt6655/iwctl.h
+++ b/drivers/staging/vt6655/iwctl.h
@@ -168,7 +168,7 @@ int iwctl_giwscan(struct net_device *dev,
 
 int iwctl_siwscan(struct net_device *dev,
 		  struct iw_request_info *info,
-		  struct iw_param *wrq,
+		  struct iw_point *wrq,
 		  char *extra);
 
 //2008-0409-07, <Add> by Einsn Liu
-- 
1.7.9.5

