Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaDYBvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:51:32 -0400
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:37189 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbaDYBvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1539:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:5007:6114:6261:6642:7875:10004:10026:10848:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: match10_636ee63d2611a
X-Filterd-Recvd-Size: 1400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Subject: [PATCH 4/5] appledisplay: Convert /n to \n
Date: Thu, 24 Apr 2014 18:51:02 -0700
Message-Id: <9bbe7dc36e6b609512f166e10b6b99a706fbbd11.1398390579.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a newline character appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/appledisplay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index ba6a5d6..f37c78d 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -110,7 +110,7 @@ static void appledisplay_complete(struct urb *urb)
 			__func__, status);
 		return;
 	default:
-		dev_dbg(dev, "%s - nonzero urb status received: %d/n",
+		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
 			__func__, status);
 		goto exit;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

