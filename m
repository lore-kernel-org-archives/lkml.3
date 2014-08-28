Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684AbaH1KtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:49:13 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:46768 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936459AbaH1KtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:49:11 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-15.tower-180.messagelabs.com!1409222946!35202325!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <39207063c9b1cf5c6355ea52419834507e5206f7.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 28 Aug 2014 11:49:02 +0100
Subject: [PATCH v2 4/7] iio: da9150: Add DT binding documentation for GPADC
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
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

