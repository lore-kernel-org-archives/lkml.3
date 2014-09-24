Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaIXTmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:42:18 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:55846 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaIXTmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:42:15 -0400
From: Peter Feiner <pfeiner@google.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: [PATCH v2 0/3] tools: selftests cleanup
Date: Wed, 24 Sep 2014 12:42:08 -0700
Message-Id: <1411587731-25088-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411499027-17801-1-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of small patches to make working with selftests easier.

v1 -> v2:
	Addressed Shuah's comments. 
v2 -> v3:
	Forgot Signed-off-by footer.

*** BLURB HERE ***

Peter Feiner (3):
  tools: add .gitignore entries for selftests
  tools: adding clean target to user selftest
  tools: parallel selftests building & running

 tools/testing/selftests/Makefile               | 49 +++++++++++---------------
 tools/testing/selftests/breakpoints/.gitignore |  1 +
 tools/testing/selftests/efivarfs/.gitignore    |  2 ++
 tools/testing/selftests/mount/.gitignore       |  1 +
 tools/testing/selftests/ptrace/.gitignore      |  1 +
 tools/testing/selftests/timers/.gitignore      |  1 +
 tools/testing/selftests/user/Makefile          |  2 ++
 tools/testing/selftests/vm/.gitignore          |  9 ++---
 8 files changed, 33 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 create mode 100644 tools/testing/selftests/mount/.gitignore
 create mode 100644 tools/testing/selftests/ptrace/.gitignore
 create mode 100644 tools/testing/selftests/timers/.gitignore

-- 
2.1.0.rc2.206.gedb03e5

