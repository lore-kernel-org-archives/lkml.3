Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaEJJ5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 05:57:15 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57086 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaEJJ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 05:57:13 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, thierry.reding@gmail.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 0/6] usb: host: Cleanup for ioremap'ing hcd memory
Date: Sat, 10 May 2014 15:26:57 +0530
Message-Id: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'usb-next' branch of Greg's usb tree.

devm_ioremap_resource() API is advantageous over devm_ioremap()
and should therefore be preferred to request any ioremap'ed address
for hcd.

Vivek Gautam (6):
  usb: host: ehci-exynos: Use devm_ioremap_resource instead of
    devm_ioremap
  usb: host: ehci-msm: Use devm_ioremap_resource instead of
    devm_ioremap
  usb: host: ehci-mv: Use devm_ioremap_resource instead of devm_ioremap
  usb: host: ehci-spear: Use devm_ioremap_resource instead of
    devm_ioremap
  usb: host: ehci-tegra: Use devm_ioremap_resource instead of
    devm_ioremap
  usb: host: ohci-exynos: Use devm_ioremap_resource instead of
    devm_ioremap

 drivers/usb/host/ehci-exynos.c |    3 +--
 drivers/usb/host/ehci-msm.c    |    3 +--
 drivers/usb/host/ehci-mv.c     |    8 ++------
 drivers/usb/host/ehci-spear.c  |    9 +--------
 drivers/usb/host/ehci-tegra.c  |    3 +--
 drivers/usb/host/ohci-exynos.c |    3 +--
 6 files changed, 7 insertions(+), 22 deletions(-)

-- 
1.7.10.4

