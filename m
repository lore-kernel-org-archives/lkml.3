Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161507Ab3DEMnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:43:09 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62196 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3DEMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:43:07 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org
Cc: speakup@braille.uwo.ca, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] staging: speakup: selection.c fix typo in comment
Date: Fri,  5 Apr 2013 15:42:26 +0300
Message-Id: <1365165746-12073-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace disallocated with deallocated

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/staging/speakup/selection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index 775af26..f0fb003 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -14,7 +14,7 @@
 unsigned short spk_xs, spk_ys, spk_xe, spk_ye; /* our region points */
 
 /* Variables for selection control. */
-/* must not be disallocated */
+/* must not be deallocated */
 struct vc_data *spk_sel_cons;
 /* cleared by clear_selection */
 static int sel_start = -1;
-- 
1.7.10.4

