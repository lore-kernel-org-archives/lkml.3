Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaJJEun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 00:50:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44127 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaJJEul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 00:50:41 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, dkl@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/2] init some clock rate from dts for rk3288
Date: Thu,  9 Oct 2014 21:50:28 -0700
Message-Id: <1412916630-8256-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add init rate for PLLs and some bus clock  from dts for rk3288,
add two clock rate of 400M and 500M into rate table for we will use it.
We need Doug's patch to make "aclk_cpu" get set properly:
	<https://patchwork.kernel.org/patch/5038781/>

Changes in v2:
- change the PLL setting of 400M to meet the constraints of TRM
- add review and test tag
- add some explanation in commit message

Kever Yang (2):
  clk: rockchip: add 400MHz and 500MHz for rk3288 clock rate
  ARM: dts: enable init rate for clock

 arch/arm/boot/dts/rk3288.dtsi     | 10 ++++++++++
 drivers/clk/rockchip/clk-rk3288.c |  2 ++
 2 files changed, 12 insertions(+)

-- 
1.9.1

