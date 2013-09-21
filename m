Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3IUNFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 09:05:54 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48284 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3IUNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 09:05:53 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH 0/3]
Date: Sat, 21 Sep 2013 21:05:13 +0800
Message-Id: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fan Rong (3):
  Add smp support for Allwinner A20(sunxi 7i).
  Add cpuconfig nodes in dts for smp configure.
  Add arch count timer node in dts for Allwinner A20(sunxi 7i).

 arch/arm/boot/dts/sun7i-a20.dtsi |  19 ++-
 arch/arm/mach-sunxi/Makefile     |   2 +
 arch/arm/mach-sunxi/headsmp.S    |  12 ++
 arch/arm/mach-sunxi/platform.h   | 347 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/platsmp.c    | 100 +++++++++++
 arch/arm/mach-sunxi/sunxi.c      |  34 +++-
 6 files changed, 511 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platform.h
 create mode 100644 arch/arm/mach-sunxi/platsmp.c

-- 
1.8.1.2

