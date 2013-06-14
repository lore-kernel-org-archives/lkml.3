Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3FNR5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:57:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3FNR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:57:19 -0400
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 2/3] msm fixes for 3.11
Date: Fri, 14 Jun 2013 10:56:55 -0700
Message-Id: <1371232615-30731-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
References: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-for-3.11

for you to fetch changes up to 7ba655fc965b073292349fa49fb9d16d701185bc:

  gpio: msm-v1: Remove errant __devinit to fix compile (2013-06-12 14:49:06 -0700)

----------------------------------------------------------------
Some minor fixes for MSM for 3.11

I don't expect these to be necessary for stable, since the fixes are
to recently added code.  The strncpy fix is only in debug code that
isn't normally compiled or used (and is being removed in upcoming
patches).

----------------------------------------------------------------
Chen Gang (1):
      arch: arm: mach-msm: using strlcpy instead of strncpy

Stephen Boyd (3):
      ARM: dts: msm: Fix bad register addresses
      mfd: ssbi: Add MODULE_DEVICE_TABLE
      gpio: msm-v1: Remove errant __devinit to fix compile

 arch/arm/boot/dts/msm8660-surf.dts | 4 ++--
 arch/arm/boot/dts/msm8960-cdp.dts  | 2 +-
 arch/arm/mach-msm/clock-debug.c    | 2 +-
 drivers/gpio/gpio-msm-v1.c         | 2 +-
 drivers/ssbi/ssbi.c                | 1 +
 5 files changed, 6 insertions(+), 5 deletions(-)
