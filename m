Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaJXBYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:24:24 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:55061 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751595AbaJXBYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:24:23 -0400
From: Feng Kan <fkan@apm.com>
To: catalin.marinas@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 0/7] APM X-Gene SoC platform device tree cleanup
Date: Thu, 23 Oct 2014 18:24:15 -0700
Message-Id: <1414113862-15067-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sums up the dts changes of the recent committed drivers into the kernel.
This will grant PMU, reboot, USB and gpio functionalities to the platform.

Feng Kan (7):
  arm64: dts: Add APM X-Gene USB 2.0 DTS node
  Documentation: arm64: add SCU dts binding documentation to linux
    kernel
  arm64: dts: Add X-Gene reboot driver dts node
  arm64: dts: Add Designware GPIO dts binding to APM X-Gene platform
  arm64: dts: Add APM X-Gene SoC GFC GPIO controller DTS entries
  Documentation: arm: pmu: Add Potenza PMU binding
  arm64: dts: Add PMU node for APM X-Gene Storm SOC

 Documentation/devicetree/bindings/arm/apm/scu.txt | 17 ++++++++
 Documentation/devicetree/bindings/arm/pmu.txt     |  1 +
 arch/arm64/boot/dts/apm-storm.dtsi                | 53 +++++++++++++++++++++++
 3 files changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/apm/scu.txt

-- 
1.9.1

