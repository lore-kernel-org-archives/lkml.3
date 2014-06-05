Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaFER0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:26:48 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37080 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaFER0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:26:44 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 4/7] vendor-prefixes: add prefix for Mediaktek Inc.
Date: Thu,  5 Jun 2014 19:26:18 +0200
Message-Id: <1401989181-4712-5-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401989181-4712-1-git-send-email-matthias.bgg@gmail.com>
References: <1401989181-4712-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index abc3080..73f9e4c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -75,6 +75,7 @@ linux	Linux-specific binding
 lsi	LSI Corp. (LSI Logic)
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
+mediatek	MediaTek Inc.
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 moxa	Moxa
-- 
1.7.9.5

