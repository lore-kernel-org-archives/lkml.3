Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaFWL27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:28:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58171 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaFWL26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:28:58 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Joe Perches <joe@perches.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: devres: Add devm_kmalloc() et al
Date: Mon, 23 Jun 2014 12:28:38 +0100
Message-Id: <1403522918-16509-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 64c862a83... added new alloc variants to the devres managed
API. These should be included in the list of managed API found in
devres.txt.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: linux-doc@vger.kernel.org
---
 Documentation/driver-model/devres.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 1525e30..91f5633 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -234,7 +234,10 @@ certainly invest a bit more effort into libata core layer).
   -----------------------------
 
 MEM
+  devm_kmalloc()
   devm_kzalloc()
+  devm_kmalloc_array()
+  devm_kcalloc()
   devm_kfree()
   devm_kmemdup()
   devm_get_free_pages()
-- 
1.9.3

