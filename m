Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaDQNMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:12:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbaDQNMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:12:08 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v2 0/2] ahci: Tweaks to the driver's PCI function
Date: Thu, 17 Apr 2014 14:13:48 +0200
Message-Id: <cover.1397736364.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- ahci_is_mrsm() open-coded inside ahci_init_interrupt()
	- changelog elaborated

Cc: linux-ide@vger.kernel.org

Alexander Gordeev (2):
  ahci: Ensure "MSI Revert to Single Message" mode is not enforced
  ahci: Use pci_enable_msi_exact() instead of pci_enable_msi_range()

 drivers/ata/ahci.c |   19 ++++++++++++++-----
 drivers/ata/ahci.h |    1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

-- 
1.7.7.6

