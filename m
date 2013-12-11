Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3LKXza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:55:30 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61585 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3LKXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:55:27 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Thu, 12 Dec 2013 08:56:16 +0900
Message-Id: <20131211235616.12661.19702.sendpatchset@w520>
Subject: [PATCH v4 00/03] clocksource: Consolidate SH and ARM mach-shmobile Kconfig bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource: Consolidate SH and ARM mach-shmobile Kconfig bits (v4)

[PATCH v4 01/03] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
[PATCH v4 02/03] ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
[PATCH v2 03/03] sh: Remove Kconfig entries for TMU, CMT and MTU2

This is V4 of the SH and ARM mach-shmobile clocksource Kconfig
consolidation series.

By sharing Kconfig entires in drivers/clocksource/Kconfig we
can get rid of duplicated bits that do not belong under arch/.

With this series applied it is possible to build the timer
drivers for CMT, MTU2, TMU and STI in case of SH or ARM. The timer
drivers are automatically selected by default. It is also possible
to select and/or deselect freely when COMPILE_TEST has been selected.

Many thanks to John, Daniel and Arnd for feedback!

Changes since V3:
 - Updated patch 1/3 with more detailed help texts
 - Updated patch 2/3 to fit latest renesas-devel tag, see below
 - Included acks from John Stultz for patch 2/3 and 3/3

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.13-rc2-20131211

 arch/arm/mach-shmobile/Kconfig |   35 +++++++++++++++----------------
 arch/sh/Kconfig                |   21 -------------------
 drivers/clocksource/Kconfig    |   44 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 39 deletions(-)

