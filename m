Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaBISwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:52:37 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62421 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBISsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:37 -0500
From: Richard Weinberger <richard@nod.at>
To: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org (open list:TENSILICA XTENSA...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 17/28] Remove USE_GENERIC_SMP_HELPERS
Date: Sun,  9 Feb 2014 19:47:55 +0100
Message-Id: <1391971686-9517-18-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/xtensa/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ba56e11..c1d69ba 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -135,7 +135,6 @@ config HAVE_SMP
 config SMP
 	bool "Enable Symmetric multi-processing support"
 	depends on HAVE_SMP
-	select USE_GENERIC_SMP_HELPERS
 	select GENERIC_SMP_IDLE_THREAD
 	help
 	  Enabled SMP Software; allows more than one CPU/CORE
-- 
1.8.4.2

