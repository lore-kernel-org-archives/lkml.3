Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3LETMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:12:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48636 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3LETM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:12:29 -0500
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Thu,  5 Dec 2013 19:12:01 +0000
Message-Id: <1386270722-13962-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] regulator: gpio: Document regulator-type property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 Documentation/devicetree/bindings/regulator/gpio-regulator.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
index 63c659800c03..aaf5f66e66fb 100644
--- a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -10,6 +10,8 @@ Optional properties:
 - gpios			: GPIO group used to control voltage.
 - startup-delay-us	: Startup time in microseconds.
 - enable-active-high	: Polarity of GPIO is active high (default is low).
+- regulator-type	: Specifies what is being regulated, must be either
+			  "voltage" or "current"
 
 Any property defined as part of the core regulator binding defined in
 regulator.txt can also be used.
-- 
1.8.5.1

