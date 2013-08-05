Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3HESFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:05:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3HESFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:05:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 1/3] MAINTAINERS: Remove Jeremy from the Xen subsystem.
Date: Mon,  5 Aug 2013 14:05:35 -0400
Message-Id: <1375725937-22930-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy has been a key person in making Linux work with Xen.
He has been enjoying the last year working on something
different so reflect that in the maintainers file.

CC: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 CREDITS     | 1 +
 MAINTAINERS | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 206d0fc..646a0a9 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1120,6 +1120,7 @@ D: author of userfs filesystem
 D: Improved mmap and munmap handling
 D: General mm minor tidyups
 D: autofs v4 maintainer
+D: Xen subsystem
 S: 987 Alabama St
 S: San Francisco
 S: CA, 94110
diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..440af74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9237,7 +9237,6 @@ F:	drivers/media/tuners/tuner-xc2028.*
 
 XEN HYPERVISOR INTERFACE
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-M:	Jeremy Fitzhardinge <jeremy@goop.org>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
 L:	virtualization@lists.linux-foundation.org
 S:	Supported
-- 
1.8.3.1

