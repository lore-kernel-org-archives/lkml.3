Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaEIDCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:02:10 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:46207 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaEIDCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:02:07 -0400
From: Fabio Estevam <festevam@gmail.com>
To: robh+dt@kernel.org
Cc: mturquette@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH RESEND] Documentation: clock: fixed-clock: Remove unsupported 'gpios' property
Date: Fri,  9 May 2014 00:01:50 -0300
Message-Id: <1399604510-3043-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Remove the 'gpios' property from the documentation as this is something that the
current fixed clock driver does not handle.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 Documentation/devicetree/bindings/clock/fixed-clock.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
index 48ea0ad..0641a663 100644
--- a/Documentation/devicetree/bindings/clock/fixed-clock.txt
+++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
@@ -12,7 +12,6 @@ Required properties:
 Optional properties:
 - clock-accuracy : accuracy of clock in ppb (parts per billion).
 		   Should be a single cell.
-- gpios : From common gpio binding; gpio connection to clock enable pin.
 - clock-output-names : From common clock binding.
 
 Example:
-- 
1.8.3.2

