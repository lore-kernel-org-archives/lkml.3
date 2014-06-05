Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaFEEVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFEEVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergey Vlasov <vsu@altlinux.ru>, Matt Fleming <matt.fleming@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 152/214] efi: Export efi_query_variable_store() for efivars.ko
Date: Wed,  4 Jun 2014 21:18:35 -0700
Message-Id: <20140605041700.238106958@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Vlasov <vsu@altlinux.ru>

commit 3668011d4ad556224f7c012c1e870a6eaa0e59da upstream.

Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
"x86, efivars: firmware bug workarounds should be in platform code".

Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -990,3 +990,4 @@ efi_status_t efi_query_variable_store(u3
 
 	return EFI_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(efi_query_variable_store);


