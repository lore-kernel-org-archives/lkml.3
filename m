Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaICUXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:23:31 -0400
Received: from syn.loicp.eu ([176.31.96.212]:56922 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaICUX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:23:29 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] staging: goldfish: fix coding style
Date: Wed,  3 Sep 2014 22:23:09 +0200
Message-Id: <1409775795-12521-1-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset fixes several coding style warnings detected by checkpatch.pl:
-CHECK: Please don't use multiple blank lines
-CHECK: No space is necessary after a cast
-CHECK: spinlock_t definition without comment
-CHECK: Alignment should match open parenthesis
-CHECK: struct mutex definition without comment
-CHECK: multiple assignments should be avoided

v2 changes:
-document more specifically the usage of mutex and spinlock

Loic Pefferkorn (6):
  staging: goldfish: suppress consecutive blank lines
  staging: goldfish: remove useless space after a cast
  staging: goldfish: document spinlock usage
  staging: goldfish: fix alignment to match open parenthesis
  staging: goldfish: document mutex usage
  staging: goldfish: avoid multiple assignments

 drivers/staging/goldfish/goldfish_audio.c | 24 ++++++++----------
 drivers/staging/goldfish/goldfish_nand.c  | 42 ++++++++++++++++---------------
 2 files changed, 33 insertions(+), 33 deletions(-)

-- 
2.0.4

