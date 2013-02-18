Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3BRQJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:09:07 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33425 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab3BRQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:08:11 -0500
From: Andy King <acking@vmware.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: davem@davemloft.net, pv-drivers@vmware.com, kraxel@redhat.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 3/4] VSOCK: Remove hypervisor-only socket option
Date: Mon, 18 Feb 2013 08:04:12 -0800
Message-Id: <1361203453-1347-4-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361203453-1347-1-git-send-email-acking@vmware.com>
References: <1361203453-1347-1-git-send-email-acking@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hypervisor-only socket option.

Reported-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>
---
 include/uapi/linux/vm_sockets.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index f7f2e99..df91301 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -52,14 +52,6 @@
 
 #define SO_VM_SOCKETS_PEER_HOST_VM_ID 3
 
-/* Option name for socket's service label.  Use as the option name in
- * setsockopt(3) or getsockopt(3) to set or get the service label for a socket.
- * The service label is a C-style NUL-terminated string.  Only available for
- * hypervisor endpoints.
- */
-
-#define SO_VM_SOCKETS_SERVICE_LABEL 4
-
 /* Option name for determining if a socket is trusted.  Use as the option name
  * in getsockopt(3) to determine if a socket is trusted.  The value is a
  * signed integer.
-- 
1.7.4.1

