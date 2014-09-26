Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaIZKbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:31:12 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58738 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaIZJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: arm@kernel.org, linux-kernel@vger.kernel.org
Cc: matthias.bgg@gmail.com, akpm@linux-foundation.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, joe@perches.com, m.chehab@samsung.com,
        crope@iki.fi, jg1.han@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH resend] MAINTAINERS: Add maintainers entry for Mediatek SoCs
Date: Fri, 26 Sep 2014 11:45:55 +0200
Message-Id: <1411724755-9866-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I plan to stay with the Mediatek SoCs for the next future
and hope to expand its support along the way with the help
of a whole bunch of people.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 65fd4db..2e4a030 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1156,6 +1156,16 @@ W:	http://www.digriz.org.uk/ts78xx/kernel
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

