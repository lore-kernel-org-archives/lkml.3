Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab3KAEEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:04:35 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58932 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3KAEEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:04:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.4
To: torvalds@linux-foundation.org
Message-ID: <20131101040422.11662.99675@quantum>
Subject: [GIT PULL] clk: fixes for 3.12
Date: Thu, 31 Oct 2013 21:04:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 2f9f64bc5aa31836810cd25301aa4772ad73ebab:

  clk: fixup argument order when setting VCO parameters (2013-10-07 23:01:07 -0700)

----------------------------------------------------------------
Dinh Nguyen (1):
      clk: socfpga: Fix incorrect sdmmc clock name

Jonathan Austin (1):
      clk: fixup argument order when setting VCO parameters

Linus Walleij (1):
      clk: nomadik: set all timers to use 2.4 MHz TIMCLK

Simon Guinot (1):
      clk: armada-370: fix tclk frequencies

 drivers/clk/clk-nomadik.c        | 21 +++++++++++++++++++++
 drivers/clk/mvebu/armada-370.c   |  4 ++--
 drivers/clk/socfpga/clk.c        |  2 +-
 drivers/clk/versatile/clk-icst.c |  2 +-
 4 files changed, 25 insertions(+), 4 deletions(-)
