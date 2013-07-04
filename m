Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3GDNol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:44:41 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60557 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3GDNok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:44:40 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Minor perf build fixes
Date: Thu,  4 Jul 2013 19:10:44 +0530
Message-Id: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[1/2] is a trivial cleanup patch.  I happened to notice it because the
syntax highlighting of shell-script-mode broke due to the unmatched
quotes.

I'm not sure why [2/2] hasn't already been noticed and fixed though.

Thanks.

Ramkumar Ramachandra (2):
  perf/Makefile: do not open-code shell-sq
  perf: squelch warnings from perl.h to compile-pass

 tools/perf/Makefile                                |  2 +-
 tools/perf/config/Makefile                         | 23 +++++++++++-----------
 tools/perf/config/feature-tests.mak                |  5 +++++
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  | 10 ++++++++--
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs | 10 ++++++++--
 .../perf/util/scripting-engines/trace-event-perl.c |  5 +++++
 6 files changed, 38 insertions(+), 17 deletions(-)

-- 
1.8.3.1.643.gebeea52.dirty

