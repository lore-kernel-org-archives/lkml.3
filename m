Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3GCPRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:17:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:19265 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab3GCPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:17:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="359990258"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/3] doc: add the description for pci=hide kernel parameter.
Date: Wed,  3 Jul 2013 23:16:17 +0800
Message-Id: <1372864578-6925-2-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2fe6e76..4da0834 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2359,6 +2359,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		pcie_scan_all	Scan all possible PCIe devices.  Otherwise we
 				only look for one device below a PCIe downstream
 				port.
+		hide=		Format: [<domain>:]<bus>:<slot>.<func>[; ...]
+				Specifies devices to hide from pci subsystem.
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
-- 
1.7.9.5

