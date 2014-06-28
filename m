Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaF1Ueg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:34:36 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:41307 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaF1Ued (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:34:33 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney.cavm@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 2/3] MIPS: OCTEON: add USB clock type for D-Link DSR-1000N
Date: Sat, 28 Jun 2014 23:34:09 +0300
Message-Id: <1403987650-6194-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
References: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB clock type for D-Link DSR-1000N.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index b764df6..6c871a5 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -738,6 +738,7 @@ enum cvmx_helper_board_usb_clock_types __cvmx_helper_board_usb_get_clock_type(vo
 	case CVMX_BOARD_TYPE_LANAI2_G:
 	case CVMX_BOARD_TYPE_NIC10E_66:
 	case CVMX_BOARD_TYPE_UBNT_E100:
+	case CVMX_BOARD_TYPE_CUST_DSR1000N:
 		return USB_CLOCK_TYPE_CRYSTAL_12;
 	case CVMX_BOARD_TYPE_NIC10E:
 		return USB_CLOCK_TYPE_REF_12;
-- 
2.0.0

