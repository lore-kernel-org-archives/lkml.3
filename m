Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaIUO6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 10:58:34 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:47414 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIUO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 10:58:29 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>, yhf@merrii.com, ctl@merrii.com
Subject: [PATCH 5/6] devicetree: bindings: Add vendor prefix for Merrii Technology Co., Ltd.
Date: Sun, 21 Sep 2014 22:58:12 +0800
Message-Id: <1411311493-24344-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411311493-24344-1-git-send-email-wens@csie.org>
References: <1411311493-24344-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merrii Technology Co., Ltd. is a Chinese ARM integration developer that
specializes in Allwinner SoC based designs.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..d3a96ac 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -81,6 +81,7 @@ lltc	Linear Technology Corporation
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
 mediatek	MediaTek Inc.
+merrii	Merrii Technology Co., Ltd.
 micrel	Micrel Inc.
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
-- 
2.1.0

