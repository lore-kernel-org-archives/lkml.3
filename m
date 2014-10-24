Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaJXRxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:53:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55224 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbaJXRwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:52:00 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 0/4] Enable PCI controller for Keystone SoCs
Date: Fri, 24 Oct 2014 13:51:31 -0400
Message-ID: <1414173095-32511-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Keystone PCI driver is merged to v3.18, this patch series
add build options and DTS bindings to enable the driver for Keystone SoCs.

CC : Santosh Shilimkar <santosh.shilimkar@gmail.com>
CC : Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC : Rob Herring <robh+dt@kernel.org>
CC : Pawel Moll <pawel.moll@arm.com>
CC : Mark Rutland <mark.rutland@arm.com>
CC : Ian Campbell <ijc+devicetree@hellion.org.uk>
CC : Kumar Gala <galak@codeaurora.org>
CC : Russell King <linux@arm.linux.org.uk>
CC : devicetree@vger.kernel.org

Murali Karicheri (4):
  ARM: keystone: add pcie related options
  ARM: keystone: defconfig: add options to enable PCI controller
  ARM: keystone: dts: add DT bindings for PCI controller for port 0
  ARM: keystone: dts: add DT bindings for PCI controller for port 1

 arch/arm/boot/dts/k2e.dtsi          |   45 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/keystone.dtsi     |   45 +++++++++++++++++++++++++++++++++++
 arch/arm/configs/keystone_defconfig |    3 +++
 arch/arm/mach-keystone/Kconfig      |    2 ++
 4 files changed, 95 insertions(+)

-- 
1.7.9.5

