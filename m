Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaAFMh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:37:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45524 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbaAFMh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:37:57 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 0/7] DRA7: DT thermal support
Date: Mon, 6 Jan 2014 08:36:44 -0400
Message-ID: <1389011811-13004-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Now that the basic thermal DT support is merged into Rui's tree,
I am resending this series, which introduces the DT node entries
for DRA7 thermal limits representation.

The series adds two thermal zones, to represent IVA and DSPEVE,
respectively. It also adds the support to tmp102 and a corresponding
pcb thermal zone.

There are only cosmetic changes from v1. A couple of spaces and tabulations
have been fixed, and minor changes in sentences present in commit log.
One difference from V1 is the fact that now bandgap is introduced under
OCP, which is also a minor diff.

This patch series has been runtime tested on DRA7-evm.

All best

Eduardo Valentin (7):
  arm: dts: add dra7 DSPEVE thermal data
  arm: dts: add dra7 IVA thermal data
  arm: dts: dra7: add bandgap entry
  arm: dts: add cooling properties on dra7 cpu node
  arm: dts: dra7: add thermal data
  arm: dts: add tmp102 i2c sensor node on dra7-evm
  arm: dts: add thermal zones info on tmp102 for DRA7-EVM

 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi | 28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7-evm.dts             | 22 ++++++++++++++++++++++
 arch/arm/boot/dts/dra7-iva-thermal.dtsi    | 28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7.dtsi                | 26 ++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)
 create mode 100644 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi

-- 
1.8.2.1.342.gfa7285d

