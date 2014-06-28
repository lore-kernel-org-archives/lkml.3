Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaF1QyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 12:54:07 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:51380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490AbaF1QyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:54:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:979:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3868:3870:3871:4383:5007:7652:7809:7903:9592:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:13069:13072:13161:13229:13311:13357:13846:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trees69_409b5e2da7d2a
X-Filterd-Recvd-Size: 1806
Message-ID: <1403974442.9064.25.camel@joe-AO725>
Subject: [PATCH] MAINTAINERS: Remove two ancient EATA sections
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 28 Jun 2014 09:54:02 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These haven't had a single ack by the listed maintainer
in all git history and the email addresses don't work.

And entry for Michael Neuffer is already in CREDITS.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ea4305..93aa52b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3189,26 +3189,12 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/e4000*
 
-EATA-DMA SCSI DRIVER
-M:	Michael Neuffer <mike@i-Connect.Net>
-L:	linux-eata@i-connect.net
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/eata*
-
 EATA ISA/EISA/PCI SCSI DRIVER
 M:	Dario Ballabio <ballabio_dario@emc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata.c
 
-EATA-PIO SCSI DRIVER
-M:	Michael Neuffer <mike@i-Connect.Net>
-L:	linux-eata@i-connect.net
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/eata_pio.*
-
 EC100 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org


