Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaKXOB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:01:58 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:62814 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKXOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:01:56 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 1/2] devicetree: add a binding for GPIOs going though a level shifter
Date: Mon, 24 Nov 2014 15:01:35 +0100
Message-Id: <1416837696-28066-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.3
X-Provags-ID: V02:K0:I2NRT3yZgExy3dbJKXAP486Bet0tKvUL8tF/K4CbyGw
 P5AancSstyfqh2FZz8pf6/jLg4aFifHsPj5Chtpy+9RzyFJgBU
 Tpi2RqMTMotKmuuAn3qFYvw7gde+erfBj2QuvNYBqj0Nv1ykoW
 7wg8opqNvBn9JpDyGdpsbhmH33Jn2eSqx5zWc7ubmYWlWyWqYM
 ZOLdwIT1eId+hv/Gg7V+Ine8oA9Cf+ltGQqCAgRuhAfX5UHZDS
 gmfEWD7oTF6jOism8gRAvdwUiaRpLX0EmP0GK7ylOV2NEI1m3l
 KRIwvkn9uwU0ZTrSY1NJHEibDTzQVejsj2M/GdqWCDXz9xuZ5H
 0pu7eAPBbrKDiZIa0UnTYtIjzXeopx+wsICQrKNNVx1qkPbMg6
 waETPBPcDGdLecbDa0ZmB9JrnILLeD73sfkzmKDSRU0tdU+iU7
 N7/kAV5fCzVkkTaNPHoTtdMC4yg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 .../devicetree/bindings/gpio/gpio-level-shifter.txt       | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt b/Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt
new file mode 100644
index 0000000..e108c43
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt
@@ -0,0 +1,15 @@
+GPIO level shifter
+
+This binding allow supporting GPIOs going though a level shifter.
+
+Required properties:
+- compatible : should be "gpio-level-shifter"
+- data-gpios : list of the data GPIO phandles
+- #gpio-cells : should be 2
+- gpio-controller : marks the device node as a GPIO controller
+
+Optional properties:
+- enable-gpio : phandle of the GPIO that control the level shifter enable pin
+- direction-gpio : phandle of the GPIO that control the level shifter direction
+- vcca-supply : phandle of the regulator for side A of the level shifter
+- vccb-supply : phandle of the regulator for side B of the level shifter
-- 
2.1.3

