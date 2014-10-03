Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaJCPg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:36:59 -0400
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:57487 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbaJCPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:36:33 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] kselftest framework and test changes to use it
Date: Fri,  3 Oct 2014 09:36:15 -0600
Message-Id: <cover.1412349412.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch v3 series: (revised to address v2 comments)
Dropped mount and ptrace patches.

Add kselftest framework for tests to use. This is a light
weight framework provides a set of interfaces to report test
results and test statistics on number of tests passed and failed.

Several tests are changed to use the framework to report results.

Shuah Khan (5):
  selftests: add kselftest framework for uniform test reporting
  selftests/breakpoints: change test to use ksft framework
  selftests/ipc: change test to use ksft framework
  selftests/kcmp: change test to use ksft framework
  selftests/timers: change test to use ksft framework

 .../selftests/breakpoints/breakpoint_test.c        | 10 ++--
 tools/testing/selftests/ipc/msgque.c               | 26 ++++-----
 tools/testing/selftests/kcmp/kcmp_test.c           | 27 +++++++---
 tools/testing/selftests/kselftest.h                | 62 ++++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      | 14 ++---
 5 files changed, 110 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.h

-- 
1.9.1

