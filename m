Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaFFKnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:43:39 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4727 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaFFKnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:43:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 06 Jun 2014 03:38:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@linaro.org>
CC: <mark.rutland@arm.com>, <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: gpio: fix default of regulator-type property
Date: Fri, 6 Jun 2014 16:13:17 +0530
Message-ID: <1402051397-5689-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per driver, the absense of "regulator-type" default to voltage
type. Correct the document to say default is voltage instead of
current.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 Documentation/devicetree/bindings/regulator/gpio-regulator.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
index e5cac1e..dd1ed78 100644
--- a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -13,7 +13,7 @@ Optional properties:
 - startup-delay-us	: Startup time in microseconds.
 - enable-active-high	: Polarity of GPIO is active high (default is low).
 - regulator-type	: Specifies what is being regulated, must be either
-			  "voltage" or "current", defaults to current.
+			  "voltage" or "current", defaults to voltage.
 
 Any property defined as part of the core regulator binding defined in
 regulator.txt can also be used.
-- 
1.8.1.5

