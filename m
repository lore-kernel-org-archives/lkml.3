Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbbAKX6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:58:19 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47163 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbbAKX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:58:16 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: linux-doc@vger.kernel.org
Cc: Julian Brost <linux-kernel@0x4a42.net>, linux-kernel@vger.kernel.org,
        corbet@lwn.net, tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: [PATCH 1/4] Documentation/misc-devices/mei: Fix formatting of headings.
Date: Mon, 12 Jan 2015 00:58:06 +0100
Message-Id: <1421020689-28332-2-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the heading underlines fit the length of the heading, remove colons
at the end of headings and consistently place an empty line after each
heading and two empty lines before each that is preceded by a paragraph.

Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 Documentation/misc-devices/mei/mei-client-bus.txt |  7 ++++--
 Documentation/misc-devices/mei/mei.txt            | 27 ++++++++++++++---------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei-client-bus.txt b/Documentation/misc-devices/mei/mei-client-bus.txt
index f83910a..6ca486b 100644
--- a/Documentation/misc-devices/mei/mei-client-bus.txt
+++ b/Documentation/misc-devices/mei/mei-client-bus.txt
@@ -1,9 +1,10 @@
 Intel(R) Management Engine (ME) Client bus API
-===============================================
+==============================================
 
 
 Rationale
 =========
+
 MEI misc character device is useful for dedicated applications to send and receive
 data to the many FW appliance found in Intel's ME from the user space.
 However for some of the ME functionalities it make sense to leverage existing software
@@ -17,7 +18,8 @@ the existing code.
 
 
 MEI CL bus API
-===========
+==============
+
 A driver implementation for an MEI Client is very similar to existing bus
 based device drivers. The driver registers itself as an MEI CL bus driver through
 the mei_cl_driver structure:
@@ -55,6 +57,7 @@ received buffers.
 
 Example
 =======
+
 As a theoretical example let's pretend the ME comes with a "contact" NFC IP.
 The driver init and exit routines for this device would look like:
 
diff --git a/Documentation/misc-devices/mei/mei.txt b/Documentation/misc-devices/mei/mei.txt
index 15bba1a..9a96af1 100644
--- a/Documentation/misc-devices/mei/mei.txt
+++ b/Documentation/misc-devices/mei/mei.txt
@@ -1,8 +1,8 @@
 Intel(R) Management Engine Interface (Intel(R) MEI)
-=======================
+===================================================
 
 Introduction
-=======================
+============
 
 The Intel Management Engine (Intel ME) is an isolated and protected computing
 resource (Co-processor) residing inside certain Intel chipsets. The Intel ME
@@ -44,8 +44,9 @@ HTTP/S that are received from a remote management console application.
 For more information about Intel AMT:
 http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
 
+
 Intel MEI Driver
-=======================
+================
 
 The driver exposes a misc device called /dev/mei.
 
@@ -91,8 +92,10 @@ A code snippet for an application communicating with Intel AMTHI client:
 	[...]
 	close(fd);
 
-IOCTL:
-======
+
+IOCTL
+=====
+
 The Intel MEI Driver supports the following IOCTL command:
 	IOCTL_MEI_CONNECT_CLIENT	Connect to firmware Feature (client).
 
@@ -122,8 +125,9 @@ The Intel MEI Driver supports the following IOCTL command:
         data that can be sent or received. (e.g. if MTU=2K, can send
         requests up to bytes 2k and received responses up to 2k bytes).
 
-Intel ME Applications:
-==============
+
+Intel ME Applications
+=====================
 
 1) Intel Local Management Service (Intel LMS)
 
@@ -172,8 +176,9 @@ Intel ME Applications:
 	http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
 
 
-Intel AMT OS Health Watchdog:
-=============================
+Intel AMT OS Health Watchdog
+============================
+
 The Intel AMT Watchdog is an OS Health (Hang/Crash) watchdog.
 Whenever the OS hangs or crashes, Intel AMT will send an event
 to any subscriber to this event. This mechanism means that
@@ -192,8 +197,10 @@ watchdog is 120 seconds.
 If the Intel AMT Watchdog feature does not exist (i.e. the connection failed),
 the Intel MEI driver will disable the sending of heartbeats.
 
-Supported Chipsets:
+
+Supported Chipsets
 ==================
+
 7 Series Chipset Family
 6 Series Chipset Family
 5 Series Chipset Family
-- 
2.2.1

