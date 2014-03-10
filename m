Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaCJTRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:17:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51168 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889AbaCJTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:17:36 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 0/8] at91_adc: documentation and device tree cleanups
Date: Mon, 10 Mar 2014 20:17:17 +0100
Message-Id: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch synchronise the documentation with the actual code and correct
the example.

The second patch move the documentation to the correct location (under iio/adc)

The remaining patches correct the device trees that are using the adc, mainly
removing unused properties and making the binding compliant with the ePAPR.

Changes in v3:
 - also remove the useless atmel,adc-clock-rate

Changes in v2:
 - add #address-cells, #size-cells and a reg for each trigger to comply to the
   ePAPR instead of removing the unit-address.
 - also correct the atmel,adc-use-external-triggers property name in the
   documentation and in the device tree that got it wrong.

Alexandre Belloni (8):
  Documentation: dt: iio: improve atmel-adc documentation
  Documentation: dt: iio: move arm/atmel-adc.txt to iio/adc/at91_adc.txt
  ARM: at91/dt: at91-ariag25: remove useless adc properties
  ARM: at91/dt: at91sam9260: remove useless adc properties
  ARM: at91/dt: at91sam9g45: remove useless adc properties
  ARM: at91/dt: at91sam9x5: remove useless adc properties
  ARM: at91/dt: sama5d3: remove useless adc properties
  ARM: at91/dt: at91-cosino: remove useless adc properties

 .../devicetree/bindings/arm/atmel-adc.txt          | 81 ---------------------
 .../devicetree/bindings/iio/adc/at91_adc.txt       | 82 ++++++++++++++++++++++
 arch/arm/boot/dts/at91-ariag25.dts                 |  1 -
 arch/arm/boot/dts/at91-cosino.dtsi                 |  1 -
 arch/arm/boot/dts/at91-cosino_mega2560.dts         |  1 -
 arch/arm/boot/dts/at91sam9260.dtsi                 | 11 +--
 arch/arm/boot/dts/at91sam9g45.dtsi                 | 11 +--
 arch/arm/boot/dts/at91sam9x5.dtsi                  | 13 ++--
 arch/arm/boot/dts/sama5d3.dtsi                     | 13 ++--
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |  1 -
 10 files changed, 108 insertions(+), 107 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/atmel-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/at91_adc.txt

-- 
1.8.3.2

