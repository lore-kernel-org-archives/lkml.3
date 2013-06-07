Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3FGQLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:11:45 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59366 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3FGQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org
Subject: [PATCH 00/10] regulator: ab8500-ext: Refactorings
Date: Fri,  7 Jun 2013 17:11:18 +0100
Message-Id: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch aims to do the following:

 - Separate the AB8500 External Regulator out from the AB8500 core
   one for added control and reduced complexity
 - Enable the AB8500 External Regulator for Device Tree
 - Ensure EXT3 supplies the AUX regulators with voltage

 arch/arm/boot/dts/dbx5x0.dtsi                 |   28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts                |   14 ++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.c |    4 +---
 drivers/mfd/ab8500-core.c                     |   10 ++++++++++
 drivers/regulator/Makefile                    |    2 +-
 drivers/regulator/ab8500-ext.c                |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/regulator/ab8500.c                    |   20 ++++----------------
 include/linux/regulator/ab8500.h              |    4 ----
 8 files changed, 137 insertions(+), 27 deletions(-)


