Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3BFKyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:54:47 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:55825 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3BFKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org
Subject: [PATCH 00/49] Regulators: Bring the AB8500 into the 21st century
Date: Wed,  6 Feb 2013 10:53:22 +0000
Message-Id: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

As requested, the whole-shebang. Hopefully this patch-set is less bitty
and depressing to review now. Honestly, the things I do for you. :)

The Mainline AB8500 and DB8500 regulators are currently stuck in the
Victorian era (AKA v2.6.35). This branch contains all of the
upstreamable changes that have occurred on the internal repository and
aims to bring them back into the 21st century.

This patch-set contains 49 of the original 111 patches and has already
gone though multiple (+1) cycles of fixing-up, squashing, splitting and
revert removal. I've also taken out all of the OF, PRCMU and -debug bits
at your request.

 arch/arm/mach-ux500/board-mop500-regulators.c |  730 ++++++-
 arch/arm/mach-ux500/board-mop500-regulators.h |    7 +-
 arch/arm/mach-ux500/board-mop500.c            |    5 +-
 drivers/regulator/Kconfig                     |    8 +
 drivers/regulator/Makefile                    |    1 +
 drivers/regulator/ab8500-ext.c                |  475 +++++
 drivers/regulator/ab8500.c                    | 2732 +++++++++++++++++++++++--
 include/linux/mfd/abx500/ab8500.h             |   11 +-
 include/linux/regulator/ab8500.h              |  228 ++-
 9 files changed, 3950 insertions(+), 247 deletions(-)

