Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3K0OK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:10:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3K0OKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:10:22 -0500
Date: Wed, 27 Nov 2013 06:09:51 -0800
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-1acd437c59c7dd78d8f1e5f07bea6a18b7b5cd77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1371163284-6346-10-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-10-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add a MAINTAINERS entry
Git-Commit-ID: 1acd437c59c7dd78d8f1e5f07bea6a18b7b5cd77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:09:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1acd437c59c7dd78d8f1e5f07bea6a18b7b5cd77
Gitweb:     http://git.kernel.org/tip/1acd437c59c7dd78d8f1e5f07bea6a18b7b5cd77
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 13 Jun 2013 18:41:24 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:56:32 +0100

liblockdep: Add a MAINTAINERS entry

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/1371163284-6346-10-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 63f3048..9e62574 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5111,6 +5111,11 @@ F:	drivers/lguest/
 F:	include/linux/lguest*.h
 F:	tools/lguest/
 
+LIBLOCKDEP
+M:	Sasha Levin <sasha.levin@oracle.com>
+S:	Maintained
+F:	tools/lib/lockdep/
+
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
