Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbaGXJms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:42:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40209 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbaGXJmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:42:46 -0400
From: "Raymond L. Rivera" <ray.l.rivera@gmail.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Raymond L. Rivera" <ray.l.rivera@gmail.com>
Subject: [PATCH 1/2] CodingStyle: Fixed a minor typo.
Date: Thu, 24 Jul 2014 02:39:44 -0700
Message-Id: <1406194785-19596-2-git-send-email-ray.l.rivera@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406194785-19596-1-git-send-email-ray.l.rivera@gmail.com>
References: <1406194785-19596-1-git-send-email-ray.l.rivera@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a minor typo in the CodingStyle document where the word 'section'
had been spelled as 'secton'.

Signed-off-by: Raymond L. Rivera <ray.l.rivera@gmail.com>
---
 Documentation/CodingStyle | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6b6bef3..3171822 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -675,7 +675,7 @@ the ones already enabled by DEBUG.
 Many subsystems have Kconfig debug options to turn on -DDEBUG in the
 corresponding Makefile; in other cases specific files #define DEBUG.  And
 when a debug message should be unconditionally printed, such as if it is
-already inside a debug-related #ifdef secton, printk(KERN_DEBUG ...) can be
+already inside a debug-related #ifdef section, printk(KERN_DEBUG ...) can be
 used.
 
 
-- 
1.9.1

