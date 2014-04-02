Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbaDBISR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaDBISO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:18:14 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH 0/2] ahci: Tweaks to the driver's PCI function
Date: Wed,  2 Apr 2014 10:19:55 +0200
Message-Id: <cover.1396426390.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The changes are against the latest Linus tree.

Cc: linux-ide@vger.kernel.org

Alexander Gordeev (2):
  ahci: Ensure "MSI Revert to Single Message" mode is not enforced
  ahci: Use pci_enable_msi_exact() instead of pci_enable_msi_range()

 drivers/ata/ahci.c |   25 +++++++++++++++++++++----
 drivers/ata/ahci.h |    1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
1.7.7.6

