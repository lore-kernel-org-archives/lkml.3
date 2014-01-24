Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaAXMvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:51:33 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:39191 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaAXMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 13/15] ARM: shmobile: lager legacy: Switch QSPI to named IRQs
Date: Fri, 24 Jan 2014 13:49:49 +0100
Message-Id: <1390567791-8988-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/mach-shmobile/board-lager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
index 8dde4462f600..4977a4b9fa2c 100644
--- a/arch/arm/mach-shmobile/board-lager.c
+++ b/arch/arm/mach-shmobile/board-lager.c
@@ -290,7 +290,7 @@ static const struct spi_board_info spi_info[] __initconst = {
 /* QSPI resource */
 static const struct resource qspi_resources[] __initconst = {
 	DEFINE_RES_MEM(0xe6b10000, 0x1000),
-	DEFINE_RES_IRQ(gic_spi(184)),
+	DEFINE_RES_IRQ(gic_spi(184), "mux"),
 };
 
 /* VIN */
-- 
1.7.9.5

