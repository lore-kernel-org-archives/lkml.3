Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaEJPDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:03:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806AbaEJPDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:03:48 -0400
Subject: [PATCH v3 13/15] iommu: Remove pci.h
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, Joerg Roedel <joro@8bytes.org>, acooks@gmail.com,
        linux-kernel@vger.kernel.org, linux@horizon.com
Date: Sat, 10 May 2014 09:03:42 -0600
Message-ID: <20140510150342.2997.55320.stgit@bling.home>
In-Reply-To: <20140510145619.2997.429.stgit@bling.home>
References: <20140510145619.2997.429.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The single helper here no longer has any users.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/pci.h |   29 -----------------------------
 1 file changed, 29 deletions(-)
 delete mode 100644 drivers/iommu/pci.h

diff --git a/drivers/iommu/pci.h b/drivers/iommu/pci.h
deleted file mode 100644
index 352d80a..0000000
--- a/drivers/iommu/pci.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
- * Copyright (C) 2013 Red Hat, Inc.
- * Copyright (C) 2013 Freescale Semiconductor, Inc.
- *
- */
-#ifndef __IOMMU_PCI_H
-#define __IOMMU_PCI_H
-
-/* Helper function for swapping pci device reference */
-static inline void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
-{
-	pci_dev_put(*from);
-	*from = to;
-}
-
-#endif  /* __IOMMU_PCI_H */

