Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaEMRiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:38:02 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:49495 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaEMRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:37:53 -0400
From: stefan@agner.ch
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com, stefan@agner.ch
Subject: [PATCH 0/2] ARM: tegra: initial support for Colibri T30
Date: Tue, 13 May 2014 19:27:37 +0200
Message-Id: <cover.1400001937.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

This patches cooked a while in our repository and is now quite
complete. All is tested on several Colibri T30 modules and
evaluation boards by Marcel and me. The device tree is splitted
into a module part and the carrier board. The former is then
included by the latter (in this case the evaluation board). The
comments "Colibri: " represent the SO-DIMM Pin name as defined
in the Colibri standard, and should be helpful for users
adopting the device tree for other carrier boards.

Stefan Agner (2):
  ARM: tegra: enable MCP251x CAN controller and DS1307 RTC
  ARM: tegra: initial add of Colibri T30

 arch/arm/boot/dts/Makefile                    |   1 +
 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts | 202 ++++++++++++++
 arch/arm/boot/dts/tegra30-colibri.dtsi        | 375 ++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig              |   6 +
 4 files changed, 584 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/tegra30-colibri.dtsi

-- 
1.9.2

