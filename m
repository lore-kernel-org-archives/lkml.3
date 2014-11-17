Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaKQNdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:33:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48564 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679AbaKQNdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:33:15 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, kishon@ti.com, p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, arnd@arndb.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: berlin: let RESET_CONTROLLER be user-selectable
Date: Mon, 17 Nov 2014 14:33:10 +0100
Message-Id: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As asked by Arnd in the Berlin USB thread[1], do not select automatically
RESET_CONTROLLER when using ARCH_BERLIN but let it be user-selectable.

To ensure the Berlin USB PHY driver still works with this change, make it
depending on RESET_CONTROLLER.

Antoine

[1] https://lkml.org/lkml/2014/11/14/415

Antoine Tenart (2):
  phy: berlin_usb: depends on RESET_CONTROLLER
  ARM: berlin: do not select RESET_CONTROLLER

 arch/arm/mach-berlin/Kconfig | 1 -
 drivers/phy/Kconfig          | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
2.1.0

