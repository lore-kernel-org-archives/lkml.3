Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaACJdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:33:20 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60845 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaACJdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:33:17 -0500
Date: Fri, 3 Jan 2014 01:27:49 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20140103092748.GA7872@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6 git tree to receive two fixes prepared for the
v3.13 release:

- Fix build error caused by max17042_battery conversion to the regmap API.

- Fix kernel oops when booting with wakeup_source_activate enabled.

Thank you!

Anton


The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.13-fixes

for you to fetch changes up to 93353e8088057dd988362e6cae727af43734b494:

  max17042_battery: Fix build errors caused by missing REGMAP_I2C config (2013-12-01 14:25:03 -0800)

----------------------------------------------------------------
Austin Boyle (1):
      max17042_battery: Fix build errors caused by missing REGMAP_I2C config

Shuah Khan (1):
      power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate

 drivers/power/Kconfig             |  1 +
 drivers/power/power_supply_core.c | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)
