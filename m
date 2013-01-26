Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3AZAzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:55:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3AZAzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:55:41 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/2] Extend interfaces to access PCIe capabilities registers
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, jiang.liu@huawei.com, mcgrof@qca.qualcomm.com,
        mcgrof@do-not-panic.com, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 17:55:33 -0700
Message-ID: <20130126005533.25808.23022.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a minor extension to Jiang Liu's recent efforts - [PATCH v3
00/32] provide interfaces to access PCIe capabilities registers - which
adds an additional PCI Express accessor for obtaining a device's
Capabilities Register.

Reference: https://lkml.org/lkml/2012/8/1/253
---

Myron Stowe (2):
      PCI: Use PCI Express Capability accessors
      PCI: introduce accessor to retrieve PCIe Capabilities Register


 drivers/pci/access.c            |    4 ++--
 drivers/pci/pcie/portdrv_core.c |    2 +-
 include/linux/pci.h             |   11 ++++++++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

-- 
