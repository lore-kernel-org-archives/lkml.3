Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3BSPsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:48:08 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46614 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3BSPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:48:06 -0500
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] man2/prctl.2: Add PR_GET_TID_ADDRESS description
Date: Tue, 19 Feb 2013 19:47:59 +0400
Message-Id: <1361288879-21436-1-git-send-email-gorcunov@openvz.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 man2/prctl.2 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/man2/prctl.2 b/man2/prctl.2
index 012af4d..4906c70 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -761,6 +761,18 @@ option.
 .\" symbolic-link transitions over all process running in a system.
 .\" ========== END FIXME
 .RE
+.TP
+.BR PR_GET_TID_ADDRESS " (since Linux 3.5)"
+Return
+.I clear_child_tid
+in the location pointed by
+.IR "(int\ **) arg2" .
+See
+.BR set_tid_address (2)
+for more details.
+This feature is available only if the kernel is built with the
+.BR CONFIG_CHECKPOINT_RESTORE
+option enabled.
 .\"
 .SH "RETURN VALUE"
 On success,
-- 
1.8.1.2

