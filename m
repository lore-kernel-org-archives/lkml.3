Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3KGUFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:05:04 -0500
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:39106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632Ab3KGUEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:04:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:967:973:979:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3770:3867:3868:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4383:4659:5007:6119:6120:7652:9015:9025:9388:9392:10004:10400:10848:11232:11257:11658:11914:12043:12517:12519:12555:12679:13069:13311:13357:13523:13846,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: turn36_64f2419e93f49
X-Filterd-Recvd-Size: 2236
Message-ID: <1383854696.9263.25.camel@joe-AO722>
Subject: [RFC PATCH] MAINTAINERS: Remove Jaroslav Kysela
From: Joe Perches <joe@perches.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel <alsa-devel@alsa-project.org>
Date: Thu, 07 Nov 2013 12:04:56 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaroslav hasn't acked or signed a patch in quite awhile.

Mark ISAPnp and HP VG/AnyLAN driver as orphan.

Add sound to his CREDITS entry.

Signed-off-by: Joe Perches <joe@perches.com>
---
 CREDITS     | 1 +
 MAINTAINERS | 7 ++-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/CREDITS b/CREDITS
index 0640e16..01a1b34 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2021,6 +2021,7 @@ E: perex@perex.cz
 W: http://www.perex.cz
 D: Original Author and Maintainer for HP 10/100 Mbit Network Adapters
 D: ISA PnP
+D: ALSA/Sound
 S: Sindlovy Dvory 117
 S: 370 01  Ceske Budejovice
 S: Czech Republic
diff --git a/MAINTAINERS b/MAINTAINERS
index 831b869..8706839 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3983,8 +3983,7 @@ S:	Orphan
 F:	drivers/platform/x86/tc1100-wmi.c
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
-M:	Jaroslav Kysela <perex@perex.cz>
-S:	Maintained
+S:	Orphan
 F:	drivers/net/ethernet/hp/hp100.*
 
 HPET:	High Precision Event Timers driver
@@ -4600,8 +4599,7 @@ F:	include/linux/irqdomain.h
 F:	kernel/irq/irqdomain.c
 
 ISAPNP
-M:	Jaroslav Kysela <perex@perex.cz>
-S:	Maintained
+S:	Orphan
 F:	Documentation/isapnp.txt
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
@@ -7818,7 +7816,6 @@ S:	Maintained
 F:	drivers/memstick/core/ms_block.*
 
 SOUND
-M:	Jaroslav Kysela <perex@perex.cz>
 M:	Takashi Iwai <tiwai@suse.de>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.alsa-project.org/


