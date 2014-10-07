Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaJGJgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:36:25 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51248 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaJGJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:36:21 -0400
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
Subject: [PATCH 0/2] init some clock rate from dts for rk3288
Date: Tue,  7 Oct 2014 17:33:56 +0800
Message-Id: <1412674438-26160-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add init rate for PLLs and some bus clock  from dts for rk3288,
add two clock rate of 400M and 500M into rate table for we will use it.


Kever Yang (2):
  clk: rockchip: add 400MHz and 500MHz for rk3288 clock rate
  ARM: dts: enable init rate for clock

 arch/arm/boot/dts/rk3288.dtsi     | 10 ++++++++++
 drivers/clk/rockchip/clk-rk3288.c |  2 ++
 2 files changed, 12 insertions(+)

-- 
1.9.1

