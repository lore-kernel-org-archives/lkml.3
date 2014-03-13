Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaCMRLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:11:51 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:50901 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754012AbaCMRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:11:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1431:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3770:3865:3867:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4699:5007:6119:6120:7652:8599:9015:9025:9388:10004:10400:10848:11232:11658:11914:12043:12114:12517:12519:12555:12776:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss65_66f7a8ae41e23
X-Filterd-Recvd-Size: 1365
Message-ID: <1394730705.3915.82.camel@joe-AO722>
Subject: [RFC PATCH] MAINTAINERS: Add linux.nics@intel.com to INTEL ETHERNET
 DRIVERS
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 10:11:45 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this is added to the driver files, then maybe it's
appropriate to add to MAINTAINERS as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dbac7b9..f5f1ee7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4577,6 +4577,7 @@ M:	Greg Rose <gregory.v.rose@intel.com>
 M:	Alex Duyck <alexander.h.duyck@intel.com>
 M:	John Ronciak <john.ronciak@intel.com>
 M:	Mitch Williams <mitch.a.williams@intel.com>
+M:	Linux NICS <linux.nics@intel.com>
 L:	e1000-devel@lists.sourceforge.net
 W:	http://www.intel.com/support/feedback.htm
 W:	http://e1000.sourceforge.net/


