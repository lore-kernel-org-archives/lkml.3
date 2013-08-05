Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3HESFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:05:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44293 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3HESFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:05:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stefano.stabellini@eu.citrix.com
Subject: [PATCH 2/3] MAINTAINERS: Update the Xen subsystem's with proper mailing list.
Date: Mon,  5 Aug 2013 14:05:36 -0400
Message-Id: <1375725937-22930-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And also drop the virtualization one since we don't really use it.

CC: stefano.stabellini@eu.citrix.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 440af74..785f56a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9237,8 +9237,7 @@ F:	drivers/media/tuners/tuner-xc2028.*
 
 XEN HYPERVISOR INTERFACE
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
-L:	virtualization@lists.linux-foundation.org
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/x86/xen/
 F:	drivers/*/xen-*front.c
@@ -9249,35 +9248,35 @@ F:	include/uapi/xen/
 
 XEN HYPERVISOR ARM
 M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/arm/xen/
 F:	arch/arm/include/asm/xen/
 
 XEN HYPERVISOR ARM64
 M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/arm64/xen/
 F:	arch/arm64/include/asm/xen/
 
 XEN NETWORK BACKEND DRIVER
 M:	Ian Campbell <ian.campbell@citrix.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/xen-netback/*
 
 XEN PCI SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/x86/pci/*xen*
 F:	drivers/pci/*xen*
 
 XEN SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
-- 
1.8.3.1

