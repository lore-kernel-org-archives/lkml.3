Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbaJUOZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:25:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58208 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbaJUOY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:24:58 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>,
        <devicetree@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Update entry for omap related .dts files to cover new SoCs
Date: Tue, 21 Oct 2014 09:24:22 -0500
Message-ID: <1413901462-32181-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRA7(including AM5x) and AM47x series are handled under OMAP umbrella.
These SoC support and dts have been added since 3.14 kernel and Pull
requests for these have come in from OMAP till date.

So just ensure that get_maintainers can pick up this list as well.

Cc: Benoît Cousson <bcousson@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a20df9b..e205bd2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6585,6 +6585,9 @@ L:	devicetree@vger.kernel.org
 S:	Maintained
 F:	arch/arm/boot/dts/*omap*
 F:	arch/arm/boot/dts/*am3*
+F:	arch/arm/boot/dts/*am4*
+F:	arch/arm/boot/dts/*am5*
+F:	arch/arm/boot/dts/*dra7*
 
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
-- 
1.7.9.5

