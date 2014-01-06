Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaAFTor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:44:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:34592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbaAFTop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:44:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="434659784"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/2] tracing/triggers: A couple minor variable name changes
Date: Mon,  6 Jan 2014 13:44:18 -0600
Message-Id: <cover.1389036657.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes __tt to tt to for the recently submitted kprobes trigger patch,
and does the same for the syscall trigger invocations, which uses the same
unnecessary naming convention pointed out by Steve Rostedt.

The kprobes patch also had trivial changes resulting from the rebase
to current tracing/for-next.

The following changes since commit e0d18fe063464cb3f1a6d1939e4fcf47d92d8386:

  tracing/probes: Fix build break on !CONFIG_KPROBE_EVENT (2014-01-03 15:27:18 -0500)

are available in the git repository at:

  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/kprobes-event-triggers-v2
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/kprobes-event-triggers-v2

Tom Zanussi (2):
  tracing/kprobes: Add trace event trigger invocations
  tracing: Remove double-underscore naming in syscall trigger
    invocations

 kernel/trace/trace_kprobe.c   | 42 ++++++++++++++++++++++++++++++++++++------
 kernel/trace/trace_syscalls.c | 16 ++++++++--------
 2 files changed, 44 insertions(+), 14 deletions(-)

-- 
1.8.3.1

