Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaFESNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:13:52 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:31448 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbaFESNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:13:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsENAAyykFNXQDfT/2dsb2JhbABZgwesCQUBmCeBDxd0gwIjgRqIfQHTSYVViH0dhCoEmhOTOYM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/3] QNX6 logging clean-up
Date: Thu,  5 Jun 2014 20:12:10 +0200
Message-Id: <1401991933-7377-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset converts QNX6 to current logging functions.

Fabian Frederick (3):
  FS/QNX6: Convert printk to pr_foo()
  FS/QNX6: use pr_fmt and __func__ in logging
  FS/QNX6: update debugging to current functions.

 fs/qnx6/Makefile    |  1 +
 fs/qnx6/dir.c       | 26 +++++++-------
 fs/qnx6/inode.c     | 99 ++++++++++++++++++++++-------------------------------
 fs/qnx6/namei.c     |  6 ++--
 fs/qnx6/qnx6.h      | 12 +++----
 fs/qnx6/super_mmi.c | 22 ++++++------
 6 files changed, 72 insertions(+), 94 deletions(-)

-- 
1.8.4.5

