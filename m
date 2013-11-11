Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3KKFEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:04:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:64536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3KKFD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:03:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432994846"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/2] tracing: a couple minor for-next fixes
Date: Sun, 10 Nov 2013 23:03:44 -0600
Message-Id: <cover.1384145701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a couple sparse warnings reported by the 'kbuild
test robot' and removes a redundant function call noticed by Steve
Rostedt.

The following changes since commit 20b72e76c42bc4f0dd091f9faee542ea45ad6b5e:

  Merge branch 'trace/ftrace/core' into trace/for-next (2013-11-06 22:58:52 -0500)

are available in the git repository at:

  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/tracing-next-fixes
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/tracing-next-fixes

Tom Zanussi (2):
  tracing: Add __rcu to enter/exit_syscall_files
  tracing: Remove redundant destroy_call_preds() call

 kernel/trace/trace.h        | 4 ++--
 kernel/trace/trace_events.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
1.8.3.1

