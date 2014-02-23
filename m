Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaBWSBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 13:01:35 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49027 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaBWSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 13:01:09 -0500
From: <vladimir.barinov@cogentembedded.com>
To: <linux-sh@vger.kernel.org>
Cc: <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        <magnus.damm@gmail.com>, <horms@verge.net.au>, <gnurou@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <valentine.barshak@cogentembedded.com>
Subject: [PATCH V4 4/4] ARM: shmobile: koelsch: Add USB and PCI to defconfig
Date: Sun, 23 Feb 2014 22:00:59 +0400
Message-Id: <1393178459-14637-5-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1393178459-14637-1-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1393178459-14637-1-git-send-email-vladimir.barinov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add USB and PCI to koelsch_defconfig

Signed-off-by: <vladimir.barinov@cogentembedded.com>

Changes in V4:
* Added this patch to series

---
 arch/arm/configs/koelsch_defconfig |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: build/arch/arm/configs/koelsch_defconfig
===================================================================
--- build.orig/arch/arm/configs/koelsch_defconfig	2014-02-23 21:47:44.542571966 +0400
+++ build/arch/arm/configs/koelsch_defconfig	2014-02-23 21:48:03.718571572 +0400
@@ -18,6 +18,8 @@
 CONFIG_CPU_BPREDICT_DISABLE=y
 CONFIG_PL310_ERRATA_588369=y
 CONFIG_ARM_ERRATA_754322=y
+CONFIG_PCI=y
+CONFIG_PCI_RCAR_GEN2=y
 CONFIG_SMP=y
 CONFIG_SCHED_MC=y
 CONFIG_NR_CPUS=8
@@ -81,7 +83,19 @@
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
 # CONFIG_HID is not set
-# CONFIG_USB_SUPPORT is not set
+CONFIG_USB_SUPPORT=y
+CONFIG_USB=y
+CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PCI=y
+CONFIG_USB_RENESAS_USBHS_HCD=y
+CONFIG_USB_RENESAS_USBHS=y
+CONFIG_USB_STORAGE=y
+CONFIG_USB_PHY=y
+CONFIG_USB_RCAR_GEN2_PHY=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_RENESAS_USBHS_UDC=y
+CONFIG_USB_ETH=y
 CONFIG_MMC=y
 CONFIG_MMC_SDHI=y
 CONFIG_NEW_LEDS=y
