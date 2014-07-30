Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaG3Nw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:52:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14234 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaG3Nwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:52:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Jul 2014 06:44:33 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH-REPOST] regulator: gpio: fix default of regulator-type property
Date: Wed, 30 Jul 2014 19:21:08 +0530
Message-ID: <1406728268-17725-1-git-send-email-ldewangan@nvidia.com>
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
Seems somehow this is missed for review, reposting it.

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

