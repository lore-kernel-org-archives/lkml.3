Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaLHVXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:23:15 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38157 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaLHVXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:23:13 -0500
From: Dean Michael Ancajas <dbancajas@gmail.com>
To: marek.belisko@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dean Michael Ancajas <dbancajas@gmail.com>
Subject: [PATCH] Staging: ft1000: ft1000-pcmcia: Fixed a coding style issue
Date: Mon,  8 Dec 2014 14:23:01 -0700
Message-Id: <1418073781-10237-1-git-send-email-dbancajas@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue for braces.

Signed-off-by: Dean Michael Ancajas <dbancajas@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 44575c7..45960b2 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -176,11 +176,11 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
 	/* check if we want to read upper or lower 32-bit word */
-	if (Index) {
+	if (Index)
 		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAL);
-	} else {
+	else
 		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAH);
-	}
+
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
 	return data;
-- 
1.9.1

