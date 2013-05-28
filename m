Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3E1DzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52574 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758850Ab3E1DyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matt Fleming" <matt.fleming@intel.com>,
        "Sergey Vlasov" <vsu@altlinux.ru>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.651567490@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [77/94] efi: Export efi_query_variable_store() for efivars.ko
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Vlasov <vsu@altlinux.ru>

commit 3668011d4ad556224f7c012c1e870a6eaa0e59da upstream.

Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
"x86, efivars: firmware bug workarounds should be in platform code".

Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/platform/efi/efi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -840,3 +840,4 @@ efi_status_t efi_query_variable_store(u3
 
 	return EFI_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(efi_query_variable_store);

