Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaKQO4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:56:00 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57167 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaKQOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:55:58 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org, tomeu.vizoso@collabora.com,
        sboyd@codeaurora.org, Kever Yang <kever.yang@rock-chips.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Dmitry Torokhov <dtor@chromium.org>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Jianqun <jay.xu@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 0/2] clk: rockchip: leave npll for DCLK_VOP0(HDMI) only
Date: Mon, 17 Nov 2014 22:55:36 +0800
Message-Id: <1416236138-11010-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support all kinds of frequency requirement for HDMI on rk3288,
we need a PLL that can change rate at run time.

There are some discussion before at [0], I think we can just leave
the npll for HDMI(DCLK_VOP0) used to make it simple.

Comments are welcome.

[0] https://lkml.org/lkml/2014/11/4/58


Kever Yang (2):
  clk: rockchip: leave npll for VOP0 only
  arm: dts: rockchip: select npll as parent of DCLK_VOP0

 arch/arm/boot/dts/rk3288.dtsi     |  2 ++
 drivers/clk/rockchip/clk-rk3288.c | 24 ++++++++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

-- 
1.9.1

