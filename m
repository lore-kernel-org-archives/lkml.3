Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3DXTq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:46:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:15007 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab3DXTo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:44:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,545,1363132800"; 
   d="scan'208";a="21384693"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 5/7] xen/arm: XEN selects ARM_PSCI
Date: Wed, 24 Apr 2013 20:28:13 +0100
Message-ID: <1366831695-13214-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3bdce..344e299 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1892,6 +1892,7 @@ config XEN
 	depends on ARM && AEABI && OF
 	depends on CPU_V7 && !CPU_V6
 	depends on !GENERIC_ATOMIC64
+	select ARM_PSCI
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
-- 
1.7.2.5

