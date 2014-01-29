Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaA2KDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:03:14 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50514 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaA2KDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:03:12 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH trivial] Documentation: fix multiple typo occurences s/KenelVersion/KernelVersion/
Date: Wed, 29 Jan 2014 11:02:57 +0100
Message-Id: <1390989777-4660-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 Documentation/ABI/testing/configfs-usb-gadget              | 12 ++++++------
 Documentation/ABI/testing/configfs-usb-gadget-acm          |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-ecm          |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-eem          |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-ffs          |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-loopback     |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-mass-storage |  4 ++--
 Documentation/ABI/testing/configfs-usb-gadget-ncm          |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-obex         |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-phonet       |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-rndis        |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-serial       |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-sourcesink   |  2 +-
 Documentation/ABI/testing/configfs-usb-gadget-subset       |  2 +-
 14 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget b/Documentation/ABI/testing/configfs-usb-gadget
index 01e769d6984d..37559a06393b 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget
+++ b/Documentation/ABI/testing/configfs-usb-gadget
@@ -1,13 +1,13 @@
 What:		/config/usb-gadget
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains sub-groups corresponding to created
 		USB gadgets.
 
 What:		/config/usb-gadget/gadget
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		The attributes of a gadget:
@@ -27,7 +27,7 @@ Description:
 
 What:		/config/usb-gadget/gadget/configs
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains a USB gadget's configurations
 
@@ -58,20 +58,20 @@ Description:
 
 What:		/config/usb-gadget/gadget/functions
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains functions available to this USB gadget.
 
 What:		/config/usb-gadget/gadget/strings
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains subdirectories for language-specific
 		strings for this gadget.
 
 What:		/config/usb-gadget/gadget/strings/language
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-acm b/Documentation/ABI/testing/configfs-usb-gadget-acm
index 5708a568b5f6..d21092d75a05 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-acm
+++ b/Documentation/ABI/testing/configfs-usb-gadget-acm
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/acm.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: port_num.
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-ecm b/Documentation/ABI/testing/configfs-usb-gadget-ecm
index 6b9a582ce0b5..0addf7704b4c 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-ecm
+++ b/Documentation/ABI/testing/configfs-usb-gadget-ecm
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/ecm.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-eem b/Documentation/ABI/testing/configfs-usb-gadget-eem
index dbddf36b48b3..a4c57158fcde 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-eem
+++ b/Documentation/ABI/testing/configfs-usb-gadget-eem
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/eem.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-ffs b/Documentation/ABI/testing/configfs-usb-gadget-ffs
index 14343e237e83..e39b27653c65 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-ffs
+++ b/Documentation/ABI/testing/configfs-usb-gadget-ffs
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/ffs.name
 Date:		Nov 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:	The purpose of this directory is to create and remove it.
 
 		A corresponding USB function instance is created/removed.
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-loopback b/Documentation/ABI/testing/configfs-usb-gadget-loopback
index 852b2365a5b5..9aae5bfb9908 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-loopback
+++ b/Documentation/ABI/testing/configfs-usb-gadget-loopback
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/Loopback.name
 Date:		Nov 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
index ad72a37ee9ff..9931fb0d63ba 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
+++ b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/mass_storage.name
 Date:		Oct 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
@@ -13,7 +13,7 @@ Description:
 
 What:		/config/usb-gadget/gadget/functions/mass_storage.name/lun.name
 Date:		Oct 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-ncm b/Documentation/ABI/testing/configfs-usb-gadget-ncm
index bc309f42357d..6fe723effc78 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-ncm
+++ b/Documentation/ABI/testing/configfs-usb-gadget-ncm
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/ncm.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-obex b/Documentation/ABI/testing/configfs-usb-gadget-obex
index aaa5c96fb7c6..a6a9327ed9ba 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-obex
+++ b/Documentation/ABI/testing/configfs-usb-gadget-obex
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/obex.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: port_num.
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-phonet b/Documentation/ABI/testing/configfs-usb-gadget-phonet
index 3e3b742cdfd7..7037a358e6c4 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-phonet
+++ b/Documentation/ABI/testing/configfs-usb-gadget-phonet
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/phonet.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: ifname.
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-rndis b/Documentation/ABI/testing/configfs-usb-gadget-rndis
index 822e6dad8fc0..e32879b84b4d 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-rndis
+++ b/Documentation/ABI/testing/configfs-usb-gadget-rndis
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/rndis.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-serial b/Documentation/ABI/testing/configfs-usb-gadget-serial
index 16f130c1501f..474d249f760b 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-serial
+++ b/Documentation/ABI/testing/configfs-usb-gadget-serial
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/gser.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: port_num.
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-sourcesink b/Documentation/ABI/testing/configfs-usb-gadget-sourcesink
index a30f3093ef6c..29477c319f61 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-sourcesink
+++ b/Documentation/ABI/testing/configfs-usb-gadget-sourcesink
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/SourceSink.name
 Date:		Nov 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-subset b/Documentation/ABI/testing/configfs-usb-gadget-subset
index 154ae597cd99..9373e2c51ea4 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-subset
+++ b/Documentation/ABI/testing/configfs-usb-gadget-subset
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/geth.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
-- 
1.8.3.2

