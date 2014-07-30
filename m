Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaG3Djr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:39:47 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:52481 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754917AbaG3Diy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:38:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3352:3865:3866:4321:5007:6261:7514:7875:9592:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able99_4d922c8a4b44e
X-Filterd-Recvd-Size: 1899
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] MAINTAINERS: Update go7007 pattern
Date: Tue, 29 Jul 2014 20:38:41 -0700
Message-Id: <9532fa3e0e1bf8fd3f63a26e095060401d785648.1406691397.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7955f03d18d1 ("[media] go7007: move out of staging into
drivers/media/usb") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6033aaf..3960ba8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3997,6 +3997,12 @@ F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
 F:	include/uapi/linux/gigaset_dev.h
 
+GO7007 MPEG CODEC
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/usb/go7007/
+
 GPIO SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
 M:	Alexandre Courbot <gnurou@gmail.com>
@@ -8603,11 +8609,6 @@ M:	Marek Belisko <marek.belisko@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/ft1000/
 
-STAGING - GO7007 MPEG CODEC
-M:	Hans Verkuil <hans.verkuil@cisco.com>
-S:	Maintained
-F:	drivers/staging/media/go7007/
-
 STAGING - INDUSTRIAL IO
 M:	Jonathan Cameron <jic23@kernel.org>
 L:	linux-iio@vger.kernel.org
-- 
1.8.1.2.459.gbcd45b4.dirty

