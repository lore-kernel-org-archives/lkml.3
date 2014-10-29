Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaJ2Uas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:30:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46517 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaJ2Uaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:30:46 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Subject: [RESEND: PATCH v2 0/4] Enable PCI controller for Keystone SoCs
Date: Wed, 29 Oct 2014 16:30:07 -0400
Message-ID: <1414614607-4872-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Keystone PCI driver is merged to v3.18, this patch series
add build options and DTS bindings to enable the driver for Keystone SoCs.

v2: Some more minor edits based on comments
v1: resend with some minor fix up of the commit description and fixing
    the email ID for Santosh.

CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: devicetree@vger.kernel.org

Murali Karicheri (4):
  ARM: keystone: add pcie related options
  ARM: keystone: defconfig: add options to enable PCI controller
  ARM: dts: keystone: add DT bindings for PCI controller for port 0
  ARM: dts: keystone-k2e: add DT bindings for PCI controller for port 1

 arch/arm/boot/dts/k2e.dtsi          |   45 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/keystone.dtsi     |   45 +++++++++++++++++++++++++++++++++++
 arch/arm/configs/keystone_defconfig |    3 +++
 arch/arm/mach-keystone/Kconfig      |    2 ++
 4 files changed, 95 insertions(+)

-- 
1.7.9.5

