Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaBSOyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:54:31 -0500
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:35449 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752376AbaBSOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:54:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,-8,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1719:1730:1747:1777:1792:2393:2525:2568:2628:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:5007:6119:7652:8599:9025:9388:9562:10004:10049:10400:10848:11257:11658:11914:12043:12379:12517:12519:12555:12679:13069:13072:13221:13229:13311:13357:13437:13846:13868:14094:14106,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fall54_613b5a9a8482e
X-Filterd-Recvd-Size: 2155
Message-ID: <1392821667.24844.10.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Update L: misuses
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        JamieLenehan <lenehan@twibble.org>
Date: Wed, 19 Feb 2014 06:54:27 -0800
In-Reply-To: <1392820997.24844.5.camel@joe-AO722>
References: <1392805582.27558.30.camel@x220>
	 <1392820997.24844.5.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L: lines are for the email addresses of traditional mailing lists.
W: lines are for URLs.

Convert two L: misuses to W: links.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 60a5f85..adfbf3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2625,9 +2625,9 @@ DC395x SCSI driver
 M:	Oliver Neukum <oliver@neukum.org>
 M:	Ali Akcaagac <aliakc@web.de>
 M:	Jamie Lenehan <lenehan@twibble.org>
-W:	http://twibble.org/dist/dc395x/
 L:	dc395x@twibble.org
-L:	http://lists.twibble.org/mailman/listinfo/dc395x/
+W:	http://twibble.org/dist/dc395x/
+W:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
 F:	Documentation/scsi/dc395x.txt
 F:	drivers/scsi/dc395x.*
@@ -8465,8 +8465,8 @@ TARGET SUBSYSTEM
 M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
 L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
-L:	http://groups.google.com/group/linux-iscsi-target-dev
 W:	http://www.linux-iscsi.org
+W:	http://groups.google.com/group/linux-iscsi-target-dev
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
 S:	Supported
 F:	drivers/target/


