Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3GIKEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:04:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47423 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3GIKEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:04:20 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v3 0/5] Minor perf build fixes
Date: Tue,  9 Jul 2013 15:30:28 +0530
Message-Id: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This iteration is in response to Namhyung's review of the previous
iteration.  The differences are:

[3/5] adds a util/perl.h using #include_next without touching any
other files.  This is a much cleaner approach.

[4/5] regenerates Context.c.

[5/5] is new.  I just noticed it.

Thanks.

Ramkumar Ramachandra (5):
  perf/Makefile: do not open-code shell-sq
  perf/Perf-Trace-Util: fix broken include in Context.xs
  perf: squelch warnings from perl.h to compile-pass
  perf/Perf-Trace-Util: regenerate Context.c
  perf/Perf-Trace-Util: add .gitignore

 tools/perf/Makefile                                |   2 +-
 tools/perf/config/Makefile                         |  23 ++-
 tools/perf/scripts/perl/Perf-Trace-Util/.gitignore |   5 +
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  | 211 +++++++++++++++++----
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   2 +-
 tools/perf/util/perl.h                             |  10 +
 6 files changed, 199 insertions(+), 54 deletions(-)
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/.gitignore
 create mode 100644 tools/perf/util/perl.h

-- 
1.8.3.2.736.g869de25

