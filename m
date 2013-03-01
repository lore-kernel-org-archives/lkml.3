Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3CAT2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:28:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55918 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192Ab3CAT2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:28:09 -0500
Message-ID: <1362166088.2116.10.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Convert some P: entries to M:
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Vincent Sanders <vince@simtec.co.uk>,
        Andres Salomon <dilinger@queued.net>
Date: Fri, 01 Mar 2013 11:28:08 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P: is for names without email addresses.
M: is for names with email addresses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6db1c6b..9cba252 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -533,7 +533,7 @@ S:	Supported
 F:	drivers/usb/gadget/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
-P:	Andres Salomon <dilinger@queued.net>
+M:	Andres Salomon <dilinger@queued.net>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
@@ -7127,14 +7127,14 @@ F:	include/linux/sfi*.h
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-P:	Vincent Sanders <vince@simtec.co.uk>
+M:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
-P:	Vincent Sanders <vince@simtec.co.uk>
+M:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported


