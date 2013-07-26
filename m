Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3GZKEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:04:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15402 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3GZKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:04:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 26 Jul 2013 03:03:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@linaro.org>, <linus.walleij@linaro.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/2] pinctrl: palmas: add pincontrol driver
Date: Fri, 26 Jul 2013 15:45:52 +0530
Message-ID: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the pin control driver for palam device. It add some
common utility APIs in generic pinconf driver.

Laxman Dewangan (2):
  pinctrl: pinconf_generic: add utility functions for add map/configs
  pinctrl: palmas: add pincontrol driver

 .../devicetree/bindings/pinctrl/pinctrl-palmas.txt |   91 ++
 drivers/pinctrl/Kconfig                            |    9 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinconf-generic.c                  |  105 ++
 drivers/pinctrl/pinctrl-palmas.c                   | 1211 ++++++++++++++++++++
 include/linux/mfd/palmas.h                         |   35 +-
 include/linux/pinctrl/pinconf-generic.h            |   52 +
 7 files changed, 1493 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt
 create mode 100644 drivers/pinctrl/pinctrl-palmas.c

