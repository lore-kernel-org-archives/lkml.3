Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbaKNAUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:20:16 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:52901 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754365AbaKNAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:20:03 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, =devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V2 0/7] APM X-Gene SoC platform device tree cleanup
Date: Thu, 13 Nov 2014 16:19:54 -0800
Message-Id: <1415924401-3013-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sums up the dts changes of the recent committed drivers into the kernel.
This will grant PMU, reboot, USB and gpio functionalities to the platform.
These patches are all based on existing and approved driver that is in the
kernel tree today.

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

 Documentation/devicetree/bindings/arm/apm/scu.txt | 17 +++++++
 Documentation/devicetree/bindings/arm/pmu.txt     |  1 +
 arch/arm64/boot/dts/apm-storm.dtsi                | 55 +++++++++++++++++++++++
 3 files changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/apm/scu.txt

-- 
1.9.1

