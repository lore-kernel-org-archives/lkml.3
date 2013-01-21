Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3AUGaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:30:14 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54734 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AUGaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:30:13 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: Sekhar Nori <nsekhar@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 0/2] ARM: davinci: da850: add ethernet driver DT support
Date: Mon, 21 Jan 2013 11:59:17 +0530
Message-Id: <1358749759-20517-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch set enables Ethernet support through device tree model.

Patches are available on [1] for testing.

[1] http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/shortlog/refs/heads/da850_dt

Lad, Prabhakar (2):
  ARM: davinci: da850: add DT node for eth0.
  ARM: davinci: da850: add OF_DEV_AUXDATA entry for eth0.

 arch/arm/boot/dts/da850-evm.dts  |    3 +++
 arch/arm/boot/dts/da850.dtsi     |   15 +++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c |    9 ++++++++-
 3 files changed, 26 insertions(+), 1 deletions(-)

-- 
1.7.4.1

