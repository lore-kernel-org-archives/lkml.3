Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821Ab3DPObZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:31:25 -0400
Received: from vint.altlinux.org ([194.107.17.35]:52022 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934716Ab3DPObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:31:22 -0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Sergey Vlasov <vsu@altlinux.ru>
Subject: [PATCH 2/2] efi: Export efi_query_variable_store() for efivars.ko
Date: Tue, 16 Apr 2013 18:31:09 +0400
Message-Id: <1366122669-20898-2-git-send-email-vsu@altlinux.ru>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
 <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
"x86, efivars: firmware bug workarounds should be in platform code".

Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
---
 arch/x86/platform/efi/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4959e3f..4f364c7 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1144,3 +1144,4 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 
 	return EFI_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
-- 
1.8.1.1

