Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaAAL4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 06:56:04 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:47392 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaAAL4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 06:56:01 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] Documentation: correct typo in dynamic-debug-howto.txt (echo -c -> echo -n)
Date: Wed,  1 Jan 2014 12:54:54 +0100
Message-Id: <1388577294-5587-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <52BD71D7.9060709@landley.net>
References: <52BD71D7.9060709@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As nobody could answer what the parameter -c for echo should be, I assume
it's a typo. Normally I don't care much about those, but this one might make
people search for the meaning of the parameter -c.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Documentation/dynamic-debug-howto.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 1bbdcfc..abb7dfe 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -91,9 +91,9 @@ Command Language Reference
 At the lexical level, a command comprises a sequence of words separated
 by spaces or tabs.  So these are all equivalent:
 
-nullarbor:~ # echo -c 'file svcsock.c line 1603 +p' >
+nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
-nullarbor:~ # echo -c '  file   svcsock.c     line  1603 +p  ' >
+nullarbor:~ # echo -n '  file   svcsock.c     line  1603 +p  ' >
 				<debugfs>/dynamic_debug/control
 nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
-- 
1.8.1.4

