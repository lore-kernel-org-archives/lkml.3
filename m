Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbbAHAgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:36:10 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:55707 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752385AbbAHAeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:34:36 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V3 0/7] APM X-Gene SoC platform device tree cleanup
Date: Wed,  7 Jan 2015 17:33:31 -0700
Message-Id: <1420677218-30743-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sums up the dts changes of the recent committed drivers into the kernel.
This will grant PMU, reboot, USB and gpio functionalities to the platform.
These patches are all based on existing and approved driver that is in the
kernel tree today.

V3 Changes:
	- add comments regarding usb node
	- change dwgpio node name to gpio

V2 Changes:
        - add dma-coherent attribute for usb node.

Feng Kan (7):
  arm64: dts: Add APM X-Gene USB DTS node
  Documentation: arm64: add SCU dts binding documentation to linux
    kernel
  arm64: dts: Add X-Gene reboot driver dts node
  arm64: dts: Add Designware GPIO dts binding to APM X-Gene platform
  arm64: dts: Add APM X-Gene SoC GFC GPIO controller DTS entries
  Documentation: arm: pmu: Add Potenza PMU binding
  arm64: dts: Add PMU node for APM X-Gene Storm SOC

 Documentation/devicetree/bindings/arm/apm/scu.txt |   17 ++++++
 Documentation/devicetree/bindings/arm/pmu.txt     |    1 +
 arch/arm64/boot/dts/apm/apm-storm.dtsi            |   58 +++++++++++++++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/apm/scu.txt

