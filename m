Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaFRXJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:09:13 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:47138 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbaFRXJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:09:12 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH] MAINTAINERS: add entry for VMware Balloon driver
Date: Wed, 18 Jun 2014 16:09:01 -0700
Message-Id: <1403132941-1394-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 MAINTAINERS                |    6 ++++++
 drivers/misc/vmw_balloon.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c484ac..3a446e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9645,6 +9645,12 @@ L:	virtualization@lists.linux-foundation.org
 S:	Supported
 F:	arch/x86/kernel/cpu/vmware.c
 
+VMWARE BALLOON DRIVER
+M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/misc/vmw_balloon.c
+
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Shreyas Bhatewara <sbhatewara@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 2421835..1a4dc2a 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -17,7 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Dmitry Torokhov <dtor@vmware.com>
+ * Maintained by: pv-drivers@vmware.com
  */
 
 /*
-- 
1.7.4.1

