Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab3EOMDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:03:51 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:57167 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab3EOMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:03:49 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH -next 00/10] Various updates for ux500 musb and phy drivers
Date: Wed, 15 May 2013 14:03:23 +0200
Message-Id: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

this is another series of updates for the ux500 specific musb drivers.

This mainly upgrade the phy-ab8500-usb driver by adding support for
clock control and new ab8500 variants, with some minor refactoring of
the existing code to better handle those.

Other patches includes some coding style fixes, a patch to enable dma
support in host mode and a small workaround.

These are based on v3.10-rc1, and should merge fine with Lee's dma
patches on ux500-musb. I hope that you could review and take these for
your -next branch.

Thanks,
Fabio


Fabio Baltieri (7):
  usb: musb: various cosmetic fixes on ux500 files
  usb: phy: ab8500-usb: fix phy tuning value select logic
  usb: phy: ab8500-usb: add platform_device_id table
  usb: phy: ab8500-usb: move phy tuning values on separate functions
  usb: phy: ab8500-usb: add flag bits to control driver features
  usb: phy: ab8500-usb: add ab8540 support
  usb: phy: ab8500-usb: add ab9540 support

Mian Yousaf Kaukab (2):
  usb: musb: enable ux500 host side dma support
  usb: phy: ab8500-usb: add transceiver clock control

Sakethram Bommisetti (1):
  usb: phy: ab8500-usb: restart phy during probe

 drivers/usb/musb/musb_host.c     |   8 +-
 drivers/usb/musb/ux500_dma.c     |   6 +-
 drivers/usb/phy/phy-ab8500-usb.c | 846 +++++++++++++++++++++++++++++++++------
 3 files changed, 733 insertions(+), 127 deletions(-)

-- 
1.8.2

