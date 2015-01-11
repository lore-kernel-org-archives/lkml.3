Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbbAKQdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:33:45 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44696 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbbAKQdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:33:44 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] jffs2: compr_rubin: Remove unused function
Date: Sun, 11 Jan 2015 17:36:48 +0100
Message-Id: <1420994209-20980-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function pulledbits() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/jffs2/compr_rubin.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/jffs2/compr_rubin.c b/fs/jffs2/compr_rubin.c
index 92e0644b..556de10 100644
--- a/fs/jffs2/compr_rubin.c
+++ b/fs/jffs2/compr_rubin.c
@@ -84,11 +84,6 @@ static inline int pullbit(struct pushpull *pp)
 	return bit;
 }
 
-static inline int pulledbits(struct pushpull *pp)
-{
-	return pp->ofs;
-}
-
 
 static void init_rubin(struct rubin_state *rs, int div, int *bits)
 {
-- 
1.7.10.4

