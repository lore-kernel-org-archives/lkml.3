Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab3E0MmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:42:11 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:65267 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3E0MmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:42:05 -0400
From: Philippe Begnic <philippe.begnic.st@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        linux-kernel@vger.kernel.org, olivier.clergeaud@st.com,
        philippe.begnic.st@gmail.com, Philippe Begnic <philippe.begnic@st.com>
Subject: [PATCH 0/4] clk, mfd: u8540 clock tree definition
Date: Mon, 27 May 2013 14:41:28 +0200
Message-Id: <1369658492-31358-1-git-send-email-philippe.begnic.st@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Begnic <philippe.begnic@st.com>

Create U8540 clock tree definitions for common clock framework

Philippe Begnic (4):
  clk: ux500: Pass clock base adresses in initcall for u8540 and u9540
  mfd: db8500: Update register definition for u8540 clock
  mfd: db8500: Update BML clock register for db8580
  clk: ux500: Clocks definition for u8540

 arch/arm/mach-ux500/cpu.c                 |    6 +-
 drivers/clk/ux500/u8540_clk.c             |  564 ++++++++++++++++++++++++++++-
 drivers/clk/ux500/u9540_clk.c             |    4 +-
 drivers/mfd/db8500-prcmu.c                |    1 +
 drivers/mfd/dbx500-prcmu-regs.h           |    1 +
 include/linux/mfd/abx500/ab8500-sysctrl.h |    4 +-
 include/linux/mfd/dbx500-prcmu.h          |   12 +
 include/linux/platform_data/clk-ux500.h   |    6 +-
 8 files changed, 587 insertions(+), 11 deletions(-)

-- 
1.7.9.5

