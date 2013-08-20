Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3HTXy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:54:27 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:58585 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3HTXy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:54:26 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, trivial@kernel.org, rob@landley.net,
        mopsfelder@gmail.com
Subject: [PATCH v2] trivial: fix a typo in Documentation/00-INDEX
Date: Tue, 20 Aug 2013 20:48:39 -0300
Message-Id: <1377042519-2345-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <alpine.LNX.2.00.1308201245170.21654@pobox.suse.cz>
References: <alpine.LNX.2.00.1308201245170.21654@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
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
