Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaG3DjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:39:00 -0400
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:55036 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754942AbaG3Di4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:38:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1042:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3352:3865:3866:5007:6261:7514:7809:7875:9592:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brain51_4ddd08d370f57
X-Filterd-Recvd-Size: 2068
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] MAINTAINERS: Update solo6x10 patterns
Date: Tue, 29 Jul 2014 20:38:42 -0700
Message-Id: <7142cc450c37b75474780f2e4610d5a44a0f757b.1406691397.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 28cae868cd24 ("[media] solo6x10: move out of staging into
drivers/media/pci") moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3960ba8..8ed337c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8403,6 +8403,12 @@ M:	Chris Boot <bootc@bootc.net>
 S:	Maintained
 F:	drivers/leds/leds-net48xx.c
 
+SOFTLOGIC 6x10 MPEG CODEC
+M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/media/pci/solo6x10/
+
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Neil Brown <neilb@suse.de>
 L:	linux-raid@vger.kernel.org
@@ -8666,11 +8672,6 @@ M:	Christopher Harrer <charrer@alacritech.com>
 S:	Odd Fixes
 F:	drivers/staging/slicoss/
 
-STAGING - SOFTLOGIC 6x10 MPEG CODEC
-M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
-S:	Supported
-F:	drivers/staging/media/solo6x10/
-
 STAGING - SPEAKUP CONSOLE SPEECH DRIVER
 M:	William Hubbs <w.d.hubbs@gmail.com>
 M:	Chris Brannon <chris@the-brannons.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

