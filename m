Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3EORCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:02:34 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36895 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab3EORCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:02:33 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: take over co-maintainership from Marcelo, fix MAINTAINERS entry
Date: Wed, 15 May 2013 19:02:24 +0200
Message-Id: <1368637344-3354-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As announced last week by Marcelo Tosatti, I will be co-maintaining
KVM together with Gleb.

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..340cb64 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4641,12 +4641,13 @@ F:	include/linux/sunrpc/
 F:	include/uapi/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
-M:	Marcelo Tosatti <mtosatti@redhat.com>
 M:	Gleb Natapov <gleb@redhat.com>
+M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
-W:	http://kvm.qumranet.com
+W:	http://linux-kvm.org
 S:	Supported
-F:	Documentation/*/kvm.txt
+F:	Documentation/*/kvm*.txt
+F:	Documentation/virtual/kvm/
 F:	arch/*/kvm/
 F:	arch/*/include/asm/kvm*
 F:	include/linux/kvm*
-- 
1.8.1.4

