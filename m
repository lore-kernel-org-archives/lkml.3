Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbaGWK5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:57:52 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37998 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbaGWKy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:26 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/25] vendor-prefixes: Add prefix for Mediatek Inc.
Date: Wed, 23 Jul 2014 12:53:57 +0200
Message-Id: <1406112847-26275-15-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e..dd5bce8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -77,6 +77,7 @@ lsi	LSI Corp. (LSI Logic)
 lltc	Linear Technology Corporation
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
+mediatek	MediaTek Inc.
 micrel	Micrel Inc.
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
-- 
1.7.9.5

