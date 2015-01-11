Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbbAKX7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:59:08 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47173 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbbAKX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:58:17 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: linux-doc@vger.kernel.org
Cc: Julian Brost <linux-kernel@0x4a42.net>, linux-kernel@vger.kernel.org,
        corbet@lwn.net, tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: [PATCH 2/4] Documentation/misc-devices/mei: Fix spacing around parentheses.
Date: Mon, 12 Jan 2015 00:58:07 +0100
Message-Id: <1421020689-28332-3-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a space before opening and after closing parentheses where
appropriate.

Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 Documentation/misc-devices/mei/mei.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei.txt b/Documentation/misc-devices/mei/mei.txt
index 9a96af1..63f9ccc 100644
--- a/Documentation/misc-devices/mei/mei.txt
+++ b/Documentation/misc-devices/mei/mei.txt
@@ -19,7 +19,7 @@ each client has its own protocol. The protocol is message-based with a
 header and payload up to 512 bytes.
 
 Prominent usage of the Intel ME Interface is to communicate with Intel(R)
-Active Management Technology (Intel AMT)implemented in firmware running on
+Active Management Technology (Intel AMT) implemented in firmware running on
 the Intel ME.
 
 Intel AMT provides the ability to manage a host remotely out-of-band (OOB)
@@ -150,15 +150,15 @@ Intel ME Applications
 
 	The Intel LMS opens a connection using the Intel MEI driver to the Intel LMS
 	firmware feature using a defined UUID and then communicates with the feature
-	using a protocol called Intel AMT Port Forwarding Protocol(Intel APF protocol).
+	using a protocol called Intel AMT Port Forwarding Protocol (Intel APF protocol).
 	The protocol is used to maintain multiple sessions with Intel AMT from a
 	single application.
 
-	See the protocol specification in the Intel AMT Software Development Kit(SDK)
+	See the protocol specification in the Intel AMT Software Development Kit (SDK)
 	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
-	Under "SDK Resources" => "Intel(R) vPro(TM) Gateway(MPS)"
+	Under "SDK Resources" => "Intel(R) vPro(TM) Gateway (MPS)"
 	=> "Information for Intel(R) vPro(TM) Gateway Developers"
-	=> "Description of the Intel AMT Port Forwarding (APF)Protocol"
+	=> "Description of the Intel AMT Port Forwarding (APF) Protocol"
 
   2) Intel AMT Remote configuration using a Local Agent
 	A Local Agent enables IT personnel to configure Intel AMT out-of-the-box
-- 
2.2.1

