Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3F1NuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3F1Ntv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:49:51 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH trivial] doc: printk-formats: fix format specifier to %p[Ii]4[hnbl]
Date: Fri, 28 Jun 2013 15:49:39 +0200
Message-Id: <1372427379-3272-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might have been an oversight, as '4' is needed as %pI4/%pi4
are format specifiers and [hnbl] are extensions of it.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
CC: Joe Perches <joe@perches.com>
---
 Documentation/printk-formats.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 3d4b76f..0ef74cc 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -97,7 +97,7 @@ IPv4 addresses:
 
 	%pI4	1.2.3.4
 	%pi4	001.002.003.004
-	%p[Ii][hnbl]
+	%p[Ii]4[hnbl]
 
 	For printing IPv4 dot-separated decimal addresses. The 'I4' and 'i4'
 	specifiers result in a printed address with ('i4') or without ('I4')
-- 
1.7.11.7

