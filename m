Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaFFXLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:11:20 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57254 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaFFXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:11:18 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: [PATCH 1/3] x86, platform, xen, kconfig: clarify kvmconfig is for kvm
Date: Fri,  6 Jun 2014 16:11:07 -0700
Message-Id: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We'll be adding options for xen as well.

Cc: Borislav Petkov <bp@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: penberg@kernel.org
Cc: levinsasha928@gmail.com
Cc: mtosatti@redhat.com
Cc: fengguang.wu@intel.com
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 33f71b0..37621ac 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -269,5 +269,5 @@ define archhelp
   echo  '                  bzdisk/fdimage*/isoimage also accept:'
   echo  '                  FDARGS="..."  arguments for the booted kernel'
   echo  '                  FDINITRD=file initrd for the booted kernel'
-  echo  '  kvmconfig	- Enable additional options for guest kernel support'
+  echo  '  kvmconfig	- Enable additional options for kvm guest kernel support'
 endef
-- 
2.0.0.rc3.18.g00a5b79

