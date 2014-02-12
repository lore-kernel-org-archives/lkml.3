Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBLJ2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:28:09 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49487 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbaBLJ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:28:07 -0500
Message-ID: <1392197285.23759.2.camel@x220>
Subject: [PATCH] [TRIVIAL] Insert MODULE_ in module-signing macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 10:28:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 09:28:06.0390 (UTC) FILETIME=[BC5E9960:01CF27D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/module-signing.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index 2b40e04..09b583e 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -77,11 +77,11 @@ This has a number of options available:
      This presents a choice of which hash algorithm the installation phase will
      sign the modules with:
 
-	CONFIG_SIG_SHA1		"Sign modules with SHA-1"
-	CONFIG_SIG_SHA224	"Sign modules with SHA-224"
-	CONFIG_SIG_SHA256	"Sign modules with SHA-256"
-	CONFIG_SIG_SHA384	"Sign modules with SHA-384"
-	CONFIG_SIG_SHA512	"Sign modules with SHA-512"
+	CONFIG_MODULE_SIG_SHA1		"Sign modules with SHA-1"
+	CONFIG_MODULE_SIG_SHA224	"Sign modules with SHA-224"
+	CONFIG_MODULE_SIG_SHA256	"Sign modules with SHA-256"
+	CONFIG_MODULE_SIG_SHA384	"Sign modules with SHA-384"
+	CONFIG_MODULE_SIG_SHA512	"Sign modules with SHA-512"
 
      The algorithm selected here will also be built into the kernel (rather
      than being a module) so that modules signed with that algorithm can have
-- 
1.8.5.3

