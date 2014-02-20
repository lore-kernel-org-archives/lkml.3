Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaBTPBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:01:51 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:55161 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaBTPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:01:50 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] Documentation/spi/spidev_test.c: Document -N/--no-cs and -R/--ready
Date: Thu, 20 Feb 2014 16:01:43 +0100
Message-Id: <1392908503-23166-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

commit b55f627feeb9d48fdbde3835e18afbc76712e49b ("spi: new spi->mode bits")
added two new command line options without adding the respective help
texts.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 Documentation/spi/spidev_test.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/spi/spidev_test.c b/Documentation/spi/spidev_test.c
index 16feda901469..efd7385e907f 100644
--- a/Documentation/spi/spidev_test.c
+++ b/Documentation/spi/spidev_test.c
@@ -81,7 +81,9 @@ static void print_usage(const char *prog)
 	     "  -O --cpol     clock polarity\n"
 	     "  -L --lsb      least significant bit first\n"
 	     "  -C --cs-high  chip select active high\n"
-	     "  -3 --3wire    SI/SO signals shared\n");
+	     "  -3 --3wire    SI/SO signals shared\n"
+	     "  -N --no-cs    no chip select\n"
+	     "  -R --ready    slave pulls low to pause\n");
 	exit(1);
 }
 
-- 
1.7.9.5

