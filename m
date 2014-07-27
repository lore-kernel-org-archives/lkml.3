Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaG0MW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 08:22:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaG0MWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 08:22:24 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH 0/3] ARM: EXYNOS: Fix Exynos5410 boot
Date: Sun, 27 Jul 2014 14:22:02 +0200
Message-Id: <1406463725-4208-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This mini-series unbreaks booting on 5410 based ODROID-XU.

Since I do not have access to a TRM, the address is a guess based on 
5250 and 5410. Such a node was not present in the 3.14 downstream tree.

Regards,
Andreas

Andreas Färber (3):
  Documentation: devicetree: Document exynos5410 PMU
  ARM: dts: exynos: Add PMU to Exynos5410
  ARM: EXYNOS: Add support for Exynos5410 PMU

 Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
 arch/arm/boot/dts/exynos5410.dtsi                     | 5 +++++
 arch/arm/mach-exynos/exynos.c                         | 1 +
 3 files changed, 7 insertions(+)

-- 
1.9.3

