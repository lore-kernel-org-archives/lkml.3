Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3BSUeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:34:09 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40649 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab3BSUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:34:08 -0500
From: maxin.john@gmail.com
To: djbw@fb.com, lars@metafoo.de
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH] dma: timb_dma: Fix compiler warning
Date: Tue, 19 Feb 2013 22:33:53 +0200
Message-Id: <1361306033-22229-1-git-send-email-maxin.john@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

Fix this compiler warning:
warning: 'td_remove' defined but not used [-Wunused-function]

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/dma/timb_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 952f823..26107ba 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -823,7 +823,7 @@ static struct platform_driver td_driver = {
 		.owner  = THIS_MODULE,
 	},
 	.probe	= td_probe,
-	.remove	= __exit_p(td_remove),
+	.remove	= td_remove,
 };
 
 module_platform_driver(td_driver);
-- 
1.7.7

