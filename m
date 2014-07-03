Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaGCJFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:05:24 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39930 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbaGCJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:05:20 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Joe Perches <joe@perches.com>
Subject: [RESEND PATCH] Documentation: devres: Add devm_kmalloc() et al
Date: Thu,  3 Jul 2014 10:05:02 +0100
Message-Id: <1404378302-32279-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403522918-16509-1-git-send-email-daniel.thompson@linaro.org>
References: <1403522918-16509-1-git-send-email-daniel.thompson@linaro.org>
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
Acked-by: Tejun Heo <tj@kernel.org>
---

Notes:
    Greg: Tejun acked this and suggested that it should go via
          driver-core-next.

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

