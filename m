Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaDNHNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:13:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaDNHMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:12:36 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 0/2] Phase out pci_enable_msi_block()
Date: Mon, 14 Apr 2014 09:14:05 +0200
Message-Id: <cover.1397458024.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is against 3.15-rc1.

This update obsoletes pci_enable_msi_block() function in
favor of pci_enable_msi_range() and pci_enable_msi_exact().


Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-pci@vger.kernel.org


Alexander Gordeev (2):
  GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()
  PCI/MSI: Phase out pci_enable_msi_block()

 drivers/misc/genwqe/card_utils.c |    2 +-
 drivers/pci/msi.c                |   79 ++++++++++++++++----------------------
 include/linux/pci.h              |    5 +--
 3 files changed, 35 insertions(+), 51 deletions(-)

-- 
1.7.7.6

