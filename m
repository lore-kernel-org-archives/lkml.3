Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3GJPTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:19:33 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56783 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3GJPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:19:04 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 2/3] menuconfig: remove redundant info from RESERVED_LETTERS
Date: Wed, 10 Jul 2013 20:45:17 +0530
Message-Id: <1373469318-13956-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
References: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first_alpha() checks only against lowercase characters anyway.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 scripts/kconfig/lxdialog/menubox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 5923f2c..698d7c3 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -57,7 +57,7 @@
  */
 
 #include "dialog.h"
-#define RESERVED_LETTERS "YyNnMmHh"
+#define RESERVED_LETTERS "ynmh"
 
 static int menu_width, item_x;
 
-- 
1.8.3.2.736.g869de25

