Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3FTMDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:03:23 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27111 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3FTMDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:21 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/7] metag: tz1090: add irq-pdc, pinctrl and gpio to DT
Date: Thu, 20 Jun 2013 13:02:31 +0100
Message-ID: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset, based on and for the metag tree, adds the necessary
device tree nodes and selects the necessary Kconfig symbols in order to
enable the irq-imgpdc, {pinctrl,gpio}-tz1090[-pdc] drivers once they are
accepted and merged.

The first two patches set things up for metag so that we can include
<dt-bindings/*> files from device tree files.

I plan on applying the first two patches soon, and the others after the
corresponding drivers have been accepted into the appropriate trees on
which they depend.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>

James Hogan (7):
  metag: add <dt-bindings/> symlink
  metag: *.dts: include using preprocessor
  metag: tz1090: select and instantiate irq-imgpdc
  metag: tz1090: select and instantiate pinctrl-tz1090
  metag: tz1090: select and instantiate gpio-tz1090
  metag: tz1090: select and instantiate pinctrl-tz1090-pdc
  metag: tz1090: instantiate gpio-tz1090-pdc

 arch/metag/Kconfig.soc                  |  5 ++
 arch/metag/boot/dts/include/dt-bindings |  1 +
 arch/metag/boot/dts/skeleton.dts        |  2 +-
 arch/metag/boot/dts/tz1090.dtsi         | 81 ++++++++++++++++++++++++++++++++-
 arch/metag/boot/dts/tz1090_generic.dts  |  2 +-
 5 files changed, 88 insertions(+), 3 deletions(-)
 create mode 120000 arch/metag/boot/dts/include/dt-bindings

-- 
1.8.1.2


