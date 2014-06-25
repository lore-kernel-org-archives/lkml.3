Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaFYILd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:11:33 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:62616 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbaFYILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:11:30 -0400
Message-ID: <1403683888.1960.35.camel@x220>
Subject: [PATCH] [TRIVIAL] Documentation: Fix typo 'CONFIG_AFS'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 10:11:28 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2014 08:11:28.0907 (UTC) FILETIME=[10FF1DB0:01CF904D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Perhaps AF_RXRPC should be dropped from this short list (it is selected
if AFS_FS is set). But since I couldn't actually determine how AFS_FS
and RXKAD interact I decided to not touch that list any further.

 Documentation/filesystems/afs.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/afs.txt b/Documentation/filesystems/afs.txt
index ffef91c4e0d6..5857253e2e1b 100644
--- a/Documentation/filesystems/afs.txt
+++ b/Documentation/filesystems/afs.txt
@@ -43,7 +43,7 @@ options:
 
 	CONFIG_AF_RXRPC		- The RxRPC protocol transport
 	CONFIG_RXKAD		- The RxRPC Kerberos security handler
-	CONFIG_AFS		- The AFS filesystem
+	CONFIG_AFS_FS		- The AFS filesystem
 
 Additionally, the following can be turned on to aid debugging:
 
-- 
1.9.3

