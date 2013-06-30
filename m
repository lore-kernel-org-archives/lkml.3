Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3F3M42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 08:56:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46333 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3F3M4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 08:56:25 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Subject: [PATCH 0/4] Minor selftests cleanups
Date: Sun, 30 Jun 2013 18:23:07 +0530
Message-Id: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just ran a few of them.  Unsure about [4/4] because of aabccae6 and
a58130d.

Thanks.

Ramkumar Ramachandra (4):
  selftests: add .gitignore for vm
  selftests: fix clean target in kcmp Makefile
  selftests: add .gitignore for kcmp
  selftests: get {cpu,memory}-hotplug tests to run

 tools/testing/selftests/cpu-hotplug/on-off-test.sh    | 0
 tools/testing/selftests/kcmp/.gitignore               | 2 ++
 tools/testing/selftests/kcmp/Makefile                 | 3 +--
 tools/testing/selftests/memory-hotplug/on-off-test.sh | 0
 tools/testing/selftests/vm/.gitignore                 | 4 ++++
 5 files changed, 7 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/cpu-hotplug/on-off-test.sh
 create mode 100644 tools/testing/selftests/kcmp/.gitignore
 mode change 100644 => 100755 tools/testing/selftests/memory-hotplug/on-off-test.sh
 create mode 100644 tools/testing/selftests/vm/.gitignore

-- 
1.8.3.1.643.gebeea52.dirty

