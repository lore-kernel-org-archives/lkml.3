Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3JaLHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:07:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3JaLHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:07:33 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM List <kvm@vger.kernel.org>
Subject: [PATCH v2] MAINTAINERS: add tree for kvm.git
Date: Thu, 31 Oct 2013 16:29:23 +0530
Message-Id: <1383217163-14555-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM List <kvm@vger.kernel.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 This is a replacement for [PATCH 2/3] Documentation/kvm: patches
 should be against linux.git

 Thanks to Paolo for pointing to the right tree.

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1dd73f7..36b05119 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4836,6 +4836,7 @@ M:	Gleb Natapov <gleb@redhat.com>
 M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://www.linux-kvm.org
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 S:	Supported
 F:	Documentation/*/kvm*.txt
 F:	Documentation/virtual/kvm/
-- 
1.8.5.rc0

