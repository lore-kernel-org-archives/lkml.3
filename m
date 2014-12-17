Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaLQKg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:36:56 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33973 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbaLQKgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:36:21 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-pci@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 0/5] PCI: st: provide support for dw pcie
Date: Wed, 17 Dec 2014 11:34:41 +0100
Message-Id: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_03:2014-12-17,2014-12-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set introduces a STMicroelectronics PCIe controler.
It's based on designware PCIe driver.

Gabriel Fernandez (5):
  ARM: STi: Kconfig update for PCIe support
  PCI: st: Add Device Tree bindings for sti pcie
  PCI: st: Provide support for the sti PCIe controller
  PCI: designware: Add setup bus-related to pcie_host_ops
  PCI: st: disable IO support

 Documentation/devicetree/bindings/pci/st-pcie.txt |  53 ++
 arch/arm/mach-sti/Kconfig                         |   2 +
 drivers/pci/host/Kconfig                          |   5 +
 drivers/pci/host/Makefile                         |   1 +
 drivers/pci/host/pci-st.c                         | 736 ++++++++++++++++++++++
 drivers/pci/host/pcie-designware.c                |   3 +
 drivers/pci/host/pcie-designware.h                |   1 +
 7 files changed, 801 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/st-pcie.txt
 create mode 100644 drivers/pci/host/pci-st.c

-- 
1.9.1

