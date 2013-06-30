Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3F3M5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 08:57:01 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42088 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3F3M4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 08:56:33 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Subject: [PATCH 4/4] selftests: get {cpu,memory}-hotplug tests to run
Date: Sun, 30 Jun 2013 18:23:11 +0530
Message-Id: <1372596791-12968-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
References: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu-hotplug and memory-hotplug tests don't run:

  $ sudo make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
  /bin/sh: ./on-off-test.sh: Permission denied

  $ sudo make -C tools/testing/selftests TARGETS=memory-hotplug run_tests
  /bin/sh: ./on-off-test.sh: Permission denied

Flip the executable bit fixing this.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/testing/selftests/cpu-hotplug/on-off-test.sh    | 0
 tools/testing/selftests/memory-hotplug/on-off-test.sh | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/cpu-hotplug/on-off-test.sh
 mode change 100644 => 100755 tools/testing/selftests/memory-hotplug/on-off-test.sh

diff --git a/tools/testing/selftests/cpu-hotplug/on-off-test.sh b/tools/testing/selftests/cpu-hotplug/on-off-test.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/memory-hotplug/on-off-test.sh b/tools/testing/selftests/memory-hotplug/on-off-test.sh
old mode 100644
new mode 100755
-- 
1.8.3.1.643.gebeea52.dirty

