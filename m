Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaFIP4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:56:02 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45596 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356AbaFIPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:55:54 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        "GitAuthor: Pranith Kumar" <bobby.prani@gmail.com>,
        linux-hexagon@vger.kernel.org (open list:QUALCOMM HEXAGON...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/6] update reference, kerneltrap.org no longer works
Date: Mon,  9 Jun 2014 11:55:24 -0400
Message-Id: <1402329327-6766-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402329327-6766-1-git-send-email-bobby.prani@gmail.com>
References: <1402329327-6766-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kerneltrap.org no longer works, update to a working reference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/hexagon/include/asm/cache.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/include/asm/cache.h b/arch/hexagon/include/asm/cache.h
index f4ca594..2635117 100644
--- a/arch/hexagon/include/asm/cache.h
+++ b/arch/hexagon/include/asm/cache.h
@@ -28,7 +28,7 @@
 #define __cacheline_aligned	__aligned(L1_CACHE_BYTES)
 #define ____cacheline_aligned	__aligned(L1_CACHE_BYTES)
 
-/* See http://kerneltrap.org/node/15100  */
+/* See http://lwn.net/Articles/262554/ */
 #define __read_mostly
 
 #endif
-- 
1.9.1

