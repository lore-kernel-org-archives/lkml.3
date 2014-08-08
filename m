Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaHHPT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:19:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63787 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbaHHPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:19:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH trivial 4/4] init/Kconfig: Spelling s/compuation/computation/, double "the"
Date: Fri,  8 Aug 2014 17:19:15 +0200
Message-Id: <1407511155-5264-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
References: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5aec7006c8bb..a5f8bc426f7c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -843,7 +843,7 @@ config LOG_CPU_MAX_BUF_SHIFT
 	  used as it forces an exact (power of two) size of the ring buffer.
 
 	  The number of possible CPUs is used for this computation ignoring
-	  hotplugging making the compuation optimal for the the worst case
+	  hotplugging making the computation optimal for the worst case
 	  scenerio while allowing a simple algorithm to be used from bootup.
 
 	  Examples shift values and their meaning:
-- 
1.9.1

