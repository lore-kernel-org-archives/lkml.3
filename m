Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3HGGyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:54:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9869 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab3HGGyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:54:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 23:54:02 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <swarren@wwwdotorg.org>
CC: <linux@roeck-us.net>, <MLongnecker@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/2] Add power control for lm90
Date: Wed, 7 Aug 2013 14:52:36 +0800
Message-ID: <1375858358-15070-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device lm90 can be controlled by the vdd rail.
Add function to power on/off the vdd.
Enable the nct1008 on Tegra114 Dalmore board, and set the vdd-regulator.

Wei Ni (2):
  hwmon: (lm90) Add power control
  ARM: dt: t114 dalmore: add dt entry for nct1008

 arch/arm/boot/dts/tegra114-dalmore.dts |   10 +++++-
 drivers/hwmon/lm90.c                   |   52 ++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)

-- 
1.7.9.5

