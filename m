Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaKSOB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:01:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:18177 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaKSOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:01:27 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: fix GPLv2 wording
Date: Wed, 19 Nov 2014 15:01:26 +0100
Message-ID: <1416405686-25287-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the submission of these new sama5d4 files, the GPL notice mentioned the
device tree as a library, which is not really accurate.
Fix all these library mentions to reflect the fact that it's actually just a
file.

Reported-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91-sama5d4ek.dts | 4 ++--
 arch/arm/boot/dts/sama5d4.dtsi       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d4ek.dts b/arch/arm/boot/dts/at91-sama5d4ek.dts
index b5b84006469e..9198b719d0ef 100644
--- a/arch/arm/boot/dts/at91-sama5d4ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d4ek.dts
@@ -9,12 +9,12 @@
  * licensing only applies to this file, and not this project as a
  * whole.
  *
- *  a) This library is free software; you can redistribute it and/or
+ *  a) This file is free software; you can redistribute it and/or
  *     modify it under the terms of the GNU General Public License as
  *     published by the Free Software Foundation; either version 2 of the
  *     License, or (at your option) any later version.
  *
- *     This library is distributed in the hope that it will be useful,
+ *     This file is distributed in the hope that it will be useful,
  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *     GNU General Public License for more details.
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index 05e0526a82d2..1b0f30c2c4a5 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -9,12 +9,12 @@
  * licensing only applies to this file, and not this project as a
  * whole.
  *
- *  a) This library is free software; you can redistribute it and/or
+ *  a) This file is free software; you can redistribute it and/or
  *     modify it under the terms of the GNU General Public License as
  *     published by the Free Software Foundation; either version 2 of the
  *     License, or (at your option) any later version.
  *
- *     This library is distributed in the hope that it will be useful,
+ *     This file is distributed in the hope that it will be useful,
  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *     GNU General Public License for more details.
-- 
2.1.3

