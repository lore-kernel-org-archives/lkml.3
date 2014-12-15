Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949AbaLOVvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:51:25 -0500
Received: from lists.s-osg.org ([54.187.51.154]:40298 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaLOVvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:51:23 -0500
Message-ID: <548F57D8.4080809@osg.samsung.com>
Date: Mon, 15 Dec 2014 14:51:20 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL RESEND] kselftest-3.19-rc1
References: <548750AD.6090201@osg.samsung.com> <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ@mail.gmail.com> <548EEA88.2060206@osg.samsung.com>
In-Reply-To: <548EEA88.2060206@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Kselftest updates for 3.19-rc1. Hope
I have this right this time. Sorry again for the messed up
first request.

thanks,
-- Shuah

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.19-rc1

for you to fetch changes up to 3ce51050fadd63737c03627293ca2dc4be238891:

  selftest: size: Add size test for Linux kernel (2014-12-03 19:27:47 -0700)

----------------------------------------------------------------
kselftest updates for 3.19-rc1

----------------------------------------------------------------
Michael Ellerman (3):
      kcmp: Move kcmp.h into uapi
      selftests/kcmp: Don't include kernel headers
      selftests/kcmp: Always try to build the test

Shuah Khan (7):
      selftests/net: move test out of Makefile into a shell script
      selftests/user: move test out of Makefile into a shell script
      selftests: add kselftest framework for uniform test reporting
      selftests/breakpoints: change test to use ksft framework
      selftests/ipc: change test to use ksft framework
      selftests/kcmp: change test to use ksft framework
      selftests/timers: change test to use ksft framework

Tim Bird (1):
      selftest: size: Add size test for Linux kernel

 include/uapi/linux/Kbuild                          |   1 +
 include/{ => uapi}/linux/kcmp.h                    |   6 +-
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/breakpoints/breakpoint_test.c        |  10 ++-
 tools/testing/selftests/ipc/msgque.c               |  26 +++---
 tools/testing/selftests/kcmp/Makefile              |  22 +----
 tools/testing/selftests/kcmp/kcmp_test.c           |  27 ++++--
 tools/testing/selftests/kselftest.h                |  62 +++++++++++++
 tools/testing/selftests/net/Makefile               |   8 +-
 tools/testing/selftests/net/test_bpf.sh            |  10 +++
 tools/testing/selftests/size/.gitignore            |   1 +
 tools/testing/selftests/size/Makefile              |  12 +++
 tools/testing/selftests/size/get_size.c            | 100
+++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      |  14 +--
 tools/testing/selftests/user/Makefile              |   8 +-
 tools/testing/selftests/user/test_user_copy.sh     |  10 +++
 16 files changed, 252 insertions(+), 66 deletions(-)
 rename include/{ => uapi}/linux/kcmp.h (62%)
 create mode 100644 tools/testing/selftests/kselftest.h
tools/testing/selftests/net/Makefile               |   8 +-
 tools/testing/selftests/net/test_bpf.sh            |  10 +++
 tools/testing/selftests/size/.gitignore            |   1 +
 tools/testing/selftests/size/Makefile              |  12 +++
 tools/testing/selftests/size/get_size.c            | 100
+++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      |  14 +--
 tools/testing/selftests/user/Makefile              |   8 +-
 tools/testing/selftests/user/test_user_copy.sh     |  10 +++
 16 files changed, 252 insertions(+), 66 deletions(-)
 rename include/{ => uapi}/linux/kcmp.h (62%)
 create mode 100644 tools/testing/selftests/kselftest.h
 create mode 100755 tools/testing/selftests/net/test_bpf.sh
 create mode 100644 tools/testing/selftests/size/.gitignore
 create mode 100644 tools/testing/selftests/size/Makefile
 create mode 100644 tools/testing/selftests/size/get_size.c
 create mode 100755 tools/testing/selftests/user/test_user_copy.sh


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
