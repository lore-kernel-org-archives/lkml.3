Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3CSJwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:53 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16898 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3CSJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYCANk0SFFbdWObgWdsb2JhbABDh2a9PIFbFg4BARYmKIIlAQV5EFFXBhOIGLIxkCGNTIFCB4NAA5ZflA07gS4
X-IPAS-Result: ArYCANk0SFFbdWObgWdsb2JhbABDh2a9PIFbFg4BARYmKIIlAQV5EFFXBhOIGLIxkCGNTIFCB4NAA5ZflA07gS4
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18790010"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 8/9] staging/sb105x: remove BROKEN tag from Kconfig
Date: Tue, 19 Mar 2013 10:51:29 +0100
Message-Id: <1363686690-27090-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the build finishes without any errors

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/Kconfig
index 245e784..58cc52e 100644
--- a/drivers/staging/sb105x/Kconfig
+++ b/drivers/staging/sb105x/Kconfig
@@ -1,7 +1,7 @@
 config SB105X
 	tristate "SystemBase PCI Multiport UART"
 	select SERIAL_CORE
-	depends on PCI && X86 && TTY && BROKEN
+	depends on PCI && X86 && TTY
 	help
 	  A driver for the SystemBase Multi-2/PCI serial card
 
-- 
1.7.10.4

