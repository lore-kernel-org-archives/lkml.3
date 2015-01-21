Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbbAUPtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:49:00 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.141]:60900 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbbAUPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:47:03 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-16.tower-178.messagelabs.com!1421855219!38980835!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <0305f31b0195454c3fd37bcaa949a7cf4201a8f9.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 21 Jan 2015 15:46:54 +0000
Subject: [PATCH v6 4/7] iio: da9150: Add DT binding documentation for GPADC
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <linux-iio@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
---
 .../devicetree/bindings/iio/adc/da9150-gpadc.txt         | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt

diff --git a/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
new file mode 100644
index 0000000..c07228d
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
@@ -0,0 +1,16 @@
+Dialog Semiconductor DA9150 IIO GPADC bindings
+
+Required properties:
+- compatible: "dlg,da9150-gpadc" for DA9150 IIO GPADC
+- #io-channel-cells: Should be set to <1>
+  (See Documentation/devicetree/bindings/iio/iio-bindings.txt for further info)
+
+For further information on GPADC channels, see device datasheet.
+
+
+Example:
+
+	gpadc: da9150-gpadc {
+		compatible = "dlg,da9150-gpadc";
+		#io-channel-cells = <1>;
+	};
--
1.9.3

