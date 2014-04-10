Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473AbaDJHoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:44:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:14121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877AbaDJHoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:44:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,832,1389772800"; 
   d="scan'208";a="510744878"
Message-ID: <1397115837.2105.13.camel@rzhang-toshiba>
Subject: [GIT PULL] thermal management updates for v3.15-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>
Date: Thu, 10 Apr 2014 15:43:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

 git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

to receive thermal management updates for v3.15-rc1
with top-most commit 9477165ec525d47abb1cb6523698e0cd89d65ddb:

  thermal: rcar-thermal: update thermal zone only when temperature
changes

on top of commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14

We only have a couple of fixes/cleanups for platform thermal drivers
this time.

Specifics:

 - rcar thermal driver: avoid updating the thermal zone in case an IRQ
   was triggered but the temperature didn't effectively change.
   From Patrick Titiano.

 - update the imx thermal driver' formula of converting thermal sensor'
   raw date to real temperature in degree C. From Anson Huang.

 - trivial code cleanups of ti soc thermal and rcar thermal driver from
Jingoo Han and Patrick Titiano.

Thanks!

----------------------------------------------------------------
Anson Huang (1):
      thermal: imx: update formula for thermal sensor

Jingoo Han (1):
      thermal: ti-soc-thermal: Use SIMPLE_DEV_PM_OPS macro

Patrick Titiano (2):
      thermal: rcar-thermal: fix same mask applied twice
      thermal: rcar-thermal: update thermal zone only when temperature
changes

 drivers/thermal/imx_thermal.c               | 39
++++++++++++++++++++++++++-------------
 drivers/thermal/rcar_thermal.c              |  9 +++++++--
 drivers/thermal/ti-soc-thermal/ti-bandgap.c |  6 ++----
 3 files changed, 35 insertions(+), 19 deletions(-)



