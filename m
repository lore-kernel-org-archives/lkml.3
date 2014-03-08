Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaCHM7D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:59:03 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:65504 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaCHMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:53:57 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 02/18] staging: usbip: userspace: remove useless libsysfs includes
Date: Sat,  8 Mar 2014 14:53:20 +0200
Message-Id: <1394283216-1277-3-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes useless libsysfs.h includes in various
userspace files.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/src/usbip_attach.c  | 1 -
 drivers/staging/usbip/userspace/src/usbip_detach.c  | 2 --
 drivers/staging/usbip/userspace/src/usbip_network.h | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 0858411..716a79e 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -17,7 +17,6 @@
  */
 
 #include <sys/stat.h>
-#include <sysfs/libsysfs.h>
 
 #include <limits.h>
 #include <stdint.h>
diff --git a/drivers/staging/usbip/userspace/src/usbip_detach.c b/drivers/staging/usbip/userspace/src/usbip_detach.c
index 13308df..05c6d15 100644
--- a/drivers/staging/usbip/userspace/src/usbip_detach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_detach.c
@@ -16,8 +16,6 @@
  * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <sysfs/libsysfs.h>
-
 #include <ctype.h>
 #include <limits.h>
 #include <stdint.h>
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index f19ae19..c1e875c 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -10,7 +10,6 @@
 #endif
 
 #include <sys/types.h>
-#include <sysfs/libsysfs.h>
 
 #include <stdint.h>
 
-- 
1.8.1.2

