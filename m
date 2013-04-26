Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3DZMRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:17:33 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62280 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3DZMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:17:32 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/5] various ab8500 fixes
Date: Fri, 26 Apr 2013 14:17:13 +0200
Message-Id: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

this series contains various fixes I found on the current -next ab8500
driver(s).

Patches 1 and 2 are just sparse warning, patch 3 drops reference to a
superseeded driver and last two makes ab8500-sysctrl works again without
an explicit ab8500->sysctrl defined, as it is in current kernel.

Thanks,
Fabio


Fabio Baltieri (5):
  mfd: abx500-core: fix sparse warning
  mfd: ab8500-sysctrl: fix sparse warning
  mfd: ab8500: drop references to ab8500-leds
  mfd: ab8500-sysctrl: set sysctrl_dev during probe
  mfd: ab8500-sysctrl: let sysctrl driver work without pdata

 drivers/mfd/ab8500-core.c    | 13 -------------
 drivers/mfd/ab8500-sysctrl.c |  9 +++++----
 drivers/mfd/abx500-core.c    |  2 +-
 3 files changed, 6 insertions(+), 18 deletions(-)

-- 
1.8.1.3

