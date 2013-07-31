Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3GaRns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:43:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11952 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab3GaRm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:42:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Jul 2013 10:42:27 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 0/2] Device tree changes for Tegra30 and Tegra114 USB Host support
Date: Wed, 31 Jul 2013 20:42:21 +0300
Message-ID: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's the device tree changes required for USB Host support on Tegra30 and
Tegra114. This enables USB Host on the Cardhu's dock connector port and on the
single built-in A-ports on Dalmore and Beaver,

Mikko Perttunen (1):
  ARM: dts: USB for Tegra114 Dalmore

Tuomas Tynkkynen (1):
  ARM: DTS: tegra: Add USB entries for Tegra30

 arch/arm/boot/dts/tegra114-dalmore.dts |  9 ++++
 arch/arm/boot/dts/tegra114.dtsi        | 62 ++++++++++++++++++++++++
 arch/arm/boot/dts/tegra30-beaver.dts   | 23 ++++++++-
 arch/arm/boot/dts/tegra30-cardhu.dtsi  |  9 ++++
 arch/arm/boot/dts/tegra30.dtsi         | 86 ++++++++++++++++++++++++++++++++++
 5 files changed, 187 insertions(+), 2 deletions(-)

-- 
1.8.1.5

