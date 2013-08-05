Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3HESGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:06:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44285 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3HESFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:05:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3/3] MAINTAINERS: Add in two extra co-maintainers of the Xen tree.
Date: Mon,  5 Aug 2013 14:05:37 -0400
Message-Id: <1375725937-22930-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Boris and David have graciously volunteered to help in
maintaining the Xen subsystem tree. Cementing this in the
MAINTAINERS file so they are copied on Xen related patches.

CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 785f56a..0161dad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9237,6 +9237,8 @@ F:	drivers/media/tuners/tuner-xc2028.*
 
 XEN HYPERVISOR INTERFACE
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+M:	Boris Ostrovsky <boris.ostrovsky@oracle.com>
+M:	David Vrabel <david.vrabel@citrix.com>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/x86/xen/
-- 
1.8.3.1

