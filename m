Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaCGGox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:44:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37883 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaCGGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:44:50 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/7] pinctrl-msm cleanups
Date: Thu,  6 Mar 2014 22:44:39 -0800
Message-Id: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some small fixes and cleanups for the msm pinctrl
driver.

Stephen Boyd (7):
  pinctrl: msm: Silence recursive lockdep warning
  pinctrl: msm: Check for ngpios > MAX_NR_GPIO
  pinctrl: msm: Drop unused includes
  pinctrl: msm: Drop OF_IRQ dependency
  pinctrl: msm: Replace lookup tables with math
  pinctrl: msm: Remove impossible WARN_ON()s
  pinctrl: msm: Simplify msm_config_reg() and callers

 drivers/pinctrl/Kconfig           |  2 +-
 drivers/pinctrl/pinctrl-msm.c     | 73 ++++++++++++++-------------------------
 drivers/pinctrl/pinctrl-msm.h     |  5 +--
 drivers/pinctrl/pinctrl-msm8x74.c |  1 -
 4 files changed, 27 insertions(+), 54 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

