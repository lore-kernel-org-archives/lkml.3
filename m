Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaGEFea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:34:30 -0400
Received: from seketeli.net ([94.23.218.202]:45869 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaGEFe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:34:29 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Ralf Baechle <ralf@linux-mips.org>, Lars-Peter Clausen <lars@metafoo.de>,
        John Crispin <blogic@openwrt.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mips: jz4740: rename usb_nop_xceiv to usb_phy_generic
Date: Sat,  5 Jul 2014 07:34:57 +0200
Message-Id: <1404538497-8381-2-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404538497-8381-1-git-send-email-apelete@seketeli.net>
References: <1404538497-8381-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename usb_nop_xceiv to usb_phy_generic in platform data to match the
name change of the nop transceiver driver in commit 4525bee.
This patch fixes a kernel panic due to an unhandled kernel unaligned
access.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 arch/mips/jz4740/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index a447101..0b12f27 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -59,7 +59,7 @@ struct platform_device jz4740_usb_ohci_device = {
 
 /* USB Device Controller */
 struct platform_device jz4740_udc_xceiv_device = {
-	.name = "usb_phy_gen_xceiv",
+	.name = "usb_phy_generic",
 	.id   = 0,
 };
 
-- 
1.7.10.4

