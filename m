Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3ARMei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:34:38 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58907 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3ARMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:34:34 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 64/76] ARC: Add self to MAINTAINERS
Date: Fri, 18 Jan 2013 17:55:18 +0530
Message-ID: <1358511930-7424-65-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3105c48..05cdc99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7418,6 +7418,12 @@ F:	lib/swiotlb.c
 F:	arch/*/kernel/pci-swiotlb.c
 F:	include/linux/swiotlb.h
 
+SYNOPSYS ARC ARCHITECTURE
+M:	Vineet Gupta <vgupta@synopsys.com>
+L:	linux-snps-arc@vger.kernel.org
+S:	Supported
+F:	arch/arc/
+
 SYSV FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 S:	Maintained
-- 
1.7.4.1

