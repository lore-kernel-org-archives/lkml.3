Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbaIWXGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:06:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40229 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbaIWXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:06:17 -0400
Date: Tue, 23 Sep 2014 16:06:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] qcom clocks changes for 3.18
Message-ID: <20140923230616.GI10233@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

A smallish pull request for 3.18. The next batch of stuff is
going to require more review from your side (cpufreq, nss, etc.)

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-clocks-for-3.18

for you to fetch changes up to 229fd4a505553c3a475b90e9aa8e452f5d78eb3b:

  clk: qcom: Add support for banked MD RCGs (2014-09-22 15:16:54 -0700)

----------------------------------------------------------------
qcom clock changes for 3.18

Some fixes for the IPQ driver and some code consolidation
and refactoring.

----------------------------------------------------------------
Andy Gross (1):
      clk: qcom: Add IPQ8064 PLL required for USB

Stephen Boyd (3):
      clk: qcom: Consolidate frequency finding logic
      clk: qcom: Add support for setting rates on PLLs
      clk: qcom: Add support for banked MD RCGs

 drivers/clk/qcom/clk-pll.c      |  68 +++++++++++++++++++++++-
 drivers/clk/qcom/clk-pll.h      |  20 +++++++
 drivers/clk/qcom/clk-rcg.c      | 115 +++++++++++++++++++---------------------
 drivers/clk/qcom/clk-rcg.h      |   6 ++-
 drivers/clk/qcom/clk-rcg2.c     |  19 ++-----
 drivers/clk/qcom/common.c       |  16 ++++++
 drivers/clk/qcom/common.h       |   4 ++
 drivers/clk/qcom/gcc-ipq806x.c  |  31 ++++++++++-
 drivers/clk/qcom/mmcc-msm8960.c |  28 +++++++---
 9 files changed, 219 insertions(+), 88 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
