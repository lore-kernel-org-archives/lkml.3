Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaEIMzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:55:45 -0400
Received: from smtp35.i.mail.ru ([94.100.177.95]:54432 "EHLO smtp35.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaEIMzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:55:44 -0400
From: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
Subject: [PATCH] Delete incorrect email
Date: Fri,  9 May 2014 16:55:36 +0400
Message-Id: <1399640136-11136-1-git-send-email-brilliantov@inbox.ru>
X-Mailer: git-send-email 1.9.1
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reporting-MTA: dns; mailusrigwprd02.lss.emc.com
Received-From-MTA: DNS; mail-va3.bigfish.com
Arrival-Date: Fri, 9 May 2014 06:50:01 -0400

Final-Recipient: RFC822; tao.peng@emc.com
Action: failed
Status: 5.0.0
Remote-MTA: DNS; mailusrhubprd04.lss.emc.com
Diagnostic-Code: SMTP; 550 5.0.0 <tao.peng@emc.com>... User unknown
Last-Attempt-Date: Fri, 9 May 2014 06:50:01 -0400
Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
---
 drivers/staging/lustre/TODO | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/TODO b/drivers/staging/lustre/TODO
index 0a2b6cb..1281465 100644
--- a/drivers/staging/lustre/TODO
+++ b/drivers/staging/lustre/TODO
@@ -9,6 +9,5 @@
 * Other minor misc cleanups...
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>, Andreas Dilger
-<andreas.dilger@intel.com>, Oleg Drokin <oleg.drokin@intel.com> and
-Peng Tao <tao.peng@emc.com>. CCing hpdd-discuss <hpdd-discuss@lists.01.org>
-would be great too.
+<andreas.dilger@intel.com>, Oleg Drokin <oleg.drokin@intel.com>.
+CCing hpdd-discuss <hpdd-discuss@lists.01.org> would be great too.
-- 
1.9.1

