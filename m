Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3EVL3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:29:49 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61921 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3EVL3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:29:44 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/1] KVM: add kvm_para_available to asm-generic/kvm_para.h
Date: Wed, 22 May 2013 12:29:22 +0100
Message-ID: <1369222162-4857-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_22_12_29_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to include/uapi/linux/kvm_para.h architectures should define
kvm_para_available, so add an implementation to asm-generic/kvm_para.h
which just returns false.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/kvm_para.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
index 9d96605..fa25bec 100644
--- a/include/asm-generic/kvm_para.h
+++ b/include/asm-generic/kvm_para.h
@@ -18,4 +18,9 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+static inline bool kvm_para_available(void)
+{
+	return false;
+}
+
 #endif
-- 
1.8.1.2


