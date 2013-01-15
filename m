Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3AOM42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:28 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61922 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3AOM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:27 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com
Subject: [PATCH 00/26] AB8500 MFD overhaul
Date: Tue, 15 Jan 2013 12:55:40 +0000
Message-Id: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

So, "what the hell is this?" I hear you cry. Well, my team and
I are in the mists of an delta upstreaming torrent. As I'm sure
you've heard, ST-Ericsson's kernel delta is getting pretty big
now. There have been some excellent, interesting changes and
one way or another we need to sync them with Mainline. There is
also a big push to update the internal kernel with Mainline
changes too.

There are ~125 patches in drivers/mfd (lucky you) which are
currently held as delta. I'm hoping to whittle them down a
little, but whichever way you look at it, it's a lot of code.

I'd really appreciate it if you'd allow a little leniency with
regards to this and subsequent patch-sets. Some of the earlier
patches introduce some small issues which are ironed out in
latter patches. Some issues will still exist and the end of the
push, but I have every intention of fixing those once everything
is in. Please feel free to make comments on any
issues that you see, but instead of fixing them up right away,
I'd rather make a list of them and address them at the end, if
they're still present.

Thanks in advance.

Kind regards,
Lee

 drivers/mfd/ab8500-core.c                 |   12 +-
 drivers/mfd/ab8500-debugfs.c              | 1247 +++++++++++++++++++++++++++--
 drivers/mfd/ab8500-gpadc.c                |   90 ++-
 drivers/mfd/ab8500-sysctrl.c              |   93 +++
 drivers/mfd/abx500-core.c                 |   16 +
 drivers/misc/ab8500-pwm.c                 |  282 +++++++
 include/linux/mfd/ab8500/pwmleds.h        |   20 +
 include/linux/mfd/abx500.h                |    2 +
 include/linux/mfd/abx500/ab8500-sysctrl.h |    5 +
 include/linux/mfd/abx500/ab8500.h         |   14 +
 10 files changed, 1697 insertions(+), 84 deletions(-)

