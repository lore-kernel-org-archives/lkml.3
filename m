Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3DWPDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:03:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56949 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3DWPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:03:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com
Subject: [PATCH 00/10] usb: musb: ux500: pathe the way for Device Tree enablement
Date: Tue, 23 Apr 2013 16:03:04 +0100
Message-Id: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch-set we firstly ease the burden on data being passed from
platform data, then start to build up support to finally enable Device
Tree.

 Documentation/devicetree/bindings/usb/ux500-usb.txt |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dbx5x0.dtsi                       |   31 ++++++++++++++++++++++++++++++-
 arch/arm/mach-ux500/cpu-db8500.c                    |   17 ++---------------
 arch/arm/mach-ux500/usb.c                           |   25 ++++++-------------------
 drivers/usb/musb/ux500.c                            |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/musb/ux500_dma.c                        |   59 +++++++++++++++++++++++++++++++++--------------------------
 include/linux/platform_data/usb-musb-ux500.h        |    5 +----
 7 files changed, 181 insertions(+), 66 deletions(-)


