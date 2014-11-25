Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbaKYJhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:37:53 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:65279 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:37:51 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Increase the maximum cpu frequency of rk3288
Date: Tue, 25 Nov 2014 17:37:31 +0800
Message-Id: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum cpu frequency of rk3288 can up to 1.8Ghz, but the vdd_cpu need set
to 1.4v. I've tested these patches on rk3288 evb board.


Chris Zhong (2):
  ARM: dts: rockchip: change the max voltage of cpu to 1.4v
  ARM: dts: rk3288: change the max clk of cpu to 1.8Ghz

 arch/arm/boot/dts/rk3288-evb-rk808.dts | 2 +-
 arch/arm/boot/dts/rk3288.dtsi          | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
1.9.1

