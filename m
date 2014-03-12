Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaCLNr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:47:26 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44238 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbaCLNrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:47:23 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/3] dt-bindings: document gpio-charger bindings
Date: Wed, 12 Mar 2014 14:46:32 +0100
Message-ID: <2194340.F9etmr5mIo@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <12569216.pGctOhkhxz@phil>
References: <12569216.pGctOhkhxz@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bq.com>

This documents the binding for the gpio-charger power-supply.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
---
 .../bindings/power_supply/gpio-charger.txt         | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/gpio-charger.txt

diff --git a/Documentation/devicetree/bindings/power_supply/gpio-charger.txt b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
new file mode 100644
index 0000000..fad87a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
@@ -0,0 +1,23 @@
+gpio-charger
+
+Required properties :
+ - compatible : "gpio-charger"
+ - gpios : GPIO indicating the charger presence.
+   See GPIO binding in bindings/gpio/gpio.txt .
+ - charger-type : power supply type, one of
+     unknown
+     battery
+     ups
+     mains
+     usb-sdp (USB standard downstream port)
+     usb-dcp (USB dedicated charging port)
+     usb-cdp (USB charging downstream port)
+     usb-aca (USB accessory charger adapter)
+
+Example:
+
+	charger {
+		compatible = "gpio-charger";
+		charger-type = "usb-sdp";
+		gpios = <&gpf0 2 0 0 0>;
+	}
-- 
1.8.5.3


