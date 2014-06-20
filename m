Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105AbaFTRYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:24:32 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:46862 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865AbaFTRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:24:31 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2014 13:24:30 EDT
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH v2] MAINTAINERS: add entry for VMware Balloon driver
Date: Fri, 20 Jun 2014 10:14:58 -0700
Message-Id: <1403284498-31144-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

Greg,

I've added Xavier and Philip as official maintainers of the driver, but I've
also kept pv-drivers internal alias as there usually more people watching it.

Thanks,
Dmitry

 MAINTAINERS                |    8 ++++++++
 drivers/misc/vmw_balloon.c |    3 ++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c484ac..d7abd46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9645,6 +9645,14 @@ L:	virtualization@lists.linux-foundation.org
 S:	Supported
 F:	arch/x86/kernel/cpu/vmware.c
 
+VMWARE BALLOON DRIVER
+M:	Xavier Deguillard <xdeguillard@vmware.com>
+M:	Philip Moltmann <moltmann@vmware.com>
+M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/misc/vmw_balloon.c
+
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Shreyas Bhatewara <sbhatewara@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 2421835..1916174 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -17,7 +17,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Dmitry Torokhov <dtor@vmware.com>
+ * Maintained by:	Xavier Deguillard <xdeguillard@vmware.com>
+ *			Philip Moltmann <moltmann@vmware.com>
  */
 
 /*
-- 
1.7.4.1

