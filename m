Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaFBCUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:20:09 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34341 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaFBCUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:20:06 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 2/3] staging: vt6655: update iwctl_private_args extern declaration
Date: Sun,  1 Jun 2014 22:19:32 -0400
Message-Id: <1401675573-27734-2-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401675573-27734-1-git-send-email-shack@linux.com>
References: <1401675573-27734-1-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update declaration of iwctl_private_args to match definition in iwctl.c

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/iwctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
index 4ad5e48..10564b4 100644
--- a/drivers/staging/vt6655/iwctl.h
+++ b/drivers/staging/vt6655/iwctl.h
@@ -211,6 +211,6 @@ int iwctl_siwmlme(struct net_device *dev,
 //End Add -- //2008-0409-07, <Add> by Einsn Liu
 
 extern const struct iw_handler_def	iwctl_handler_def;
-extern const struct iw_priv_args	iwctl_private_args;
+extern struct iw_priv_args       iwctl_private_args[];
 
 #endif // __IWCTL_H__
-- 
1.7.9.5

