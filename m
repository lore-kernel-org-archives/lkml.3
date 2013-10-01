Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3JASdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:33:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3JASdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:33:47 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/7] DRA7: DT thermal support
Date: Tue, 1 Oct 2013 14:32:17 -0400
Message-ID: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

This is a complementary patch series with themal DT support for DRA7.

Although this work depends on the thermal dt parser work [1], I decided
to share it before hand. It also depends on DRA7 DT base port support,
which I fetched from Rajendra's tree [2].

This patch series has been runtime tested on DRA7-evm.

All best,

[1] - https://lkml.org/lkml/2013/9/26/787
[2] - git://github.com/rrnayak/linux.git out-of-tree/dra-integrated-v3

Eduardo Valentin (7):
  arm: dts: add dra7 DSPEVE thermal data
  arm: dts: add dra7 IVA thermal data
  arm: dts: dra7: add bandgap entry
  arm: dts: add cooling properties on dra7 cpu node
  arm: dts: dra7: add thermal data
  arm: dts: add tmp102 i2c sensor node on dra7-evm
  arm: dts: add thermal zones info on tmp102 for DRA7-EVM

 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi | 28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7-evm.dts             | 23 +++++++++++++++++++++++
 arch/arm/boot/dts/dra7-iva-thermal.dtsi    | 28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7.dtsi                | 27 ++++++++++++++++++++++++++-
 4 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi

-- 
1.8.2.1.342.gfa7285d

