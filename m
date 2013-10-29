Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3J2MUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:20:33 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9894 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2MUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:20:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Oct 2013 05:20:00 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] clk/power: add clock and power off driver for AS3722
Date: Tue, 29 Oct 2013 17:50:01 +0530
Message-ID: <1383049205-29620-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan (4):
  mfd: as3722: add clock driver as mfd-sub device for the ams AS3722
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

