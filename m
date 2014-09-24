Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaIXNhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:37:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62687 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIXNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:37:03 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Add clock binding id for rk3288
Date: Wed, 24 Sep 2014 21:36:33 +0800
Message-Id: <1411565795-26966-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add some clock binding id for different modules
that under development and going to send upstream.

This patch also add the clock node in PD_VIDEO.


Kever Yang (2):
  clk: rockchip: add some needed clock binding id for rk3288
  clk: rockchip: use the clock id for nodes init

 drivers/clk/rockchip/clk-rk3288.c      | 79 +++++++++++++++++++---------------
 include/dt-bindings/clock/rk3288-cru.h | 38 +++++++++++++++-
 2 files changed, 82 insertions(+), 35 deletions(-)

-- 
1.9.1

