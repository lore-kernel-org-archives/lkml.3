Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaBPVhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:37:13 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:34264 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaBPVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:37:12 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <paul.mundt@gmail.com>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2] MAINTAINERS: Mark SuperH orphan
Date: Sun, 16 Feb 2014 22:36:59 +0100
Message-Id: <1392586619-27018-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Paul Mundt's email address bounces regularly, and he hasn't taken any
SuperH patches for about one year.

Suggested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2: Add a CREDITS entry

 CREDITS     |    4 ++++
 MAINTAINERS |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index e371c5504a50..acab035edcfc 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2564,6 +2564,10 @@ N. Wolfgang Muees
 E: wolfgang@iksw-muees.de
 D: Auerswald USB driver
 
+N: Paul Mundt
+E: paul.mundt@gmail.com
+D: SuperH maintainer
+
 N: Ian A. Murdock
 E: imurdock@gnu.ai.mit.edu
 D: Creator of Debian distribution
diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cfb4d29..2d294561ebdc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8372,12 +8372,10 @@ S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
 SUPERH
-M:	Paul Mundt <lethal@linux-sh.org>
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
 Q:	http://patchwork.kernel.org/project/linux-sh/list/
-T:	git git://github.com/pmundt/linux-sh.git sh-latest
-S:	Supported
+S:	Orphan
 F:	Documentation/sh/
 F:	arch/sh/
 F:	drivers/sh/
-- 
1.7.9.5

