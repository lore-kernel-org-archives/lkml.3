Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3FFFlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:41:49 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44146 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3FFFlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:41:47 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <csd@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 0/2] ARM dts: bcm281xx: use preprocessor for device trees
Date: Thu,  6 Jun 2013 01:41:33 -0400
Message-Id: <1370497295-12682-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series follows the same approach as taken on Tegra and
OMAP DT files to use the C preprocessor in order to improve
readability. Since bcm281xx does not yet have gpio and pinctrl
support, this series just enables the C preprocessor and removes
the magic constants from existing irq properties. Any new
additions can come in using human readable definitions.

The resulting dtb was diff-tested to validate it versus the non
preprocessed dts version.

Matt Porter (2):
  ARM: dts: bcm281xx: use #include for device tree files
  ARM: dts: bcm281xx: use existing defines for irqs

 arch/arm/boot/dts/bcm11351-brt.dts |    2 +-
 arch/arm/boot/dts/bcm11351.dtsi    |    9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
1.7.9.5

