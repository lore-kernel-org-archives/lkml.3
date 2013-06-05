Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3FEMQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:16:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36442 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3FEMPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:15:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="27976487"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 4/6] arm64/xen: use XEN_IO_PROTO_ABI_ARM on ARM64
Date: Wed, 5 Jun 2013 13:15:28 +0100
Message-ID: <1370434530-22428-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 include/xen/interface/io/protocols.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
index 0eafaf2..056744b 100644
--- a/include/xen/interface/io/protocols.h
+++ b/include/xen/interface/io/protocols.h
@@ -15,7 +15,7 @@
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
 #elif defined(__powerpc64__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
-#elif defined(__arm__)
+#elif defined(__arm__) || defined(__aarch64__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_ARM
 #else
 # error arch fixup needed here
-- 
1.7.2.5

