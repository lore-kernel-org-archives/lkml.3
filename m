Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaBPUzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:55:54 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:55434 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaBPUzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:55:52 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <paul.mundt@gmail.com>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH RFC] MAINTAINERS: Mark SuperH orphan
Date: Sun, 16 Feb 2014 21:55:37 +0100
Message-Id: <1392584137-24486-1-git-send-email-geert@linux-m68k.org>
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
 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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

