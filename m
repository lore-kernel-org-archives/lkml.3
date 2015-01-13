Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbbAMSHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:07:17 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49910 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbbAMSHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:07:14 -0500
Message-ID: <54B55ED0.5000607@osg.samsung.com>
Date: Tue, 13 Jan 2015 11:07:12 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        shuahkh@osg.samsung.com
Subject: [GIT PULL] kselftest fixes for 3.19-rc5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following ksefltest fixes for 3.19-rc5

thanks,
-- Shuah

The following changes since commit 6898b627aab6ba553e6d8b40a0b1ddc43c48d42f:

  selftests/exec: Use %zu to format size_t (2014-12-22 11:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.19-rc-5

for you to fetch changes up to f5db310d77ef1742e40bfc303b8625584c55f9e3:

  selftests/vm: fix link error for transhuge-stress test (2015-01-08
09:01:00 -0700)

----------------------------------------------------------------
kselftest fixes for: 3.19-rc5

This update contains 3 patches to fix one compile error,
and two run-time bugs. One of them fixes infinite loop
on ARM.

----------------------------------------------------------------
Andrey Skvortsov (1):
      selftests/vm: fix link error for transhuge-stress test

David Drysdale (1):
      selftests/exec: allow shell return code of 126

dann frazier (1):
      tools: testing: selftests: mq_perf_tests: Fix infinite loop on ARM

 tools/testing/selftests/exec/execveat.c        | 19 +++++++++++++------
 tools/testing/selftests/mqueue/mq_perf_tests.c |  3 +--
 tools/testing/selftests/vm/Makefile            |  2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
