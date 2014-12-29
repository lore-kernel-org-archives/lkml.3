Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaL2Lwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:52:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:29881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaL2Lwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:52:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="654420255"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/4] hexdump: amend the hex_dump_to_buffer()
Date: Mon, 29 Dec 2014 13:50:50 +0200
Message-Id: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is targeted to amend hex_dump_to_buffer() function. It consists
test suite, fix for output format and features the function by adding return
code.

With those changes the function would be used for seq_file API.

Andy Shevchenko (4):
  hexdump: introduce test suite
  hexdump: fix ascii column for the tail of a dump
  hexdump: do few calculations ahead
  hexdump: makes it return amount of bytes placed in buffer

 include/linux/printk.h |   6 +-
 lib/Kconfig.debug      |   3 +
 lib/Makefile           |   4 +-
 lib/hexdump.c          | 105 ++++++++++++++++++-----------
 lib/test-hexdump.c     | 180 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 253 insertions(+), 45 deletions(-)
 create mode 100644 lib/test-hexdump.c

-- 
2.1.3

