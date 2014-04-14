Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaDNQ4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:56:01 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:51942 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaDNQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:55:56 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH trivial 1/2] misc: Grammar s/addition/additional/
Date: Mon, 14 Apr 2014 18:55:49 +0200
Message-Id: <1397494550-22252-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 1cb74085e410..8baff0effc7d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -300,8 +300,8 @@ config SGI_GRU_DEBUG
 	depends on SGI_GRU
 	default n
 	---help---
-	This option enables addition debugging code for the SGI GRU driver. If
-	you are unsure, say N.
+	This option enables additional debugging code for the SGI GRU driver.
+	If you are unsure, say N.
 
 config APDS9802ALS
 	tristate "Medfield Avago APDS9802 ALS Sensor module"
-- 
1.7.9.5

