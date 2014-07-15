Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaGORH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:07:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53354 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaGORCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:21 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 89/94] Linux 3.16-rc5
Date: Tue, 15 Jul 2014 20:01:44 +0300
Message-Id: <1405443709-15288-89-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>


Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 2167084..f3c543d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 16
 SUBLEVEL = 0
-EXTRAVERSION = -rc4
+EXTRAVERSION = -rc5
 NAME = Shuffling Zombie Juror
 
 # *DOCUMENTATION*
-- 
1.7.10.4

