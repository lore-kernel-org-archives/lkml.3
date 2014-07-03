Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbaGCVQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:16:17 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46121 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaGCVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:16:16 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: Remove FIXME in file osf_sys.c
Date: Thu,  3 Jul 2014 17:16:10 -0400
Message-Id: <1404422170-3784-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the FIXME message on line 891 for info.si_addr being NULL
as according to alpha devolopers there is no good work around as
of newest kernel verisons

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/alpha/kernel/osf_sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 1402fcc..27257dc 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -888,7 +888,7 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned long, op, void __user *, buffer,
 			info.si_signo = SIGFPE;
 			info.si_errno = 0;
 			info.si_code = si_code;
-			info.si_addr = NULL;  /* FIXME */
+			info.si_addr = NULL;
  			send_sig_info(SIGFPE, &info, current);
  		}
 		return 0;
-- 
1.9.1

