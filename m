Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaGUVRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:17:44 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37349 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaGUVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:17:42 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: cooloney@gmail.com, neilb@suse.de, hns@goldelico.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH] Documentation: dts: tcs6507: Fix wrong statement about #gpio-cells
Date: Mon, 21 Jul 2014 23:17:18 +0200
Message-Id: <1405977438-15517-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update comment about gpio-cells which says not correctly to be set to 0.
When we want to reference tca6507 gpio #gpio-cells must be set to 2 (it is
already correct in example).

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/leds/tca6507.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
index d7221b8..bad9102 100644
--- a/Documentation/devicetree/bindings/leds/tca6507.txt
+++ b/Documentation/devicetree/bindings/leds/tca6507.txt
@@ -8,7 +8,7 @@ Required properties:
 
 Optional properties:
 - gpio-controller: allows lines to be used as output-only GPIOs.
-- #gpio-cells: if present, must be 0.
+- #gpio-cells: if present, must not be 0.
 
 Each led is represented as a sub-node of the ti,tca6507 device.
 
-- 
1.9.1

