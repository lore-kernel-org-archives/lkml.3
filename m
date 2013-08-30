Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3H3BTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:19:40 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34138 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3H3BTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:19:39 -0400
Date: Thu, 29 Aug 2013 18:19:00 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.11
Message-ID: <20130830011900.GA1752@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 30ca2226bea6f0db519dc53381b893cd66cb5b66:

  ARM: tegra: always enable USB VBUS regulators (2013-08-21 21:36:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to f8ab658b5da3fd11893cad085e0e21b67987c10b:

  arm: prima2: drop nr_irqs in mach as we moved to linear irqdomain (2013-08-29 09:48:36 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.11

Two straggling fixes that I had missed as they were posted a couple of
weeks ago, causing problems with interrupts (breaking them completely)
on the CSR SiRF platforms.

----------------------------------------------------------------
Barry Song (2):
      irqchip: sirf: move from legacy mode to linear irqdomain
      arm: prima2: drop nr_irqs in mach as we moved to linear irqdomain

 arch/arm/mach-prima2/common.c |  2 --
 drivers/irqchip/irq-sirfsoc.c | 18 ++++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)
