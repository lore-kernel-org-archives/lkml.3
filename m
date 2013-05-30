Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3E3N2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:28:17 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:46986 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab3E3N2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:28:07 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/5] Various DT fixes related to ux500 ASoC driver
Date: Thu, 30 May 2013 15:27:40 +0200
Message-Id: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Lee,

these are various fixes I found while testing the ux500 ASoC driver on HREF
with device-tree.

First two patches are typos in DT files, while the others are
specifically to support ux500 ASoC driver with DT enabled.

The last patch can go in the mfd tree, while the others may safely go
through arm-soc, as there are no build dependencies or regression issues
in general.

Thanks,
Fabio


Fabio Baltieri (5):
  ARM: ux500: Fix trivial typo in v-anamic1 comment
  ARM: ux500: Correct anamic2 typo in DT files
  ARM: ux500: Add DT regulators for ab8500-codec
  ARM: ux500: Provide auxdata to ux500 ASoC driver
  mfd: ab8500-core: Add of_compatible property for ab8500-codec

 arch/arm/boot/dts/dbx5x0.dtsi     | 11 ++++++++---
 arch/arm/boot/dts/href.dtsi       |  2 +-
 arch/arm/boot/dts/hrefv60plus.dts |  2 +-
 arch/arm/boot/dts/snowball.dts    |  2 +-
 arch/arm/mach-ux500/cpu-db8500.c  |  2 ++
 drivers/mfd/ab8500-core.c         |  1 +
 drivers/regulator/ab8500.c        |  8 ++++----
 7 files changed, 18 insertions(+), 10 deletions(-)

-- 
1.8.2

