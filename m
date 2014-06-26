Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaFZIyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:54:12 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:54106 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbaFZIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:54:10 -0400
Message-ID: <1403772848.22592.8.camel@x220>
Subject: [PATCH] staging: unisys: remove unused macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparmaintainer@unisys.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 10:54:08 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2014 08:54:08.0229 (UTC) FILETIME=[30E26950:01CF911C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros CONFIG_SPAR_GUEST, GUESTDRIVERBUILD, and NOAUTOVERSION are
defined in Makefiles for the Unisys SPAR driver. They are never used.
Remove the lines that define these macros.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only, on top of next-20140626, by fiddling with BROKEN
and setting all CONFIG_UNISYS* options to y.

 drivers/staging/unisys/channels/Makefile     | 2 --
 drivers/staging/unisys/uislib/Makefile       | 3 ---
 drivers/staging/unisys/virthba/Makefile      | 3 ---
 drivers/staging/unisys/virtpci/Makefile      | 3 ---
 drivers/staging/unisys/visorchannel/Makefile | 2 --
 drivers/staging/unisys/visorchipset/Makefile | 2 --
 drivers/staging/unisys/visorutil/Makefile    | 1 -
 7 files changed, 16 deletions(-)

diff --git a/drivers/staging/unisys/channels/Makefile b/drivers/staging/unisys/channels/Makefile
index e60b0aef4dcd..adc184206035 100644
--- a/drivers/staging/unisys/channels/Makefile
+++ b/drivers/staging/unisys/channels/Makefile
@@ -9,5 +9,3 @@ visorchannelstub-y := channel.o chanstub.o
 ccflags-y += -Idrivers/staging/unisys/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include/channels
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-
diff --git a/drivers/staging/unisys/uislib/Makefile b/drivers/staging/unisys/uislib/Makefile
index 6e44d49458f5..08e620d17497 100644
--- a/drivers/staging/unisys/uislib/Makefile
+++ b/drivers/staging/unisys/uislib/Makefile
@@ -12,6 +12,3 @@ ccflags-y += -Idrivers/staging/unisys/visorchipset
 ccflags-y += -Idrivers/staging/unisys/sparstopdriver
 ccflags-y += -Idrivers/staging/unisys/common-spar/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include/channels
-
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-
diff --git a/drivers/staging/unisys/virthba/Makefile b/drivers/staging/unisys/virthba/Makefile
index 632b1c08b975..ba55ae12488e 100644
--- a/drivers/staging/unisys/virthba/Makefile
+++ b/drivers/staging/unisys/virthba/Makefile
@@ -11,6 +11,3 @@ ccflags-y += -Idrivers/staging/unisys/visorchipset
 ccflags-y += -Idrivers/staging/unisys/virtpci
 ccflags-y += -Idrivers/staging/unisys/common-spar/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include/channels
-
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-
diff --git a/drivers/staging/unisys/virtpci/Makefile b/drivers/staging/unisys/virtpci/Makefile
index f9399aabddd1..a26c696219a5 100644
--- a/drivers/staging/unisys/virtpci/Makefile
+++ b/drivers/staging/unisys/virtpci/Makefile
@@ -8,6 +8,3 @@ ccflags-y += -Idrivers/staging/unisys/include
 ccflags-y += -Idrivers/staging/unisys/uislib
 ccflags-y += -Idrivers/staging/unisys/common-spar/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include/channels
-
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-
diff --git a/drivers/staging/unisys/visorchannel/Makefile b/drivers/staging/unisys/visorchannel/Makefile
index f0060be55bc5..e079c96b1cdf 100644
--- a/drivers/staging/unisys/visorchannel/Makefile
+++ b/drivers/staging/unisys/visorchannel/Makefile
@@ -10,5 +10,3 @@ ccflags-y += -Idrivers/staging/unisys/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include/channels
 ccflags-y += -Idrivers/staging/unisys/visorutil
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-
diff --git a/drivers/staging/unisys/visorchipset/Makefile b/drivers/staging/unisys/visorchipset/Makefile
index ead4b9c02715..5071878e57da 100644
--- a/drivers/staging/unisys/visorchipset/Makefile
+++ b/drivers/staging/unisys/visorchipset/Makefile
@@ -14,5 +14,3 @@ ccflags-y += -Idrivers/staging/unisys/common-spar/include
 ccflags-y += -Idrivers/staging/unisys/common-spar/include/channels
 ccflags-y += -Idrivers/staging/unisys/visorutil
 ccflags-y += -Iinclude/generated
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-
diff --git a/drivers/staging/unisys/visorutil/Makefile b/drivers/staging/unisys/visorutil/Makefile
index 3f463888dcec..d871bbb78cef 100644
--- a/drivers/staging/unisys/visorutil/Makefile
+++ b/drivers/staging/unisys/visorutil/Makefile
@@ -8,4 +8,3 @@ visorutil-y := charqueue.o  easyproc.o  periodic_work.o  procobjecttree.o  \
 		memregion_direct.o visorkmodutils.o
 
 ccflags-y += -Idrivers/staging/unisys/include
-ccflags-y += -DCONFIG_SPAR_GUEST -DGUESTDRIVERBUILD -DNOAUTOVERSION
-- 
1.9.3

