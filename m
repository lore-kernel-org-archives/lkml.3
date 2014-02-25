Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaBYVf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:35:58 -0500
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:56998 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751339AbaBYVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:35:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3865:3867:3868:3874:4321:5007:6119:7652:7809:10004:10400:10848:11232:11657:11658:11914:12043:12296:12517:12519:12555:12679:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dad15_1690bd2d3e71a
X-Filterd-Recvd-Size: 1441
Message-ID: <1393364153.8716.63.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Intel nic drivers
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 25 Feb 2014 13:35:53 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new F: line for the intel subdirectories.

This allows get_maintainers to avoid using git log
and cc'ing people that have submitted clean-up style
patches for all first level directories under
drivers/net/ethernet/intel/

This does not make e100.c maintained.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90baeb1..9778d12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4574,6 +4574,7 @@ F:	Documentation/networking/ixgbevf.txt
 F:	Documentation/networking/i40e.txt
 F:	Documentation/networking/i40evf.txt
 F:	drivers/net/ethernet/intel/
+F:	drivers/net/ethernet/intel/*/
 
 INTEL-MID GPIO DRIVER
 M:	David Cohen <david.a.cohen@linux.intel.com>


