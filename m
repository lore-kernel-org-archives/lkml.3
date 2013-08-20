Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3HTDFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:05:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45190 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3HTDFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:05:45 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: omar.ramirez@copitl.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: tidspbridge: Fix typos in comments
Date: Tue, 20 Aug 2013 12:05:39 +0900
Message-Id: <1376967939-9527-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in comments.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/tidspbridge/include/dspbridge/cmm.h  | 2 +-
 drivers/staging/tidspbridge/include/dspbridge/proc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index c66bcf7..2adf9ec 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -293,7 +293,7 @@ extern int cmm_xlator_free_buf(struct cmm_xlatorobject *xlator,
  *  ======== cmm_xlator_info ========
  *  Purpose:
  *      Set/Get process specific "translator" address info.
- *      This is used to perform fast virtaul address translation
+ *      This is used to perform fast virtual address translation
  *      for shared memory buffers between the GPP and DSP.
  *  Parameters:
  *     xlator:     handle to translator.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 774a3f6..64c2457 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -284,7 +284,7 @@ extern int proc_get_trace(void *hprocessor, u8 * pbuf, u32 max_size);
  *      user_envp:       An Array of Environment settings(Unicode Strings)
  *  Returns:
  *      0:       Success.
- *      -ENOENT:       The DSP Execuetable was not found.
+ *      -ENOENT:       The DSP Executable was not found.
  *      -EFAULT:       Invalid processor handle.
  *      -EPERM   :       Unable to Load the Processor
  *  Requires:
-- 
1.8.4.rc3.2.g2c2b664

