Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3FFNww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:52:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:40934 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3FFNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:52:50 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Missing pieces for AM335x PWM / backlight support
Date: Thu,  6 Jun 2013 15:52:35 +0200
Message-Id: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.breakpoint.cc/bigeasy/linux.git tags/am335x-pwm

for you to fetch changes up to 6b319b16a27463c93ec36e59458448aae3ab94cd:

  ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk (2013-06-06 14:59:18 +0200)

----------------------------------------------------------------
Collected patches from Philip Avinash to get PWM working on AM335x-evm.
The series includes the TBCLK and device tree entries.

----------------------------------------------------------------
Philip Avinash (4):
      ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
      ARM: dts: AM33XX: Add PWMSS device tree nodes
      ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
      ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk

 arch/arm/boot/dts/am335x-evm.dts      |   23 +++++++++
 arch/arm/boot/dts/am335x-evmsk.dts    |   23 +++++++++
 arch/arm/boot/dts/am33xx.dtsi         |   84 +++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/cclock33xx_data.c |   30 ++++++++++++
 arch/arm/mach-omap2/control.h         |    8 ++++
 5 files changed, 168 insertions(+)

Sebastian
