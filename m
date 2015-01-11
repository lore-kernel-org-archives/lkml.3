Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbbAKX6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:58:24 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47183 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbbAKX6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:58:18 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: linux-doc@vger.kernel.org
Cc: Julian Brost <linux-kernel@0x4a42.net>, linux-kernel@vger.kernel.org,
        corbet@lwn.net, tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: [PATCH 3/4] Documentation/misc-devices/mei: Fix indentation of enumeration.
Date: Mon, 12 Jan 2015 00:58:08 +0100
Message-Id: <1421020689-28332-4-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly indent a list in mei.txt in the same way as another list in
that file.

Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 Documentation/misc-devices/mei/mei.txt | 91 +++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 45 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei.txt b/Documentation/misc-devices/mei/mei.txt
index 63f9ccc..8d47501 100644
--- a/Documentation/misc-devices/mei/mei.txt
+++ b/Documentation/misc-devices/mei/mei.txt
@@ -129,51 +129,52 @@ The Intel MEI Driver supports the following IOCTL command:
 Intel ME Applications
 =====================
 
-1) Intel Local Management Service (Intel LMS)
-
-	Applications running locally on the platform communicate with Intel AMT Release
-	2.0 and later releases in the same way that network applications do via SOAP
-	over HTTP (deprecated starting with Release 6.0) or with WS-Management over
-	SOAP over HTTP. This means that some Intel AMT features can be accessed from a
-	local application using the same network interface as a remote application
-	communicating with Intel AMT over the network.
-
-	When a local application sends a message addressed to the local Intel AMT host
-	name, the Intel LMS, which listens for traffic directed to the host name,
-	intercepts the message and routes it to the Intel MEI.
-	For more information:
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
-	Under "About Intel AMT" => "Local Access"
-
-	For downloading Intel LMS:
-	http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
-
-	The Intel LMS opens a connection using the Intel MEI driver to the Intel LMS
-	firmware feature using a defined UUID and then communicates with the feature
-	using a protocol called Intel AMT Port Forwarding Protocol (Intel APF protocol).
-	The protocol is used to maintain multiple sessions with Intel AMT from a
-	single application.
-
-	See the protocol specification in the Intel AMT Software Development Kit (SDK)
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
-	Under "SDK Resources" => "Intel(R) vPro(TM) Gateway (MPS)"
-	=> "Information for Intel(R) vPro(TM) Gateway Developers"
-	=> "Description of the Intel AMT Port Forwarding (APF) Protocol"
-
-  2) Intel AMT Remote configuration using a Local Agent
-	A Local Agent enables IT personnel to configure Intel AMT out-of-the-box
-	without requiring installing additional data to enable setup. The remote
-	configuration process may involve an ISV-developed remote configuration
-	agent that runs on the host.
-	For more information:
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
-	Under "Setup and Configuration of Intel AMT" =>
-	"SDK Tools Supporting Setup and Configuration" =>
-	"Using the Local Agent Sample"
-
-	An open source Intel AMT configuration utility,	implementing a local agent
-	that accesses the Intel MEI driver, can be found here:
-	http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
+	1) Intel Local Management Service (Intel LMS)
+
+	   Applications running locally on the platform communicate with Intel AMT Release
+	   2.0 and later releases in the same way that network applications do via SOAP
+	   over HTTP (deprecated starting with Release 6.0) or with WS-Management over
+	   SOAP over HTTP. This means that some Intel AMT features can be accessed from a
+	   local application using the same network interface as a remote application
+	   communicating with Intel AMT over the network.
+
+	   When a local application sends a message addressed to the local Intel AMT host
+	   name, the Intel LMS, which listens for traffic directed to the host name,
+	   intercepts the message and routes it to the Intel MEI.
+	   For more information:
+	   http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
+	   Under "About Intel AMT" => "Local Access"
+
+	   For downloading Intel LMS:
+	   http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
+
+	   The Intel LMS opens a connection using the Intel MEI driver to the Intel LMS
+	   firmware feature using a defined UUID and then communicates with the feature
+	   using a protocol called Intel AMT Port Forwarding Protocol (Intel APF protocol).
+	   The protocol is used to maintain multiple sessions with Intel AMT from a
+	   single application.
+
+	   See the protocol specification in the Intel AMT Software Development Kit (SDK)
+	   http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
+	   Under "SDK Resources" => "Intel(R) vPro(TM) Gateway (MPS)"
+	   => "Information for Intel(R) vPro(TM) Gateway Developers"
+	   => "Description of the Intel AMT Port Forwarding (APF) Protocol"
+
+	2) Intel AMT Remote configuration using a Local Agent
+
+	   A Local Agent enables IT personnel to configure Intel AMT out-of-the-box
+	   without requiring installing additional data to enable setup. The remote
+	   configuration process may involve an ISV-developed remote configuration
+	   agent that runs on the host.
+	   For more information:
+	   http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
+	   Under "Setup and Configuration of Intel AMT" =>
+	   "SDK Tools Supporting Setup and Configuration" =>
+	   "Using the Local Agent Sample"
+
+	   An open source Intel AMT configuration utility,	implementing a local agent
+	   that accesses the Intel MEI driver, can be found here:
+	   http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
 
 
 Intel AMT OS Health Watchdog
-- 
2.2.1

