Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaJFQrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:47:16 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39589 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbaJFQrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:47:13 -0400
Message-ID: <5432C788.50609@osg.samsung.com>
Date: Mon, 06 Oct 2014 10:47:04 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL] kselftest 3.18-updates-1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the updates for kselftest for 3.18. Please see
details in the signed tag.

thanks,
-- Shuah

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:


git@gitolite.kernel.org:/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/kselftest-3.18-updates-1

for you to fetch changes up to ce6a144a0d01c6628496e4c0d18fbf3a0362cc67:

  selftests/memfd: Run test on all architectures (2014-09-17 08:00:16 -0600)

----------------------------------------------------------------
kselftest Updates for 3.18
- Fix for missing arguments to printf
- Fix to build failures on 32-bit systems.
- Enhancement to run memfd_test run on all architectures
  as most architectures support __NR_memfd_create
----------------------------------------------------------------
Pranith Kumar (3):
      memfd_test: Make it work on 32-bit systems
      memfd_test: Add missing argument to printf()
      selftests/memfd: Run test on all architectures

 tools/testing/selftests/memfd/Makefile     | 21 -----------------
 tools/testing/selftests/memfd/memfd_test.c | 36
++++++++++++++----------------
 2 files changed, 17 insertions(+), 40 deletions(-)


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
