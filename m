Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3JDT5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:57:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:50672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3JDT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="388047492"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 0/3] gpio-langwell: initial support for Intel Merrifield
Date: Fri,  4 Oct 2013 13:01:39 -0700
Message-Id: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does initial support for Intel Merrifield and does non-function
changes to make gpio-langwell more friendly to other Intel Mid SoC's.

After these initial changes are accepted, more Merrifield stuff will come :)

David Cohen (3):
  gpio: langwell: add Intel Merrifield support
  gpio: rename gpio-langwell to gpio-intel-mid
  gpio-intel-mid: update prefixes and names from langwell to intel-mid

 drivers/gpio/Kconfig          |   6 +-
 drivers/gpio/Makefile         |   2 +-
 drivers/gpio/gpio-intel-mid.c | 471 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-langwell.c  | 397 -----------------------------------
 4 files changed, 475 insertions(+), 401 deletions(-)
 create mode 100644 drivers/gpio/gpio-intel-mid.c
 delete mode 100644 drivers/gpio/gpio-langwell.c

-- 
1.8.4.rc3

