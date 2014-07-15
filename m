Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbaGORFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:05:53 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47000 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbaGORCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:23 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 94/94] Staging: commedi: 8253.h: style issue fixed
Date: Tue, 15 Jul 2014 20:01:49 +0300
Message-Id: <1405443709-15288-94-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a revision to the file that previously had several style issues.
It's clean now.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
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

