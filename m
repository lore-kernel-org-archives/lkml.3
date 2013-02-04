Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3BDN4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:56:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:56:30 -0500
Date: Mon, 4 Feb 2013 05:56:16 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-3279bccc7ff663ef1ccd8b9e8d4ac197c0e041e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-6-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-6-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add a MAINTAINERS entry
Git-Commit-ID: 3279bccc7ff663ef1ccd8b9e8d4ac197c0e041e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:56:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3279bccc7ff663ef1ccd8b9e8d4ac197c0e041e7
Gitweb:     http://git.kernel.org/tip/3279bccc7ff663ef1ccd8b9e8d4ac197c0e041e7
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:43 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:07 +0100

liblockdep: Add a MAINTAINERS entry

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-6-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ae709e..3ea8ee1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4637,6 +4637,11 @@ F:	drivers/lguest/
 F:	include/linux/lguest*.h
 F:	tools/lguest/
 
+LIBLOCK
+M:	Sasha Levin <sasha.levin@oracle.com>
+S:	Maintained
+F:	tools/lib/lockdep/
+
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
