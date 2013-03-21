Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3CUQAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:00:00 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42575 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3CUP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:59:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 00/46] Regulators: Bring the AB8500 into the 21st century
Date: Thu, 21 Mar 2013 15:58:57 +0000
Message-Id: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend - rebased onto v3.8-rc3]

Hi Mark,

As requested, the whole-shebang. Hopefully this patch-set is less bitty
and depressing to review now. Honestly, the things I do for you. :)

The Mainline AB8500 and DB8500 regulators are currently stuck in the
Victorian era (AKA v2.6.35). This branch contains all of the
upstreamable changes that have occurred on the internal repository and
aims to bring them back into the 21st century.

This patch-set contains 49 (46 now) of the original 111 patches and has
already gone though multiple (+1) cycles of fixing-up, squashing,
splitting and revert removal. I've also taken out all of the OF, PRCMU
and -debug bits at your request.

Kind regards,
Lee

 arch/arm/mach-ux500/board-mop500-regulators.c |  774 ++++++++++++++++++++++++++---
 arch/arm/mach-ux500/board-mop500-regulators.h |    7 +-
 arch/arm/mach-ux500/board-mop500.c            |    5 +-
 drivers/regulator/Makefile                    |    2 +-
 drivers/regulator/ab8500-ext.c                |  475 ++++++++++++++++++
 drivers/regulator/ab8500.c                    | 2760 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/mfd/abx500/ab8500.h             |   11 +-
 include/linux/regulator/ab8500.h              |  228 ++++++++-
 8 files changed, 3989 insertions(+), 273 deletions(-)

