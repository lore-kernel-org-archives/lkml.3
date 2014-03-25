Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaCYTto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:49:44 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:42035 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751877AbaCYTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:49:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:979:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3867:3868:4321:4383:4388:4395:5007:6120:7652:10004:10400:10848:11232:11658:11914:12517:12519:12555:12679:13069:13311:13357:13846:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: force20_8eb8f0be7b109
X-Filterd-Recvd-Size: 1876
Message-ID: <1395776979.3010.27.camel@joe-AO722>
Subject: [RFC PATCH] MAINTAINERS: Remove Venkatesh from HPET, move to CREDITS
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 25 Mar 2014 12:49:39 -0700
In-Reply-To: <f85b0d53be92e0b7f2c2aa5fdc572c1bc3ad624c.1395775901.git.joe@perches.com>
References: <cover.1395775901.git.joe@perches.com>
	 <f85b0d53be92e0b7f2c2aa5fdc572c1bc3ad624c.1395775901.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems he's gone off to bigger/better things.
So long, etc...

Signed-off-by: Joe Perches <joe@perches.com>
---
 CREDITS     | 3 +++
 MAINTAINERS | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index ae3dbc0..ce275b6 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2725,6 +2725,9 @@ N: Greg Page
 E: gpage@sovereign.org
 D: IPX development and support
 
+N: Venkatesh Pallipadi (Venki)
+D: x86/HPET
+
 N: David Parsons
 E: orc@pell.chi.il.us
 D: improved memory detection code.
diff --git a/MAINTAINERS b/MAINTAINERS
index e1724d5..e134f91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4181,8 +4181,7 @@ F:	include/linux/hpet.h
 F:	include/uapi/linux/hpet.h
 
 HPET:	x86
-M:	"Venkatesh Pallipadi (Venki)" <venki@google.com>
-S:	Maintained
+S:	Orphan
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 


