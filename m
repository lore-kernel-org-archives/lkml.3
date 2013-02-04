Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3BDLzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:55:51 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:37845 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BDLzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 00/73 v2] Regulators: Bring the AB8500 into the 20th century
Date: Mon,  4 Feb 2013 11:53:15 +0000
Message-Id: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

As requested, the whole-shebang.

The Mainline AB8500 and DB8500 regulators are currently stuck in the
Victorian era (AKA v2.6.35). This branch contains all of the
upstreamable changes that have occurred on the internal repository and
aims to bring them back into the 20th century.

This patch-set contains 73 of the original 111 patches and has already
gone though multiple cycles of fixing-up, squashing, splitting and
revert removal. I've also taken out all of the OF and -debug bits at
your request.

 arch/arm/mach-ux500/board-mop500-regulators.c |  730 ++++++-
 arch/arm/mach-ux500/board-mop500-regulators.h |    7 +-
 arch/arm/mach-ux500/board-mop500.c            |    5 +-
 drivers/regulator/Kconfig                     |    8 +
 drivers/regulator/Makefile                    |    1 +
 drivers/regulator/ab8500-ext.c                |  475 +++++
 drivers/regulator/ab8500.c                    | 2733 +++++++++++++++++++++++--
 drivers/regulator/core.c                      |   37 +
 include/linux/mfd/abx500/ab8500.h             |   11 +-
 include/linux/regulator/ab8500.h              |  228 ++-
 10 files changed, 3988 insertions(+), 247 deletions(-)

Kind regards,
Lee

