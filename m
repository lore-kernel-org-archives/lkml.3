Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3KER37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:29:59 -0500
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:36212 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755125Ab3KER36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:29:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1515:1516:1518:1534:1538:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3872:3876:5007:6119:7652:10004:10400:10848:11026:11473:11658:11914:12296:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rule19_56a3a60baa75f
X-Filterd-Recvd-Size: 1178
Message-ID: <1383672595.4387.23.camel@joe-AO722>
Subject: [PATCH] jme: Remove unused #define PFX
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: Guo-Fu Tseng <cooldavid@cooldavid.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Nov 2013 09:29:55 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unused, remove it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/jme.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/jme.h b/drivers/net/ethernet/jme.h
index 3efc897..58cd67c 100644
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -28,7 +28,6 @@
 
 #define DRV_NAME	"jme"
 #define DRV_VERSION	"1.0.8"
-#define PFX		DRV_NAME ": "
 
 #define PCI_DEVICE_ID_JMICRON_JMC250	0x0250
 #define PCI_DEVICE_ID_JMICRON_JMC260	0x0260


