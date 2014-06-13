Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaFMNnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:43:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45953 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750886AbaFMNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:43:35 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
Date: Fri, 13 Jun 2014 15:43:20 +0200
Message-Id: <1402667001-11207-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICPLL can only take 0 or 1, it got mixed with OUT which can be in the [0-3]
range.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9n12.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index d1b82e6635d5..287795985e32 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -132,8 +132,8 @@
 								      <595000000 650000000 3 0>,
 								      <545000000 600000000 0 1>,
 								      <495000000 555000000 1 1>,
-								      <445000000 500000000 1 2>,
-								      <400000000 450000000 1 3>;
+								      <445000000 500000000 2 1>,
+								      <400000000 450000000 3 1>;
 				};
 
 				plladiv: plladivck {
-- 
1.9.1

