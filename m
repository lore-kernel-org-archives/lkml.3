Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaKUCrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:47:25 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46587 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaKUCrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:47:23 -0500
MIME-Version: 1.0
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 20 Nov 2014 20:47:01 -0600
Message-ID: <CAL_JsqJjvtQbAk4iDWDZtU9kvt_Vox7BVO4KsT0UFYSDW5CKzQ@mail.gmail.com>
Subject: [GIT PULL] DeviceTree fixes for 3.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull DT fixes for 3.18.

Rob

The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/devicetree-fixes-for-3.18

for you to fetch changes up to 788ec2fc2ca295a2d929986e95231214ecd8d142:

  of/selftest: Fix testing when /aliases is missing (2014-11-20 15:32:49 +0000)

----------------------------------------------------------------
DeviceTree fixes for 3.18:
- 2 fixes for OF selftest code
- Fix for PowerPC address parsing to disable work-around except on old
  PowerMACs
- Fix a crash when earlycon is enabled, but no device is found
- DT documentation fixes and missing vendor prefixes

All but the doc updates are also for stable.

----------------------------------------------------------------
Antony Pavlov (1):
      devicetree: vendor-prefixes.txt: fix whitespace

Benjamin Herrenschmidt (1):
      of/base: Fix PowerPC address parsing hack

Bjorn Helgaas (1):
      of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Geert Uytterhoeven (1):
      of: Spelling s/stucture/structure/

Grant Likely (2):
      of/selftest: Fix off-by-one error in removal path
      of/selftest: Fix testing when /aliases is missing

Kevin Cernekee (1):
      of: Fix crash if an earlycon driver is not found

Philipp Zabel (1):
      of: Add vendor prefix for Chips&Media, Inc.

Robert Jarzmik (1):
      devicetree: bindings: add sandisk to the vendor prefixes

Soren Brinkmann (1):
      documentation: pinctrl bindings: Fix trivial typo 'abitrary'

bpqw (1):
      devicetree: bindings: Add vendor prefix for Micron Technology, Inc.

 .../bindings/interrupt-controller/interrupts.txt      |  4 ----
 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt       |  2 +-
 .../bindings/pinctrl/img,tz1090-pinctrl.txt           |  2 +-
 .../bindings/pinctrl/lantiq,falcon-pinumx.txt         |  2 +-
 .../bindings/pinctrl/lantiq,xway-pinumx.txt           |  2 +-
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt        |  2 +-
 .../devicetree/bindings/pinctrl/pinctrl-sirf.txt      |  2 +-
 .../devicetree/bindings/pinctrl/pinctrl_spear.txt     |  2 +-
 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt         |  2 +-
 .../bindings/pinctrl/qcom,apq8084-pinctrl.txt         |  2 +-
 .../bindings/pinctrl/qcom,ipq8064-pinctrl.txt         |  2 +-
 .../bindings/pinctrl/qcom,msm8960-pinctrl.txt         |  2 +-
 .../bindings/pinctrl/qcom,msm8974-pinctrl.txt         |  2 +-
 Documentation/devicetree/bindings/vendor-prefixes.txt |  5 ++++-
 drivers/of/address.c                                  | 19 ++++++++++++++++---
 drivers/of/dynamic.c                                  |  2 +-
 drivers/of/fdt.c                                      |  2 +-
 drivers/of/selftest.c                                 | 11 ++++++++---
 18 files changed, 42 insertions(+), 25 deletions(-)
