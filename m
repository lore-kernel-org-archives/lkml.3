Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaLHXFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:05:17 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42778 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaLHXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:05:12 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org
Cc: bpoirier@suse.de, x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 1/2] x86, platform, kconfig: clarify kvmconfig is for kvm
Date: Mon,  8 Dec 2014 15:04:59 -0800
Message-Id: <1418079900-4640-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We'll be adding options for xen as well.

Cc: Josh Triplett <josh@joshtriplett.org>
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
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 scripts/kconfig/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 9645c07..ff612b0 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -141,7 +141,7 @@ help:
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
-	@echo  '  kvmconfig	  - Enable additional options for guest kernel support'
+	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
 	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
 
 # lxdialog stuff
-- 
2.1.1

