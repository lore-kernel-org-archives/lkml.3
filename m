Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaEHKNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:13:49 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51173 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaEHKNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:13:48 -0400
From: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com,
        Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
Subject: [PATCH] staging: comedi: Fixes Coding Style Warning in file das08.h
Date: Thu,  8 May 2014 15:43:37 +0530
Message-Id: <1399544017-5906-1-git-send-email-sheetal.tigadoli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch fixes following Warnings, found using checkpatch.pl, in file das08.h

./scripts/checkpatch.pl --file --terse drivers/staging/comedi/drivers/das08.h
drivers/staging/comedi/drivers/das08.h:43: WARNING: line over 80 characters
total: 0 errors, 1 warnings, 50 lines checked

Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
---
 drivers/staging/comedi/drivers/das08.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das08.h b/drivers/staging/comedi/drivers/das08.h
index 46a314c..18cc170 100644
--- a/drivers/staging/comedi/drivers/das08.h
+++ b/drivers/staging/comedi/drivers/das08.h
@@ -40,7 +40,9 @@ struct das08_board_struct {
 };
 
 struct das08_private_struct {
-	unsigned int do_mux_bits;	/*  bits for do/mux register on boards without separate do register */
+	unsigned int do_mux_bits;	/*  bits for do/mux register on boards
+					 *  without separate do register
+					 */
 	const unsigned int *pg_gainlist;
 	unsigned int ao_readback[2];	/* assume 2 AO channels */
 };
-- 
1.7.9.5

