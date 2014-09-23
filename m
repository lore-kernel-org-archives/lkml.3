Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaIWTD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:03:58 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:36455 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaIWTD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:03:56 -0400
From: Peter Feiner <pfeiner@google.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: [PATCH 0/3] tools: selftests cleanup
Date: Tue, 23 Sep 2014 12:03:47 -0700
Message-Id: <1411499027-17801-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of small patches to make working with selftests easier.

Peter Feiner (3):
  tools: add .gitignore entries for selftests
  tools: fix warning in memfd_test
  tools: parallel selftests building & running

 tools/testing/selftests/Makefile               | 49 +++++++++++---------------
 tools/testing/selftests/breakpoints/.gitignore |  1 +
 tools/testing/selftests/efivarfs/.gitignore    |  2 ++
 tools/testing/selftests/memfd/memfd_test.c     |  2 +-
 tools/testing/selftests/ptrace/.gitignore      |  1 +
 tools/testing/selftests/timers/.gitignore      |  1 +
 tools/testing/selftests/user/Makefile          |  2 ++
 tools/testing/selftests/vm/.gitignore          |  9 ++---
 8 files changed, 33 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 create mode 100644 tools/testing/selftests/ptrace/.gitignore
 create mode 100644 tools/testing/selftests/timers/.gitignore

-- 
2.1.0.rc2.206.gedb03e5

