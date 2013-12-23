Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3LWICa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:02:30 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:47880 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752091Ab3LWIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:02:28 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [RFC PATCH 0/3] APM X-Gene PCIe driver
Date: Mon, 23 Dec 2013 13:32:01 +0530
Message-Id: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AppliedMicro X-Gene PCIe host controller. The
driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
cards.

X-Gene PCIe controller driver has depedency on the pcie arch support for
arm64. The arm64 pcie arch support is not yet part of mainline Linux kernel
and approach for arch support is under discussion with arm64 maintainers.
The reference patch can be found here --> https://lkml.org/lkml/2013/10/23/244

If someone wishes to test PCIe on X-Gene, arch support patch must be applied
before the patches in this patch set.

Tanmay Inamdar (3):
  pci: APM X-Gene PCIe controller driver
  arm64: dts: APM X-Gene PCIe device tree nodes
  dt-bindings: pci: xgene pcie device tree bindings

 .../devicetree/bindings/pci/xgene-pcie.txt         |   43 +
 arch/arm64/boot/dts/apm-mustang.dts                |    4 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |  140 +++
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pcie-xgene.c                      | 1017 ++++++++++++++++++++
 6 files changed, 1210 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt
 create mode 100644 drivers/pci/host/pcie-xgene.c

-- 
1.7.9.5

