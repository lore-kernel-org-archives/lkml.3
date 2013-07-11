Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab3GKOa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:30:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab3GKO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergey Vlasov <vsu@altlinux.ru>, Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 91/98] efi: Export efi_query_variable_store() for efivars.ko
Date: Thu, 11 Jul 2013 15:25:01 +0100
Message-Id: <1373552708-15235-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Vlasov <vsu@altlinux.ru>

commit 3668011d4ad556224f7c012c1e870a6eaa0e59da upstream.

Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
"x86, efivars: firmware bug workarounds should be in platform code".

Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/platform/efi/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 8bb9f83..b8699b3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -989,3 +989,4 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 
 	return EFI_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
-- 
1.8.1.2

