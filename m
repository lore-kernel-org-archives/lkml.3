Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbaGILla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:41:30 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63418 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaGILl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:41:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 0/5] phy: miphy365x: Introduce support for MiPHY365x
Date: Wed,  9 Jul 2014 12:41:09 +0100
Message-Id: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

This patchset is based on the two core patches you sent to the
list which facilitate creating PHYs residing on multi-channel
controllers.  The changes since the last submission centre
around dynamic PHY creation based solely on what is provided via
Device Tree, as requested.  The other review comments have also
been addressed in this set.

Kind regards,
Lee

 .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
 arch/arm/boot/dts/stih416-b2020-revE.dts           |  10 +
 arch/arm/boot/dts/stih416-b2020.dts                |  12 +
 arch/arm/boot/dts/stih416.dtsi                     |  22 +
 drivers/phy/Kconfig                                |  10 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-miphy365x.c                        | 636 +++++++++++++++++++++
 include/dt-bindings/phy/phy-miphy365x.h            |  14 +
 8 files changed, 781 insertions(+)

