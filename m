Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbaIOWkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:40:24 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:37291
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbaIOWkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:40:20 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] kselftest new exit codes and test changes to use them
Date: Mon, 15 Sep 2014 16:33:55 -0600
Message-Id: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a new header file for kselftest defines
for individual tests to report test results, and changes to
several tests to use the new header file and exit codes.

Shuah Khan (7):
  selftests: add header file for test exit code defines
  selftests/breakpoints: change breakpoints test to use kselftest exit
    codes
  selftests/ipc: change ipc test to use kselftest exit codes
  selftests/kcmp: change kcmp test to use kselftest exit codes
  selftests/mount: change mount test to use kselftest exit codes
  selftests/ptrace: change ptrace test to use kselftest exit codes
  selftests/timers: change timers test to use kselftest exit codes

 .../selftests/breakpoints/breakpoint_test.c        | 10 +++++----
 tools/testing/selftests/ipc/msgque.c               | 26 ++++++++++++----------
 tools/testing/selftests/kcmp/kcmp_test.c           | 16 +++++++------
 tools/testing/selftests/kselftest.h                | 20 +++++++++++++++++
 .../selftests/mount/unprivileged-remount-test.c    | 10 +++++----
 tools/testing/selftests/ptrace/peeksiginfo.c       | 21 ++++++++---------
 tools/testing/selftests/timers/posix_timers.c      | 19 +++++++++-------
 7 files changed, 77 insertions(+), 45 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.h

-- 
1.9.1

