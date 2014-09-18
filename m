Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaIRPEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:04:42 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38845 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbaIRPEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:04:38 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH 0/1] nilfs2: fix data loss with mmap() 
Date: Thu, 18 Sep 2014 23:56:24 +0900
Message-Id: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.4
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Please apply the following bugfix and send it to upstream.

It fixes a regression of nilfs2's mmap which was brought by the commit
136e8770cd5d1fe3 "nilfs2: fix issue of nilfs_set_page_dirty() for page
at EOF boundary".  Andreas Rohner recently found that the commit was
not perfect and causing reproducible silent data loss issue.

Thanks in advance,

Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

 fs/nilfs2/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

