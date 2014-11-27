Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaK0LFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:05:55 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:58083 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaK0LFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:05:52 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH/TRIVIAL 1/4] ARM: l2c: Grammar s/If ... if/If ... is/
Date: Thu, 27 Nov 2014 12:05:43 +0100
Message-Id: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mm/cache-l2x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 5e65ca8dea62cf3f..5216bfe7fd86f557 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -979,7 +979,7 @@ static int __init l2x0_cache_size_of_parse(const struct device_node *np,
 	/* All these l2 caches have the same line = block size actually */
 	if (!line_size) {
 		if (block_size) {
-			/* If linesize if not given, it is equal to blocksize */
+			/* If linesize is not given, it is equal to blocksize */
 			line_size = block_size;
 		} else {
 			/* Fall back to known size */
-- 
1.9.1

