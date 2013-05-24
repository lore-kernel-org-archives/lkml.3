Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab3EXHlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:41:32 -0400
Received: from mail.southpole.se ([37.247.8.11]:41550 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496Ab3EXHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:41:31 -0400
From: Jonas Bonn <jonas@southpole.se>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 1/1] cris: remove unused current_regs
Date: Fri, 24 May 2013 09:41:27 +0200
Message-Id: <1369381287-3923-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: linux-cris-kernel@axis.com
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---

Hi Geert,

As your 'exotic' branch seems to show you're doing some work on CRIS, how
about taking this rather trivial patch into your branch as well.  I sent
this to the CRIS maintainers/mailing list six months ago but never got
any response back.

Thanks,
Jonas


 arch/cris/include/asm/processor.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index c0a29b9..15b815d 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -47,7 +47,6 @@ struct task_struct;
  */
 
 #define task_pt_regs(task) user_regs(task_thread_info(task))
-#define current_regs() task_pt_regs(current)
 
 unsigned long get_wchan(struct task_struct *p);
 
-- 
1.8.1.2

