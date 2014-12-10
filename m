Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaLJACV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:02:21 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:54395 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaLJACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:02:14 -0500
X-IronPort-AV: E=Sophos;i="5.07,548,1413270000"; 
   d="scan'208";a="52671738"
From: Ray Jui <rjui@broadcom.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH 0/4] Add PCIe support to Broadcom iProc
Date: Tue, 9 Dec 2014 16:04:27 -0800
Message-ID: <1418169871-19232-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the initial PCIe support for Broadcom iProc family of
SoCs. This driver has been validated with Cygnus and NSP and is expected to
work on other iProc family of SoCs that deploy the same PCIe controller

Ray Jui (4):
  pci: iProc: define Broadcom iProc PCIe binding
  PCI: iproc: Add Broadcom iProc PCIe driver
  ARM: mach-bcm: Enable PCIe support for iProc
  ARM: dts: enable PCIe for Broadcom Cygnus

 .../devicetree/bindings/pci/brcm,iproc-pcie.txt    |   62 ++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   43 +
 arch/arm/boot/dts/bcm958300k.dts                   |    8 +
 arch/arm/mach-bcm/Kconfig                          |    1 +
 drivers/pci/host/Kconfig                           |    9 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pcie-iproc.c                      |  896 ++++++++++++++++++++
 7 files changed, 1020 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
 create mode 100644 drivers/pci/host/pcie-iproc.c

-- 
1.7.9.5

