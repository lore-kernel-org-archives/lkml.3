Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaE1Bdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:33:52 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:40047 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752186AbaE1Bdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:33:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12555:13069:13311:13357:13846,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: worm57_78a4e896c6318
X-Filterd-Recvd-Size: 1236
Message-ID: <1401240827.20587.15.camel@joe-AO725>
Subject: [PATCH] MAINTAINERS: Add me as the get_maintainer.pl maintainer
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 27 May 2014 18:33:47 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might as well be the get_maintainer maintainer...

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c0d1e36..98604ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3900,6 +3900,11 @@ L:	kvm@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
+GET_MAINTAINER SCRIPT
+M:	Joe Perches <joe@perches.com>
+S:	Maintained
+F:	scripts/get_maintainer.pl
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho@redhat.com>
 L:	cluster-devel@redhat.com


