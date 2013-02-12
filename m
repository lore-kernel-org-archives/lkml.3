Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275Ab3BLO4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:56:52 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:57186 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760749Ab3BLOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/10] cris/kgdb: Remove unused static int do_printk
Date: Tue, 12 Feb 2013 15:52:49 +0100
Message-Id: <1360680777-12622-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 0a42033..6b64567 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -676,8 +676,6 @@ hex (char ch)
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
 
-static int do_printk = 0;
-
 static char *
 mem2hex(char *buf, unsigned char *mem, int count)
 {
-- 
1.7.0.4

