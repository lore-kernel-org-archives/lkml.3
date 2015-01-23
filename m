Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbbAWIUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:20:06 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38433 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbAWIUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:20:03 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, corbet@lwn.net, akpm@linux-foundation.org,
        mingo@kernel.org, riel@redhat.com, bp@alien8.de
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Doc: Add default behavior of panic parameter in kernel.txt
Date: Fri, 23 Jan 2015 17:20:07 +0900
Message-Id: <1422001207-13097-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds default behavior of panic parameter in kernel.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/sysctl/kernel.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 75511ef..3cae2bd 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -527,6 +527,8 @@ panic:
 The value in this file represents the number of seconds the kernel
 waits before rebooting on a panic. When you use the software watchdog,
 the recommended setting is 60.
+A value of 0 will disable rebooting on a panic.
+The default is 0.
 
 ==============================================================
 
-- 
2.3.0.rc1

