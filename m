Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHTN0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:26:39 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:41399 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHTN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:26:37 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] Documentation: devres: Add missing devm_kstrdup() managed interface
Date: Wed, 20 Aug 2014 15:26:34 +0200
Message-Id: <1408541195-20455-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/driver-model/devres.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index d14710b04439..62582434282e 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -296,6 +296,7 @@ MEM
   devm_kmalloc()
   devm_kmalloc_array()
   devm_kmemdup()
+  devm_kstrdup()
   devm_kzalloc()
 
 PCI
-- 
1.9.1

