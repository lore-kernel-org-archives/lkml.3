Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3HNFBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:01:33 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40427 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3HNFBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:01:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.4
To: torvalds@linux-foundation.org
Message-ID: <20130814050125.4443.74523@quantum>
Subject: [GIT PULL] clk: fixes for 3.11-rc6
Date: Tue, 13 Aug 2013 22:01:25 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to a701fe3851d9c7f6bd27bc0b92ca1668a42c8406:

  clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the Exynos4x12 ISP clocks (2013-08-13 10:01:56 -0700)

----------------------------------------------------------------
Two small fixes for the Zynq clock controller introduced in 3.11-rc1 and
another Exynos clock patch which fixes a regression that prevents the
video pipeline from functioning on that platform.

----------------------------------------------------------------
Soren Brinkmann (2):
      clk/zynq/clkc: Add dedicated spinlock for the SWDT
      clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes

Sylwester Nawrocki (1):
      clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the Exynos4x12 ISP clocks

 drivers/clk/samsung/clk-exynos4.c | 64 +++++++++++++++++++++------------------
 drivers/clk/zynq/clkc.c           | 13 +++++---
 2 files changed, 42 insertions(+), 35 deletions(-)
