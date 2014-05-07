Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaEGXJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:09:47 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49394 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaEGXJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:09:43 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/3] Add Rockchip PWM driver
Date: Thu,  8 May 2014 01:08:32 +0200
Message-Id: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the PWM controller found on Rockchip
RK29, RK30 and RK31 SoCs. It is based on the documentation publicly
available [0] and kernel sources from Rockchip [1].

The last patch, which adds device tree nodes in the dts, depends on
the clocks introduced by Heiko in his recent submission of a clk
driver for Rockchip RK3188.

[0] http://dl.radxa.com/rock/docs/hw/ds/Rockchip%20RK30xx%20TRM%20V2.0.pdf
[1] https://github.com/rkchrome/kernel

Beniamino Galvani (3):
  pwm: add Rockchip SoC PWM support
  pwm: rockchip: document device tree bindings
  ARM: dts: rk3xxx: add PWM nodes

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |   17 ++
 arch/arm/boot/dts/rk3188.dtsi                      |   40 +++++
 arch/arm/boot/dts/rk3xxx.dtsi                      |   32 ++++
 drivers/pwm/Kconfig                                |    8 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-rockchip.c                         |  180 ++++++++++++++++++++
 6 files changed, 278 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
 create mode 100644 drivers/pwm/pwm-rockchip.c

-- 
1.7.10.4

