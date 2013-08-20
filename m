Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3HTArd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:47:33 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:58203 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3HTArc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:47:32 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, trivial@kernel.org, rob@landley.net,
        mopsfelder@gmail.com
Subject: [PATCH] trivial: fix a typo in Documentation/00-INDEX
Date: Mon, 19 Aug 2013 21:47:24 -0300
Message-Id: <1376959644-3242-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Documentation/00-INDEX | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 0c4cc68..38f8444 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -40,7 +40,7 @@ IPMI.txt
 IRQ-affinity.txt
 	- how to select which CPU(s) handle which interrupt events on SMP.
 IRQ-domain.txt
-	- info on inerrupt numbering and setting up IRQ domains.
+	- info on interrupt numbering and setting up IRQ domains.
 IRQ.txt
 	- description of what an IRQ is.
 Intel-IOMMU.txt
-- 
1.8.3.1

