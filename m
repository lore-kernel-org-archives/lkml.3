Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3GDJKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:10:38 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8313 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3GDJKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:10:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 04 Jul 2013 02:10:15 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <acourbot@nvidia.com>, <linux@arm.linux.org.uk>
CC: <MLongnecker@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/2] Enable lm90 in Tegra30 and Tegra114.
Date: Thu, 4 Jul 2013 17:09:37 +0800
Message-ID: <1372928979-26938-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable thermal sensor lm90 for Tegra30 Cardhu and Tegra114 Dalmore.

This series is v1, based on [RFC 1/9] submitted here:
http://thread.gmane.org/gmane.linux.power-management.general/31056

Changes from RFC:
1. Enable it for Tegra114 Dalmore.

Wei Ni (2):
  ARM: dt: t30 cardhu: add dt entry for lm90
  ARM: dt: t114 dalmore: add dt entry for lm90

 arch/arm/boot/dts/tegra114-dalmore.dts |    7 +++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi  |    7 +++++++
 2 files changed, 14 insertions(+)

-- 
1.7.9.5

