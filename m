Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966261AbaLLKwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:52:30 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42107 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966102AbaLLKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:51:56 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ken Cox <jkc@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: unisys: remove leftover __DATE__
Date: Fri, 12 Dec 2014 11:51:27 +0100
Message-Id: <1418381488-25123-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 836bee9eee6d ("Staging: unisys: remove references to __DATE__
and __TIME__") removed most; this seems to be an accidental
leftover. VERSIONDATE is not used anywhere.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/unisys/common-spar/include/version.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/unisys/common-spar/include/version.h b/drivers/staging/unisys/common-spar/include/version.h
index f25208fc3ed1..83d1da7a2f81 100644
--- a/drivers/staging/unisys/common-spar/include/version.h
+++ b/drivers/staging/unisys/common-spar/include/version.h
@@ -30,7 +30,6 @@
 #define SPARVER4 "0"
 
 #define  VERSION        SPARVER1 "." SPARVER2 "." SPARVER3 "." SPARVER4
-#define  VERSIONDATE    __DATE__
 
 /* Here are various version forms needed in Windows environments.
  */
-- 
2.1.3

