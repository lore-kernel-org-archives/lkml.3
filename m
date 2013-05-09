Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3EIKkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:40:41 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47123 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3EIKkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:40:39 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Sam Creasey <sammy@sammy.net>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 18/21] m68k/sun3/: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:56 +0400
Message-Id: <1368095819-11011-7-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 arch/m68k/sun3/sun3dvma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/sun3/sun3dvma.c b/arch/m68k/sun3/sun3dvma.c
index ca0966c..cab5448 100644
--- a/arch/m68k/sun3/sun3dvma.c
+++ b/arch/m68k/sun3/sun3dvma.c
@@ -275,7 +275,7 @@ void dvma_init(void)
 
 }
 
-inline unsigned long dvma_map_align(unsigned long kaddr, int len, int align)
+unsigned long dvma_map_align(unsigned long kaddr, int len, int align)
 {
 
 	unsigned long baddr;
-- 
1.8.1.4

