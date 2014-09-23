Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaIWVdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:33:12 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:39798
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbaIWVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:33:07 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] kselftest framework and test changes to use it
Date: Tue, 23 Sep 2014 15:32:53 -0600
Message-Id: <cover.1411506121.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch v2 series: (revised to address v1 comments)

Add kselftest framework for tests to use. This is a light
weight framework provides a set of interfaces to report test
results and test statistics on number of tests passed and failed.

Several tests are changed to use the framework to report results.

Shuah Khan (7):
  selftests: add kselftest framework for uniform test reporting
  selftests/breakpoints: change test to use ksft framework
  selftests/ipc: change test to use ksft framework
  selftests/kcmp: change test to use ksft framework
  selftests/mount: change test to use ksft framework
  selftests/ptrace: change test to use ksft framework
  selftests/timers: change test to use ksft framework

 .../selftests/breakpoints/breakpoint_test.c        | 10 +++---
 tools/testing/selftests/ipc/msgque.c               | 26 +++++++-------
 tools/testing/selftests/kcmp/kcmp_test.c           | 27 ++++++++++----
 tools/testing/selftests/kselftest.h                | 41 ++++++++++++++++++++++
 .../selftests/mount/unprivileged-remount-test.c    |  8 +++--
 tools/testing/selftests/ptrace/peeksiginfo.c       | 14 ++++----
 tools/testing/selftests/timers/posix_timers.c      | 14 ++++----
 7 files changed, 101 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.h

-- 
1.9.1

