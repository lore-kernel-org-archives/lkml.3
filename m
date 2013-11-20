Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3KTH6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:58:46 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52062 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3KTH6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:58:39 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        linux-sh@vger.kernel.org
Date: Wed, 20 Nov 2013 16:59:21 +0900
Message-Id: <20131120075921.23557.23231.sendpatchset@w520>
Subject: [PATCH 00/05] ARM: shmobile: r8a7790 and r8a7791 thermal update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: shmobile: r8a7790 and r8a7791 thermal update

[PATCH 01/05] ARM: shmobile: Add r8a7790 thermal device node to DTS
[PATCH 02/05] ARM: shmobile: Add r8a7790 clocks for thermal devices
[PATCH 03/05] ARM: shmobile: Add r8a7791 thermal device node to DTS
[PATCH 04/05] ARM: shmobile: Add r8a7791 thermal platform device
[PATCH 05/05] ARM: shmobile: Add r8a7791 clocks for thermal devices

Update the thermal support for the r8a7790 and the r8a7791 SoCs. As
usual the code is split between the DT reference code and the legacy
case. The DT reference code is written to be multiplatform aware and
is used to point out the future direction. Hardware support may however
be limited there due to lacking DT bindings.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.12-20131119

 Tested on Lager and Koelsch.

 arch/arm/boot/dts/r8a7790.dtsi         |    7 +++++++
 arch/arm/boot/dts/r8a7791.dtsi         |    7 +++++++
 arch/arm/mach-shmobile/clock-r8a7790.c |    1 +
 arch/arm/mach-shmobile/clock-r8a7791.c |    4 ++++
 arch/arm/mach-shmobile/setup-r8a7791.c |   12 ++++++++++++
 5 files changed, 31 insertions(+)
