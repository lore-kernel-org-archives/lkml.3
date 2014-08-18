Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaHRIc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:32:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41448 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaHRIcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:32:55 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v9 0/2] Add Maxim 77802 regulator support
Date: Mon, 18 Aug 2014 10:32:40 +0200
Message-Id: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This series add support for the regulators present in the
Maxim 77802 Power Managment IC. Previously, the series was
part of a bigger one [0] that aimed to add support for all
the devices in the max77802 PMIC. But now the Maxim 77802
PMIC dependencies were already merged for 3.17 so the series
can be split and each driver can go through the relevant tree.

Patch 01/02 adds the driver for the regulators in the Maxim
77802 PMIC and patch 02/02 adds the related DT bindings doc.

I kept the version numbering from the old series so this is
version 9 although there were no changes on the max77802 driver
since v7 of the old series.

The series were tested on an Exynos5420 based Peach Pit board
and applies cleanly to both 3.17-rc1 and today's next-20140818.

Javier Martinez Canillas (2):
  regulator: Add driver for max77802 PMIC PMIC regulators
  regulator: Add DT bindings for max77802 PMIC regulators

 .../devicetree/bindings/regulator/max77802.txt     |  53 ++
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/max77802.c                       | 578 +++++++++++++++++++++
 4 files changed, 641 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/max77802.txt
 create mode 100644 drivers/regulator/max77802.c

Best regards,
Javier
