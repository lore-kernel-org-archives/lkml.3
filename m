Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaA2NBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:01:07 -0500
Received: from smtp.citrix.com ([66.165.176.89]:19004 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaA2NBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:01:04 -0500
X-IronPort-AV: E=Sophos;i="4.95,742,1384300800"; 
   d="scan'208";a="97661713"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xen.org>, Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>
Subject: [PATCH REPOST] of: Add vendor prefix for Xen hypervisor
Date: Wed, 29 Jan 2014 13:01:01 +0000
Message-ID: <1391000461-20713-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suppose vendors of virtual hardware ought to be listed here as well.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Stephen Warren <swarren@nvidia>
Cc: devicetree@vger.kernel.org
---
v2: rebased for repost.
---
 Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 3f900cd..a30e3b7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -90,4 +90,5 @@ via	VIA Technologies, Inc.
 winbond Winbond Electronics corp.
 wlf	Wolfson Microelectronics
 wm	Wondermedia Technologies, Inc.
+xen	Xen Hypervisor
 xlnx	Xilinx
-- 
1.7.10.4

