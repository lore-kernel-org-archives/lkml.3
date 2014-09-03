Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbaICLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:21:31 -0400
Received: from syn.loicp.eu ([176.31.96.212]:44672 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbaICLUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:20:31 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] staging: goldfish: fix coding style warnings
Date: Wed,  3 Sep 2014 13:13:41 +0200
Message-Id: <1409742827-6048-1-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset (for next-20140902) fixes several coding style warnings found by checkpatch.pl:
-CHECK: Please don't use multiple blank lines
-CHECK: No space is necessary after a cast
-CHECK: spinlock_t definition without comment
-CHECK: Alignment should match open parenthesis
-CHECK: struct mutex definition without comment


Loic Pefferkorn (6):
  staging: goldfish: suppress consecutive blank lines
  staging: goldfish: remove useless space after a cast
  staging: goldfish: document spinlock usage
  staging: goldfish: fix alignment to match open parenthesis
  staging: goldfish: document mutex usage
  staging: goldfish: avoid multiple assignments

 drivers/staging/goldfish/goldfish_audio.c | 25 ++++++++----------
 drivers/staging/goldfish/goldfish_nand.c  | 43 ++++++++++++++++---------------
 2 files changed, 33 insertions(+), 35 deletions(-)

-- 
2.0.4

