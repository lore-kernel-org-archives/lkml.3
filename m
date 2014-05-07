Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaEGAMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:12:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62519 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaEGAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:12:40 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH 0/2] Add test to validate udelay
Date: Tue,  6 May 2014 17:12:21 -0700
Message-Id: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a module and a script that makes use of it to
validate that udelay delays for at least as long as requested
(as compared to ktime).

David Riley (2):
  kernel: time: Add udelay_test module to validate udelay
  tools: add script to test udelay

 kernel/time/Kconfig       |    7 ++
 kernel/time/Makefile      |    1 +
 kernel/time/udelay_test.c |  166 +++++++++++++++++++++++++++++++++++++++++++++
 tools/time/udelay_test.sh |   66 ++++++++++++++++++
 4 files changed, 240 insertions(+)
 create mode 100644 kernel/time/udelay_test.c
 create mode 100644 tools/time/udelay_test.sh

-- 
1.7.9.5

