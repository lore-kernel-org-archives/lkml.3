Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaKFPjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:39:12 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48133 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaKFPjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:39:10 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] documentation: pinctrl bindings: Fix trivial typo 'abitrary'
Date: Thu,  6 Nov 2014 07:38:51 -0800
Message-Id: <1415288331-785-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A misspelled 'arbitrary' propagated to quite a few locations in the DT
binding documentation for pin-controllers. Fixing by:
  git grep abitrary | cut -f1 -d: | xargs sed -i 's/abitrary/arbitrary/'

Reported-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt | 2 +-
 Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt     | 2 +-
 Documentation/devicetree/bindings/pinctrl/lantiq,falcon-pinumx.txt   | 2 +-
 Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt     | 2 +-
 Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt  | 2 +-
 Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt           | 2 +-
 Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt          | 2 +-
 Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt   | 2 +-
 Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt   | 2 +-
 Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt   | 2 +-
 Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt   | 2 +-
 Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt   | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
index a186181c402b..51b943cc9770 100644
--- a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
@@ -9,7 +9,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-TZ1090-PDC's pin configuration nodes act as a container for an abitrary number
+TZ1090-PDC's pin configuration nodes act as a container for an arbitrary number
 of subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
index 4b27c99f7f9d..49d0e6050940 100644
--- a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
@@ -9,7 +9,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-TZ1090's pin configuration nodes act as a container for an abitrary number of
+TZ1090's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/lantiq,falcon-pinumx.txt b/Documentation/devicetree/bindings/pinctrl/lantiq,falcon-pinumx.txt
index daa768956069..ac4da9fe07bd 100644
--- a/Documentation/devicetree/bindings/pinctrl/lantiq,falcon-pinumx.txt
+++ b/Documentation/devicetree/bindings/pinctrl/lantiq,falcon-pinumx.txt
@@ -9,7 +9,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-Lantiq's pin configuration nodes act as a container for an abitrary number of
+Lantiq's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those group(s), and two pin configuration parameters:
diff --git a/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt b/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt
index b5469db1d7ad..e89b4677567d 100644
--- a/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt
+++ b/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt
@@ -9,7 +9,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-Lantiq's pin configuration nodes act as a container for an abitrary number of
+Lantiq's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those group(s), and two pin configuration parameters:
diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
index 61e73cde9ae9..3c8ce28baad6 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
@@ -9,7 +9,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-Tegra's pin configuration nodes act as a container for an abitrary number of
+Tegra's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt
index c596a6ad3285..5f55be59d914 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt
@@ -13,7 +13,7 @@ Optional properties:
 Please refer to pinctrl-bindings.txt in this directory for details of the common
 pinctrl bindings used by client devices.
 
-SiRFprimaII's pinmux nodes act as a container for an abitrary number of subnodes.
+SiRFprimaII's pinmux nodes act as a container for an arbitrary number of subnodes.
 Each of these subnodes represents some desired configuration for a group of pins.
 
 Required subnode-properties:
diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt
index b4480d5c3aca..458615596946 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt
@@ -32,7 +32,7 @@ Required properties:
 Please refer to pinctrl-bindings.txt in this directory for details of the common
 pinctrl bindings used by client devices.
 
-SPEAr's pinmux nodes act as a container for an abitrary number of subnodes. Each
+SPEAr's pinmux nodes act as a container for an arbitrary number of subnodes. Each
 of these subnodes represents muxing for a pin, a group, or a list of pins or
 groups.
 
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
index 2fb90b37aa09..a7bde64798c7 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
@@ -18,7 +18,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-Qualcomm's pin configuration nodes act as a container for an abitrary number of
+Qualcomm's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
index ffafa1990a30..c4ea61ac56f2 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
@@ -47,7 +47,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-The pin configuration nodes act as a container for an abitrary number of
+The pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
index e33e4dcdce79..6e88e91feb11 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
@@ -18,7 +18,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-Qualcomm's pin configuration nodes act as a container for an abitrary number of
+Qualcomm's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
index 93b7de91b9f6..eb8d8aa41f20 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
@@ -47,7 +47,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-The pin configuration nodes act as a container for an abitrary number of
+The pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
index d2ea80dc43eb..e4d6a9d20f7d 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
@@ -18,7 +18,7 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-Qualcomm's pin configuration nodes act as a container for an abitrary number of
+Qualcomm's pin configuration nodes act as a container for an arbitrary number of
 subnodes. Each of these subnodes represents some desired configuration for a
 pin, a group, or a list of pins or groups. This configuration can include the
 mux function to select on those pin(s)/group(s), and various pin configuration
-- 
2.1.3.1.ge241007

