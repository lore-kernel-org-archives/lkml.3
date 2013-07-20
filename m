Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3GTIkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GTIjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:39:32 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] apparmor: enable users to query whether apparmor is enabled
Date: Sat, 20 Jul 2013 01:38:36 -0700
Message-Id: <1374309527-7082-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 2e2a0dd..96506df 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -742,7 +742,7 @@ module_param_named(paranoid_load, aa_g_paranoid_load, aabool,
 
 /* Boot time disable flag */
 static bool apparmor_enabled = CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE;
-module_param_named(enabled, apparmor_enabled, aabool, S_IRUSR);
+module_param_named(enabled, apparmor_enabled, bool, S_IRUGO);
 
 static int __init apparmor_enabled_setup(char *str)
 {
-- 
1.8.1.2

