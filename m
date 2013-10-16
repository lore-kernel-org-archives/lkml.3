Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab3JPMby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:31:54 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:41677 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934269Ab3JPMbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/16] m68k: head.S - Correct date and spelling
Date: Wed, 16 Oct 2013 14:31:20 +0200
Message-Id: <1381926693-6392-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index fb348caa734e..8d14b0f9a36f 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -23,7 +23,7 @@
 ** 98/04/25 Phil Blundell: added HP300 support
 ** 1998/08/30 David Kilzer: Added support for font_desc structures
 **            for linux-2.1.115
-** 9/02/11  Richard Zidlicky: added Q40 support (initial vesion 99/01/01)
+** 1999/02/11  Richard Zidlicky: added Q40 support (initial version 99/01/01)
 ** 2004/05/13 Kars de Jong: Finalised HP300 support
 **
 ** This file is subject to the terms and conditions of the GNU General Public
-- 
1.7.9.5

