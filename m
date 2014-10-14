Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaJNRBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:01:31 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40658 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbaJNRB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:01:29 -0400
Message-ID: <543D56DB.1090108@osg.samsung.com>
Date: Tue, 14 Oct 2014 11:01:15 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL] kselftest 3.18-updates-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the second round updates for kselftest for 3.18. Please
see details in the signed tag.


The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:


git@gitolite.kernel.org:/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/kselftest-3.18-updates-2

for you to fetch changes up to 49296470830aa12027f4aa43ec54f19375be095b:

  selftests/timers: change test to use ksft framework (2014-10-06
08:29:20 -0600)

----------------------------------------------------------------
3.18 Kselftest updates-2:

This update adds a light weight kselftest framework that
provides a set of interfaces for tests to use to report
results. In addition, several tests are updated to use the
framework.

----------------------------------------------------------------
Shuah Khan (5):
      selftests: add kselftest framework for uniform test reporting
      selftests/breakpoints: change test to use ksft framework
      selftests/ipc: change test to use ksft framework
      selftests/kcmp: change test to use ksft framework
      selftests/timers: change test to use ksft framework

 .../selftests/breakpoints/breakpoint_test.c        | 10 ++--
 tools/testing/selftests/ipc/msgque.c               | 26 ++++-----
 tools/testing/selftests/kcmp/kcmp_test.c           | 27 +++++++---
 tools/testing/selftests/kselftest.h                | 62
++++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      | 14 ++---
 5 files changed, 110 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.h

thanks,
-- Shuah
-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
