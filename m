Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3ITBxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:53:20 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:60093 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965Ab3ITBxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:53:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:857:960:973:988:989:1260:1345:1534:1539:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11658:11914:12438:12517:12519:12555:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drum09_910ec8de5a744
X-Filterd-Recvd-Size: 1331
From: Joe Perches <joe@perches.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] framebuffer: arkfb: Fix framebugger typo
Date: Thu, 19 Sep 2013 18:53:13 -0700
Message-Id: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/framebugger/framebuffer/

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/arkfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index ee0f1a1..b13f3f2 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -1048,7 +1048,7 @@ static int ark_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->device, "cannot register framebugger\n");
+		dev_err(info->device, "cannot register framebuffer\n");
 		goto err_reg_fb;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

