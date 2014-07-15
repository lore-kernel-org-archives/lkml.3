Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaGOUUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:20:22 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:61505 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757214AbaGOUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:20:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoQANmLxVNbsm9N/2dsb2JhbABZgw6tZQsFAW6cAIEQF3WEYCOBGoh9Aco3F4V7iVAdhC0FmxiUJYNGOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/3] SYSV FS Logging update
Date: Tue, 15 Jul 2014 22:20:18 +0200
Message-Id: <1405455622-12729-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset converts SYSV FS to current logging functions.

Note that all pr_foo() are now prefixed which means logging is slightly different.
(see patch 2 for more details).

Fabian Frederick (3):
  FS/SYSV: Convert printk to pr_foo()
  FS/SYSV: add SysV FS: pr_fmt in sysv.h
  FS/SYSV: use __func__ in logging

 fs/sysv/balloc.c | 26 +++++++++++++-------------
 fs/sysv/ialloc.c | 13 ++++++-------
 fs/sysv/inode.c  | 12 ++++++------
 fs/sysv/itree.c  |  2 +-
 fs/sysv/super.c  | 26 ++++++++++++--------------
 fs/sysv/sysv.h   |  6 ++++++
 6 files changed, 44 insertions(+), 41 deletions(-)

-- 
1.8.4.5

