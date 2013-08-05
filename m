Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3HEHUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:20:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7629 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3HEHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:20:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 05 Aug 2013 00:20:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linus.walleij@linaro.org>
CC: <ian.campbell@citrix.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/3] pinctrl: add pincontrol driver for palmas device.
Date: Mon, 5 Aug 2013 13:03:31 +0530
Message-ID: <1375688014-6117-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1:
- Split the additon of common code into pinctrl-utils and pinconf-generic.
- Use the pinconf-generic APIs for mapping node.
- Use pinconf generic properties to define the Palmas pincontrol nodes.
- Nit and cleanups, typo fixes, rephrasing the sentences etc.
- Use pin specific APIs for setting pin configuration rather than group
  specific.

Laxman Dewangan (3):
  pinctrl: add utility functions for add map/configs
  pinctrl: pinconf-generic: add generic APIs for mapping pinctrl node
  pinctrl: palmas: add pincontrol driver

 .../bindings/pinctrl/pinctrl-bindings.txt          |   16 +
 .../devicetree/bindings/pinctrl/pinctrl-palmas.txt |   97 ++
 drivers/pinctrl/Kconfig                            |   10 +
 drivers/pinctrl/Makefile                           |    3 +-
 drivers/pinctrl/pinconf-generic.c                  |   96 ++
 drivers/pinctrl/pinctrl-palmas.c                   | 1085 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-utils.c                    |  135 +++
 drivers/pinctrl/pinctrl-utils.h                    |   42 +
 include/linux/mfd/palmas.h                         |   35 +-
 include/linux/pinctrl/pinconf-generic.h            |    6 +
 10 files changed, 1513 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt
 create mode 100644 drivers/pinctrl/pinctrl-palmas.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.h

