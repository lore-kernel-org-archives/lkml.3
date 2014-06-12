Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaFLUNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:13:39 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:64377 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaFLUNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:13:37 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH v3 0/2] Add test to validate udelay
Date: Thu, 12 Jun 2014 13:13:10 -0700
Message-Id: <1402603992-12466-1-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a module and a script that makes use of it to
validate that udelay delays for at least as long as requested
(as compared to ktime).

Changes since v1:
- allow udelay() to be 0.5% faster than requested as per feedback

Changes since v2:
- fix permissions on udelay_test.sh script
- update commit message to indicate what this test targets
- fixed checkpatch whitespace error
- rebased

David Riley (2):
  kernel: time: Add udelay_test module to validate udelay
  tools: add script to test udelay

 kernel/time/Kconfig       |   7 ++
 kernel/time/Makefile      |   1 +
 kernel/time/udelay_test.c | 170 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/time/udelay_test.sh |  66 ++++++++++++++++++
 4 files changed, 244 insertions(+)
 create mode 100644 kernel/time/udelay_test.c
 create mode 100755 tools/time/udelay_test.sh

-- 
2.0.0.526.g5318336

