Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaFZJMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:12:54 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:61786 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbaFZJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:12:53 -0400
Message-ID: <1403773971.10227.1.camel@x220>
Subject: [PATCH] [TRIVIAL] Documentation: au1xxx-ide.c has moved
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 11:12:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2014 09:12:51.0205 (UTC) FILETIME=[CE3AF350:01CF911E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
That file has moved in v2.6.28, see commit 2bfba3c444fe ("ide: remove
useless subdirs from drivers/ide/").

 Documentation/mips/AU1xxx_IDE.README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mips/AU1xxx_IDE.README b/Documentation/mips/AU1xxx_IDE.README
index cc887ecfd6eb..52844a58cc8a 100644
--- a/Documentation/mips/AU1xxx_IDE.README
+++ b/Documentation/mips/AU1xxx_IDE.README
@@ -2,7 +2,7 @@ README for MIPS AU1XXX IDE driver - Released 2005-07-15
 
 ABOUT
 -----
-This file describes the 'drivers/ide/mips/au1xxx-ide.c', related files and the
+This file describes the 'drivers/ide/au1xxx-ide.c', related files and the
 services they provide.
 
 If you are short in patience and just want to know how to add your hard disc to
-- 
1.9.3

