Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3AOCRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:17:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32946 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659Ab3AOCR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:17:29 -0500
Date: Tue, 15 Jan 2013 11:17:21 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lrg@kernel.org
Subject: [GIT PULL] regulator updates for v3.8
Message-ID: <20130115021720.GB5701@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.8-rc3

for you to fetch changes up to e3d5b2f5707b623c9bb5dbff1a02c8b0d48a44b4:

  Merge remote-tracking branch 'regulator/fix/s5m8767' into tmp (2013-01-15 09:38:59 +0900)

----------------------------------------------------------------

regulator: Fixes for 3.8

A few fixes for the regulator subsystems, a few driver specific things
plus a fix for the interaction between regultor_can_change_voltage() and
continuous voltage ranges both of which were added for this release.

----------------------------------------------------------------
Axel Lin (5):
      regulator: core: Fix continuous_voltage_range case in regulator_can_change_voltage
      regulator: core: Fix comment for regulator_register()
      regulator: max8997: Use uV in voltage_map_desc
      regulator: max8998: Use uV in voltage_map_desc
      regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel

Inderpal Singh (1):
      regulator: s5m8767: Fix probe failure due to stack corruption

Mark Brown (4):
      Merge remote-tracking branch 'regulator/fix/core' into tmp
      Merge remote-tracking branch 'regulator/fix/max8997' into tmp
      Merge remote-tracking branch 'regulator/fix/max8998' into tmp
      Merge remote-tracking branch 'regulator/fix/s5m8767' into tmp

 drivers/regulator/core.c    |   15 +++++++++++----
 drivers/regulator/max8997.c |   36 +++++++++++++++++------------------
 drivers/regulator/max8998.c |   44 +++++++++++++++++++++----------------------
 drivers/regulator/s5m8767.c |    4 ++--
 4 files changed, 52 insertions(+), 47 deletions(-)
