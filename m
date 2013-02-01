Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3BANHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:07:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:44300 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab3BANHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:07:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 10/89] ARM: S3C64XX: Fix up IRQ mapping for balblair on Cragganmore
Date: Fri,  1 Feb 2013 14:07:25 +0100
Message-Id: <20130201130208.201001679@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

commit b86dc0d8c12bbb9fed3f392c284bdc7114ce00c1 upstream.

We are using S3C_EINT(4) instead of S3C_EINT(5).

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-s3c64xx/mach-crag6410-module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-s3c64xx/mach-crag6410-module.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
@@ -39,7 +39,7 @@ static struct spi_board_info wm1253_devs
 		.bus_num	= 0,
 		.chip_select	= 0,
 		.mode		= SPI_MODE_0,
-		.irq		= S3C_EINT(5),
+		.irq		= S3C_EINT(4),
 		.controller_data = &wm0010_spi_csinfo,
 	},
 };


