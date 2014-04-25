Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaDYLSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:18:17 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58594 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaDYLSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:18:13 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        kgene.kim@samsung.com, k.debski@samsung.com, jg1.han@samsung.com
Subject: [PATCH 0/2] usb: ehci/ohci-exynos: Move to generic phy framework
Date: Fri, 25 Apr 2014 16:48:01 +0530
Message-Id: <1398424683-20168-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added required support for getting phy-provider from generic phy framework

Based and tested on 'usb-next' branch of Greg's usb tree, with relevant
device tree patches (which i will sending soon).

Patch:
usb: ehci-exynos: Change to use phy provided by the generic phy framework
is the patch from Kamil's usb phy patch-series:
[PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by the generic phy framework
This is reworked for addressing review comments received in mailing list.

Patch:
usb: ohci-exynos: Add facility to use phy provided by the generic phy framework
is also reworked for addressing review comments.

Corresponding changelog for patches mentioned in each patch.

Kamil Debski (1):
  usb: ehci-exynos: Change to use phy provided by the generic phy
    framework

Vivek Gautam (1):
  usb: ohci-exynos: Add facility to use phy provided by the generic phy
    framework

 .../devicetree/bindings/usb/exynos-usb.txt         |   37 ++++++
 drivers/usb/host/ehci-exynos.c                     |  123 ++++++++++++++++++--
 drivers/usb/host/ohci-exynos.c                     |  123 ++++++++++++++++++--
 3 files changed, 263 insertions(+), 20 deletions(-)

-- 
1.7.10.4

