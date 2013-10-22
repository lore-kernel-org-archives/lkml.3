Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JVRHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:07:34 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33034 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3JVRHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:07:32 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH 0/4] Devicetree description for Voipac i.MX53 module
Date: Tue, 22 Oct 2013 19:07:19 +0200
Message-Id: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds devicetree description for Voipac X53-DMM-668 module
which uses i.MX53 CPU. More information about the module may be found at:
http://www.voipac.com/#X53-DMM-668
The support for the baseboard used with this module is also provided.
More information about the baseboard: http://www.voipac.com/#X25-BSB-000

Working peripherals are:
* UART0
* Ethernet
* Buttons (with keyboard controller)
* Sound (headphone output)
* SD-card
* LEDs (through GPIOs)


Rostislav Lisovy (4):
  ARM: dts: i.MX53: Add alternate pinmux option for i2c_3
  ARM: dts: i.MX53: Internal keyboard controller
  ARM: dts: i.MX53: dts for Voipac x53-dmm-668 module
  ARM: dts: i.MX53: Devicetree for Voipac Baseboard using x53-dmm-668
    module

 arch/arm/boot/dts/imx53-voipac-bsb.dts      |  135 +++++++++++++++++++
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi |  195 +++++++++++++++++++++++++++
 arch/arm/boot/dts/imx53.dtsi                |   15 +++
 3 files changed, 345 insertions(+)
 create mode 100644 arch/arm/boot/dts/imx53-voipac-bsb.dts
 create mode 100644 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi

-- 
1.7.10.4

