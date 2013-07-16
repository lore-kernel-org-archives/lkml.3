Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab3GPUlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:41:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58584 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3GPUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:40:22 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 3/6] kconfig/[mn]conf: shorten title in search-box
Date: Tue, 16 Jul 2013 22:39:59 +0200
Message-Id: <f6eb6e46f766f4e2eb64d2d467ef7efff084c47c.1374006854.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

No need to repeat the 'CONFIG_' string in the title,
once is explicit enough.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
---
 scripts/kconfig/mconf.c | 4 ++--
 scripts/kconfig/nconf.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 18d3dc9..b20e851 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -401,8 +401,8 @@ static void search_conf(void)
 	struct subtitle_part stpart;
 
 	title = str_new();
-	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
-			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
+	str_printf( &title, _("Enter (sub)string or regexp to search for "
+			      "(with or without \"%s\")"), CONFIG_);
 
 again:
 	dialog_clear();
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 7975d8d..4fbecd2 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -695,8 +695,8 @@ static void search_conf(void)
 	int dres;
 
 	title = str_new();
-	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
-			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
+	str_printf( &title, _("Enter (sub)string or regexp to search for "
+			      "(with or without \"%s\")"), CONFIG_);
 
 again:
 	dres = dialog_inputbox(main_window,
-- 
1.8.1.2

