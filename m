Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbaKMNVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:21:14 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44338 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbaKMNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:21:11 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>, devicetree@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [RFC PATCH 0/2] add dts property to force update a clock setting
Date: Thu, 13 Nov 2014 21:20:24 +0800
Message-Id: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we assgined a clock rate in dts, we may need to update
the clock setting like PLLs who can get the same output rate with
different parameter even if we don't need to change the rate.


Kever Yang (2):
  clk: add property for force to update clock setting
  dt-bindings: clk: add document for assigned-clock-force-rates usage

 .../devicetree/bindings/clock/clock-bindings.txt   |  7 +++--
 drivers/clk/clk-conf.c                             | 33 +++++++++++++++++++++-
 2 files changed, 37 insertions(+), 3 deletions(-)

-- 
1.9.1

