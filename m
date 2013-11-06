Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3KFMTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:19:24 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9080 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3KFMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:19:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Nov 2013 04:14:02 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/5] clk/power: add clock and power off driver for AS3722
Date: Wed, 6 Nov 2013 17:48:18 +0530
Message-ID: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add power off and clock driver for the ams AS3722.

The mfd patches are depends on mfd subtree which can be applied independtly.
The pacthes are created such that clock driver can go in clock tree and power
off driver in power sub tree.

Changes from V1:
- Split the DT doc and driver change in two changes.
- Keeping all other code same as V1.

Laxman Dewangan (5):
  mfd: as3722: add clock driver as mfd-sub device
  mfd: as3722: add DT details for clock support of ams AS3722
  clk: as3722: add clock driver for ams AS3722
  mfd: AS3722: add dt node properties for system power controller
  power: reset: as3722: add power-off driver

 Documentation/devicetree/bindings/mfd/as3722.txt |   18 +++
 drivers/clk/Kconfig                              |    8 +
 drivers/clk/Makefile                             |    1 +
 drivers/clk/clk-as3722.c                         |  166 ++++++++++++++++++++++
 drivers/mfd/as3722.c                             |    3 +
 drivers/power/reset/Kconfig                      |    6 +
 drivers/power/reset/Makefile                     |    1 +
 drivers/power/reset/as3722-poweroff.c            |  101 +++++++++++++
 8 files changed, 304 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-as3722.c
 create mode 100644 drivers/power/reset/as3722-poweroff.c

