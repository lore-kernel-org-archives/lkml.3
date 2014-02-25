Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaBYMWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:22:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:35456 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaBYMWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:22:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481424919"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCHv2 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
Date: Tue, 25 Feb 2014 14:22:25 +0200
Message-Id: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- Removed the gpio entries from arch/arm/mach-tegra/board-paz00.c

Hi,

I was waiting for the DT support from Chen-Yu before sending these,
but decided it makes no difference when I send them. I'm dropping the
con ID in the second patch because Dan noticed the warning, but of
course it will mean the "gpios" property can be used with DT.

The two last patches just add ACPI IDs for some new Baytrail based
boards.


Heikki Krogerus (5):
  ARM: tegra: remove obsolete gpio entries
  net: rfkill: gpio: remove unused and obsolete platform parameters
  net: rfkill: gpio: remove gpio names
  net: rfkill: gpio: add ACPI ID for GPS module on Lenove Miix2
  net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip

 arch/arm/mach-tegra/board-paz00.c |  4 +---
 include/linux/rfkill-gpio.h       | 10 ----------
 net/rfkill/rfkill-gpio.c          | 40 +++++++++------------------------------
 3 files changed, 10 insertions(+), 44 deletions(-)

-- 
1.9.0.rc3

