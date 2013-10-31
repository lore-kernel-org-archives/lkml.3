Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3JaLI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:08:29 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:48875 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3JaLI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:08:28 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com
Subject: [PATCH] MAINTAINERS: Add git tree for KVM
Date: Thu, 31 Oct 2013 12:08:19 +0100
Message-Id: <1383217699-12777-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fed84d861e7f..366f90cc6fdb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4815,6 +4815,7 @@ M:	Gleb Natapov <gleb@redhat.com>
 M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://www.linux-kvm.org
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 S:	Supported
 F:	Documentation/*/kvm*.txt
 F:	Documentation/virtual/kvm/
-- 
1.8.3.1

