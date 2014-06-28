Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaF1Uee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:34:34 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33256 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaF1Ued (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:34:33 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney.cavm@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 1/3] MIPS: OCTEON: cvmx-bootinfo: add D-Link DSR-1000N
Date: Sat, 28 Jun 2014 23:34:08 +0300
Message-Id: <1403987650-6194-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
References: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a definition for D-Link DSR-1000N router. The bootloader on this board
supplies 20006 in the bootinfo; the enum CVMX_BOARD_TYPE_CUST_DSR1000N
comes from the GPL sources of the board.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/include/asm/octeon/cvmx-bootinfo.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/octeon/cvmx-bootinfo.h b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
index 7b7818d..2298199 100644
--- a/arch/mips/include/asm/octeon/cvmx-bootinfo.h
+++ b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
@@ -228,6 +228,7 @@ enum cvmx_board_types_enum {
 	 */
 	CVMX_BOARD_TYPE_CUST_PRIVATE_MIN = 20001,
 	CVMX_BOARD_TYPE_UBNT_E100 = 20002,
+	CVMX_BOARD_TYPE_CUST_DSR1000N = 20006,
 	CVMX_BOARD_TYPE_CUST_PRIVATE_MAX = 30000,
 
 	/* The remaining range is reserved for future use. */
@@ -327,6 +328,7 @@ static inline const char *cvmx_board_type_to_string(enum
 		    /* Customer private range */
 		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_CUST_PRIVATE_MIN)
 		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_UBNT_E100)
+		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_CUST_DSR1000N)
 		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_CUST_PRIVATE_MAX)
 	}
 	return "Unsupported Board";
-- 
2.0.0

