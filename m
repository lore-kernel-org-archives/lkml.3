Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaIEUwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:52:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54096 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIEUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:52:35 -0400
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH V2 0/3] mfd: palmas: add optional wakeup irq
Date: Fri, 5 Sep 2014 15:51:48 -0500
Message-ID: <1409950311-25236-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

V2 of the series based on review conclusion in
https://patchwork.kernel.org/patch/4743321/

based on v3.17-rc1

Wakeup irq is a interrupt path which is provided by the pinctrl
hardware of certain SoCs such as TI's OMAP family of processors that
generates an interrupt for waking up from deep power saving modes.

Nishanth Menon (3):
  Documentation: dt-bindings: mfd: palmas: Fix example style of i2c
    peripheral
  Documentation: dt-bindings: mfd: palmas: document optional wakeup IRQ
  mfd: palmas: Add support for optional wakeup

 Documentation/devicetree/bindings/mfd/palmas.txt |   22 +++++++-
 drivers/mfd/palmas.c                             |   59 ++++++++++++++++++++++
 include/linux/mfd/palmas.h                       |    2 +
 3 files changed, 82 insertions(+), 1 deletion(-)

Regards,
	Nishanth Menon
-- 
1.7.9.5

