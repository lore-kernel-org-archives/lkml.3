Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaBIS4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:56:31 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62411 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBISs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:29 -0500
From: Richard Weinberger <richard@nod.at>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 06/28] Remove PICOXCELL_PC3X3
Date: Sun,  9 Feb 2014 19:47:44 +0100
Message-Id: <1391971686-9517-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 2f2b084..eab6056 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -253,7 +253,7 @@ config HW_RANDOM_NOMADIK
 
 config HW_RANDOM_PICOXCELL
 	tristate "Picochip picoXcell true random number generator support"
-	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
+	depends on HW_RANDOM && ARCH_PICOXCELL
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Picochip PC3x3 and later devices.
-- 
1.8.4.2

