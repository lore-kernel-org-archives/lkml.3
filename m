Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaGVNcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:32:35 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63055 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbaGVNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:32:32 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: akpm@linux-foundation.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] staging: init: main: fix sparse warning Fix sparse warning "should it be static"
Date: Tue, 22 Jul 2014 09:32:20 -0400
Message-Id: <1406035940-15937-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 init/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index e8ae1fe..25cc270 100644
--- a/init/main.c
+++ b/init/main.c
@@ -160,7 +160,8 @@ static int __init set_reset_devices(char *str)
 __setup("reset_devices", set_reset_devices);
 
 static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/",
+						  "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
-- 
1.7.10.4

