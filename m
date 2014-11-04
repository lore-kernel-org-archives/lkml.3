Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaKDMJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:09:35 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:56611 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaKDMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:09:32 -0500
From: Frank Blaschka <blaschka@linux.vnet.ibm.com>
To: schwidefsky@de.ibm.com
Cc: alex.williamson@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Frank Blaschka <frank.blaschka@de.ibm.com>
Subject: [PATCH linux-next] s390/io: add ioport_map stubs
Date: Tue,  4 Nov 2014 13:09:13 +0100
Message-Id: <1415102953-49643-1-git-send-email-blaschka@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110412-0041-0000-0000-000001F69651
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Blaschka <frank.blaschka@de.ibm.com>

add ioport_map stubs to make vfio build on s390.

Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
---
 arch/s390/include/asm/io.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index cd6b9ee..ba516f8 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -38,6 +38,15 @@ static inline void iounmap(volatile void __iomem *addr)
 {
 }
 
+static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return NULL;
+}
+
+static inline void ioport_unmap(void __iomem *p)
+{
+}
+
 /*
  * s390 needs a private implementation of pci_iomap since ioremap with its
  * offset parameter isn't sufficient. That's because BAR spaces are not
-- 
1.8.5.5

