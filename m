Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaHFPho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:37:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaHFPhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:37:43 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jean-Michel Hautbois <jhautbois@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] misc: lattice-ecp3-config: Add missing MODULE_FIRMWARE()
Date: Wed,  6 Aug 2014 17:37:41 +0200
Message-Id: <1407339461-24483-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/misc/lattice-ecp3-config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 7ffdb589841e..643c9eda69dd 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -242,3 +242,4 @@ module_spi_driver(lattice_ecp3_driver);
 MODULE_AUTHOR("Stefan Roese <sr@denx.de>");
 MODULE_DESCRIPTION("Lattice ECP3 FPGA configuration via SPI");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE_NAME);
-- 
2.0.3

