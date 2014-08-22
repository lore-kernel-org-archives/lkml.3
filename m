Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaHVN54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:57:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58442 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbaHVN5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:57:15 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/3] ARM: OMAP5+: pdata quirks for pinctrl
Date: Fri, 22 Aug 2014 08:55:22 -0500
Message-ID: <1408715725-25919-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series are various fixes and improvements for daisychain
support in OMAP5+ using pinctrl framework similar to that done for
OMAP3+

This is part 3/6 series which eventually enables framework for
suspend-to-ram and cpuidle for OMAP5 and DRA7

Each of series is based on v3.17-rc1 and this specific series is available:
weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/prm-pdata-quirks

git repo: https://github.com/nmenon/linux-2.6-playground.git push/v3.17/prm-pdata-quirks

An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework

Minor note: thanks to existing style in pdata-quirks, new entries
continue to possess 'over 80 character' checkpatch warnings

Keerthy (1):
  ARM: AM437x: use pdata quirks for pinctrl information

Nishanth Menon (2):
  ARM: OMAP5: use pdata quirks for pinctrl information
  ARM: DRA7: use pdata quirks for pinctrl information

 arch/arm/mach-omap2/pdata-quirks.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
1.7.9.5

