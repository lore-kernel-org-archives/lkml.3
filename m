Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3FERDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:03:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10229 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab3FERCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:02:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,808,1363132800"; 
   d="scan'208";a="29444474"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 6/6] MAINTAINERS: add myself as arm64/xen maintainer
Date: Wed, 5 Jun 2013 18:02:07 +0100
Message-ID: <1370451727-26826-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306051605030.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306051605030.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..95a6a51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9096,6 +9096,13 @@ S:	Supported
 F:	arch/arm/xen/
 F:	arch/arm/include/asm/xen/
 
+XEN HYPERVISOR ARM64
+M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+S:	Supported
+F:	arch/arm64/xen/
+F:	arch/arm64/include/asm/xen/
+
 XEN NETWORK BACKEND DRIVER
 M:	Ian Campbell <ian.campbell@citrix.com>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
-- 
1.7.2.5

