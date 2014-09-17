Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbaIQNut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:50:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36278 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbaIQNus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:50:48 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, gregkh@linuxfoundation.org,
        joe@perches.com, m.chehab@samsung.com, crope@iki.fi,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] MAINTAINERS: Add maintainers entry for Mediatek SoCs
Date: Wed, 17 Sep 2014 15:50:31 +0200
Message-Id: <1410961831-15532-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I plan to stay with the Mediatek SoCs for the near future
and hope to expand its support along the way with the help
of a whole bunch of people.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 63c1b0f..23618e7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1162,6 +1162,16 @@ W:	http://www.digriz.org.uk/ts78xx/kernel
 S:	Maintained
 F:	arch/arm/mach-orion5x/ts78xx-*
 
+ARM/Mediatek SoC support
+M:	Matthias Brugger <matthias.bgg@gmail.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/boot/dts/mt6*
+F:	arch/arm/boot/dts/mt8*
+F:	arch/arm/mach-mediatek/
+N:	mtk
+K:	mediatek
+
 ARM/MICREL KS8695 ARCHITECTURE
 M:	Greg Ungerer <gerg@uclinux.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.9.1

