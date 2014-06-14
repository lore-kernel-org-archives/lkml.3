Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbaFNVyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:54:17 -0400
Received: from mout.gmx.net ([212.227.15.18]:53572 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaFNVyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:54:16 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] xen/pvhvm: Fix non-ANSI declaration of xen_has_pv_devices()
Date: Sat, 14 Jun 2014 23:53:26 +0200
Message-Id: <1402782806-7692-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:94lJa+I6ppV5Vlup0GniW2gKi7lVDM2dgnQzX68fqgZeH1v/LK/
 L44IFCCzo3xEk5wkRpRd6kE2ZqmurJBgt5wNM6yEmqs07VGE00LBoN1kbO1F8LVeVduu/Zn
 fK8XItAxtnqyOTTwvQ+ZADfwto6iQbNfnUNn/BtVr0mkKtJosmoWkO3Fn3U6qrcP1zfAXwv
 rJmgnTz+js+Xxa9rCKG5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning "non-ANSI function declaration of function
'xen_has_pv_devices'".

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 arch/x86/xen/platform-pci-unplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index a826171..9586ff3 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -68,7 +68,7 @@ static int check_platform_magic(void)
 	return 0;
 }
 
-bool xen_has_pv_devices()
+bool xen_has_pv_devices(void)
 {
 	if (!xen_domain())
 		return false;
-- 
1.9.1

