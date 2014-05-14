Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaENWbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:31:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53118 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaENWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:31:16 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH v2 0/2] Add test to validate udelay
Date: Wed, 14 May 2014 15:30:15 -0700
Message-Id: <1400106617-17085-1-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a module and a script that makes use of it to
validate that udelay delays for at least as long as requested
(as compared to ktime).

Changes since v1:
- allow udelay() to be 0.5% faster than requested as per feedback

David Riley (2):
  kernel: time: Add udelay_test module to validate udelay
  tools: add script to test udelay

 kernel/time/Kconfig       |    7 ++
 kernel/time/Makefile      |    1 +
 kernel/time/udelay_test.c |  169 +++++++++++++++++++++++++++++++++++++++++++++
 tools/time/udelay_test.sh |   66 ++++++++++++++++++
 4 files changed, 243 insertions(+)
 create mode 100644 kernel/time/udelay_test.c
 create mode 100644 tools/time/udelay_test.sh

-- 
1.7.9.5

