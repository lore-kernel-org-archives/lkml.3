Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3AVRQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:16:32 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41390 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3AVRQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:16:30 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] MAINTAINERS: update avr32 web ressources
Date: Tue, 22 Jan 2013 18:16:21 +0100
Message-Id: <1358874981-8655-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Web ressource http://avr32linux.org is no longer
available. This patch deletes the corresponding line.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3105c48..e9c1746 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1489,7 +1489,6 @@ AVR32 ARCHITECTURE
 M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
 M:	Hans-Christian Egtvedt <egtvedt@samfundet.no>
 W:	http://www.atmel.com/products/AVR32/
-W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
 S:	Maintained
 F:	arch/avr32/
-- 
1.7.11.7

