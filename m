Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbaGCWI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:29 -0400
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:33748 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754073AbaGCWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:800:960:966:967:973:988:989:1260:1345:1359:1431:1437:1534:1541:1711:1730:1747:1777:1792:2196:2199:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4385:4659:5007:6261:7514:7809:7875:7903:7974:9025:9388:9592:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13161:13229:13311:13357:13437:13846:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bird49_2c334d7b1461e
X-Filterd-Recvd-Size: 2554
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] MAINTAINERS: Update staging removals and movements
Date: Thu,  3 Jul 2014 15:07:54 -0700
Message-Id: <26fbd66596577a81c3bbe4a134742eb960001f11.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 sections have been deleted by various commits.
The other, echo, has been moved to drivers/misc.

The nominal maintainers of the echo subsystem haven't
been modifying the code or acking/signing patches for
several years, so don't keep the section either.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8575e84..4749c4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5036,13 +5036,6 @@ S:	Maintained
 F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
-KTAP
-M:	Jovi Zhangwei <jovi.zhangwei@gmail.com>
-W:	http://www.ktap.org
-L:	ktap@freelists.org
-S:	Maintained
-F:	drivers/staging/ktap/
-
 KCONFIG
 M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
@@ -8499,23 +8492,12 @@ L:	devel@driverdev.osuosl.org
 S:	Supported
 F:	drivers/staging/
 
-STAGING - ASUS OLED
-M:	Jakub Schmidtke <sjakub@gmail.com>
-S:	Odd Fixes
-F:	drivers/staging/asus_oled/
-
 STAGING - COMEDI
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	H Hartley Sweeten <hsweeten@visionengravers.com>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
-STAGING - ECHO CANCELLER
-M:	Steve Underwood <steveu@coppice.org>
-M:	David Rowe <david@rowetel.com>
-S:	Odd Fixes
-F:	drivers/staging/echo/
-
 STAGING - ET131X NETWORK DRIVER
 M:	Mark Einon <mark.einon@gmail.com>
 S:	Odd Fixes
@@ -8587,11 +8569,6 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/rtl8723au/
 
-STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
-M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
-S:	Odd Fixes
-F:	drivers/staging/sm7xxfb/
-
 STAGING - SLICOSS
 M:	Lior Dotan <liodot@gmail.com>
 M:	Christopher Harrer <charrer@alacritech.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

