Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBXJaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:30:11 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:42035 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBXJaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:30:08 -0500
From: <vladimir.barinov@cogentembedded.com>
To: <linux-sh@vger.kernel.org>
Cc: <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        <magnus.damm@gmail.com>, <horms@verge.net.au>, <gnurou@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <valentine.barshak@cogentembedded.com>
Subject: [PATCH V5 0/4] ARM: shmobile: koelsch: Add USB support
Date: Mon, 24 Feb 2014 13:30:00 +0400
Message-Id: <1393234204-24096-1-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valentine Barshak <valentine.barshak@cogentembedded.com>

These patch series add the USBHS and PCI USB support to Koelsch board

Changes in V5:
* changed "From" filed to original author
* removed commits dependency, since verified them are in
* get rid from PCI USB on usb0
* moved MAX3355E ID pin check in usbhs probe
* removed CONFIG_USB_RENESAS_USBHS_HCD as not used yet

Changes in V4:
* folded USBHS and internal PCI USB related patches together
* added handling of ID pin from MAX3355E chip
* removed ifdefs
* added USB and PCI to koelsch_defconfig

Changes in V3:
* fixed the USB1 device name in the pinmux table;
* fixed a typo in the "Add internal PCI support" log message.

Changes in V2:
* capitalized ARM in the subject;
* rebased on top the latest devel tag;
* added pipe_type array to the usbhs platform info since it differs from the default.

Valentine Barshak, Vladimir Barinov (4):
  ARM: shmobile: r8a7791: Add USBHS clock support
  ARM: shmobile: r8a7791: Add PCI USB host clock support
  ARM: shmobile: koelsch: Add USBHS and internal PCI USB support
  ARM: shmobile: koelsch: Add USB and PCI to defconfig

---
 arch/arm/configs/koelsch_defconfig     |   15 ++
 arch/arm/mach-shmobile/board-koelsch.c |  172 +++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock-r8a7791.c |    7 +
 3 files changed, 193 insertions(+), 1 deletion(-)
