Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaF3P5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:57:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58249 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaF3P5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:47 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/6] regulator: palmas: cleanup and fixes
Date: Mon, 30 Jun 2014 10:57:33 -0500
Message-ID: <1404143859-8160-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	Original thread (v1): http://marc.info/?t=140380766500004&r=1&w=2
This series is based on: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)

This series does a few cleanups to help ensure we dont make typo mistakes and finally provides a fix as attempted by (v1).

Basic cpufreq tests performed on OMAP5uEVM, DRA7-evm, DRA72-evm all of which are palmas variants.

The patches are also available here: https://github.com/nmenon/linux-2.6-playground/commits/broonie-topic-palmas-fixes
		     
Nishanth Menon (6):
  regulator: palmas: Squelch sparse warnings
  regulator: palmas: Rename reg_info to palmas_reg_info
  regulator: palmas: Simplify code by using pointer to palmas_reg_info
  regulator: palmas: Rename palmas_regs_info to
    palmas_generic_regs_info
  regulator: palmas: Simplify code by not indexing regulator_desc
    unnecessarily
  regulator: palmas: Fix SMPS enable/disable/is_enable for tps65917

 drivers/regulator/palmas-regulator.c |  344 ++++++++++++++++------------------
 include/linux/mfd/palmas.h           |    4 +-
 2 files changed, 166 insertions(+), 182 deletions(-)

-- 
1.7.9.5

