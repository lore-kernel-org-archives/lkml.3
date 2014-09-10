Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaIJKI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:08:28 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38030 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIJKIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:08:25 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] add basic rk3288 smp support
Date: Wed, 10 Sep 2014 18:05:52 +0800
Message-Id: <1410343554-8383-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 is dual-core CPU Soc, we need to enable the smp.
This patchset works with either arch-timer use the phisical counter
in kernel or the firmware initialize the arch-timer virtual counter
offset and use virtual counter in kernel.


Kever Yang (2):
  ARM: rockchip: add basic smp support for rk3288
  ARM: dts: add intmem node for rk3288 smp support

 arch/arm/boot/dts/rk3288.dtsi    | 18 ++++++++++++
 arch/arm/mach-rockchip/core.h    |  1 +
 arch/arm/mach-rockchip/platsmp.c | 60 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 4 deletions(-)

-- 
1.9.1

