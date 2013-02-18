Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3BRQIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:08:12 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33414 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab3BRQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:08:08 -0500
From: Andy King <acking@vmware.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: davem@davemloft.net, pv-drivers@vmware.com, kraxel@redhat.com,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 1/4] VSOCK: get rid of EXPORT_SYMTAB
Date: Mon, 18 Feb 2013 08:04:10 -0800
Message-Id: <1361203453-1347-2-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361203453-1347-1-git-send-email-acking@vmware.com>
References: <1361203453-1347-1-git-send-email-acking@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>

This is the default behavior for a looooooong time.

Acked-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 net/vmw_vsock/af_vsock.c       |    2 --
 net/vmw_vsock/vmci_transport.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 54bb7bd..a8efe5a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -76,8 +76,6 @@
  */
 
 #include <linux/types.h>
-
-#define EXPORT_SYMTAB
 #include <linux/bitops.h>
 #include <linux/cred.h>
 #include <linux/init.h>
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index e8a87cf..a70ace8 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -14,8 +14,6 @@
  */
 
 #include <linux/types.h>
-
-#define EXPORT_SYMTAB
 #include <linux/bitops.h>
 #include <linux/cred.h>
 #include <linux/init.h>
-- 
1.7.4.1

