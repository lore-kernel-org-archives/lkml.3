Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3FNJmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:42:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38901 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3FNJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:42:00 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <vinashphilip@ti.com>
Subject: [PATCH v2 0/4] GPIO DT support for da850
Date: Fri, 14 Jun 2013 15:13:36 +0530
Message-ID: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With conversion of GPIO davinci driver to platform driver, gpio-davinci driver
can support DT boot.
This patch series
- adds dt binding support for gpio-davinci.
- da850 dt support goio.

This patch series is based on Linux 3.10-rc4 and is availabel at [1].

1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4

KV Sujith (3):
  gpio: davinci: DT changes for driver
  ARM: davinci: da850: add GPIO DT entries
  ARM: davinci: da850 evm: add GPIO DT data

Philip Avinash (1):
  ARM: davinci: da850: Use #include for all device trees

 .../devicetree/bindings/gpio/gpio-davinci.txt      |   32 +++++++++++
 arch/arm/boot/dts/da850-enbw-cmc.dts               |    2 +-
 arch/arm/boot/dts/da850-evm.dts                    |   21 +++++++-
 arch/arm/boot/dts/da850.dtsi                       |   17 +++++-
 drivers/gpio/gpio-davinci.c                        |   57 ++++++++++++++++++--
 5 files changed, 123 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt

-- 
1.7.9.5

