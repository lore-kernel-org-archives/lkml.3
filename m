Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbaEKUQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:16:41 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:52032 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaEKUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 16:16:40 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] Documentation/DMA-API-HOWTO.txt: fix duplicated word
Date: Sun, 11 May 2014 17:15:24 -0300
Message-Id: <1399839324-21773-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"coherent" is written twice when it should be just once

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---

The sentence still doesn't sound entirely correct in my head, maybe 
someone can propose a better rewording.

 Documentation/DMA-API-HOWTO.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 5e98303..4ede25a 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -192,7 +192,7 @@ the case would look like this:
 		goto ignore_this_device;
 	}
 
-The coherent coherent mask will always be able to set the same or a
+The coherent mask will always be able to set the same or a
 smaller mask as the streaming mask. However for the rare case that a
 device driver only uses consistent allocations, one would have to
 check the return value from dma_set_coherent_mask().
-- 
1.9.2

