Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaIUQ1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:27:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37613 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaIUQ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:36 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 3/8] cris: Add dummy free_initrd_mem
Date: Sun, 21 Sep 2014 09:27:13 -0700
Message-Id: <1411316838-15135-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to enable builds with initrd embedded in the image

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
(cherry picked from commit ee6355589ea0fcda0d19ec93015f4b61a39e8410)
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
(cherry picked from commit 7092cf61ed870897fea5c81b136a38d4a09ca09f)
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
(cherry picked from commit 8df94101f9bd48e4fa129966319f813d44d83692)
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/cris/mm/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index c81af5b..11d8eca 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -38,3 +38,7 @@ free_initmem(void)
 {
 	free_initmem_default(-1);
 }
+
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+}
-- 
1.9.1

