Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3IOJfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:35:44 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:32942 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3IOJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:35:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Biederman <ebiederm@xmission.com>, Jiri Kosina <trivial@kernel.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH TRIVIAL] kexec: Typo s/the/then/
Date: Sun, 15 Sep 2013 11:35:37 +0200
Message-Id: <1379237737-3070-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2a74f30..490afc0 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -921,7 +921,7 @@ static int kimage_load_segment(struct kimage *image,
  *   reinitialize them.
  *
  * - A machine specific part that includes the syscall number
- *   and the copies the image to it's final destination.  And
+ *   and then copies the image to it's final destination.  And
  *   jumps into the image at entry.
  *
  * kexec does not sync, or unmount filesystems so if you need
-- 
1.7.9.5

