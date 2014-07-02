Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaGBP3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:00 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43820 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGBP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:28:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org
Subject: [PATCH 01/12] mfd: Bunch of clean-ups and checkpatch fixes 
Date: Wed,  2 Jul 2014 16:28:32 +0100
Message-Id: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set contains a bunch of cleanups for issues that were
either noticed during recent patch submission review or that
checkpatch spotted.

 drivers/mfd/88pm805.c             |  2 +-
 drivers/mfd/88pm860x-core.c       | 37 +++++++++++++++++++------------
 drivers/mfd/88pm860x-i2c.c        |  3 ++-
 drivers/mfd/aat2870-core.c        |  5 ++++-
 drivers/mfd/ab3100-core.c         | 54 ++++++++++++++++++--------------------
 drivers/mfd/ab8500-core.c         | 49 ++++++++++++++++++-------------------
 drivers/mfd/ab8500-debugfs.c      | 14 ++++++------
 drivers/mfd/arizona-core.c        |  4 ++--
 drivers/mfd/arizona-i2c.c         |  5 +++--
 drivers/mfd/arizona-spi.c         |  3 ++-
 drivers/mfd/arizona.h             |  4 ++--
 drivers/mfd/intel_soc_pmic_core.c |  2 ++
 drivers/mfd/stmpe-i2c.c           |  4 ++--
 drivers/mfd/stmpe.c               |  2 +-
 drivers/mfd/stmpe.h               |  2 +-
 drivers/mfd/tps65910.c            | 10 +++++-----
 include/linux/mfd/tps65910.h      |  2 +-
 17 files changed, 109 insertions(+), 93 deletions(-)

