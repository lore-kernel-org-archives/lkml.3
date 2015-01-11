Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbbAKRyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 12:54:07 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47742 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbbAKRyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 12:54:05 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] edac: i5100_edac: Remove unused function
Date: Sun, 11 Jan 2015 18:57:10 +0100
Message-Id: <1420999030-21770-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function i5100_recmema_dm_buf_id() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/edac/i5100_edac.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 6247d18..e9f8a39 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -279,11 +279,6 @@ static inline u32 i5100_recmema_rank(u32 a)
 	return i5100_nrecmema_rank(a);
 }
 
-static inline u32 i5100_recmema_dm_buf_id(u32 a)
-{
-	return i5100_nrecmema_dm_buf_id(a);
-}
-
 static inline u32 i5100_recmemb_cas(u32 a)
 {
 	return i5100_nrecmemb_cas(a);
-- 
1.7.10.4

