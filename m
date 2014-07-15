Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaGOREz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:04:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39822 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaGOREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:04:48 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 95/95] Staging: commedi: 8253.h: style issue fixed
Date: Tue, 15 Jul 2014 20:04:35 +0300
Message-Id: <1405443875-15807-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a revision to the file that previously had several style issues.
It's clean now.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/8253.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index 31d0fc9..d320027 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -282,6 +282,7 @@ static inline void i8254_mm_write(void __iomem *base_address,
  * OR'ed with:
  *   I8254_BCD, I8254_BINARY
  */
+
 static inline int i8254_set_mode(unsigned long base_address,
 				 unsigned int regshift,
 				 unsigned int counter_number, unsigned int mode)
-- 
1.7.10.4

