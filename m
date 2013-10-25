Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3JYOZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:25:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58086 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3JYOZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:25:49 -0400
Date: Fri, 25 Oct 2013 15:25:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] a couple of fixes for rc7
Message-ID: <20131025142547.GE13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfsd performance regression fix + seq_file lseek(2) fix.
Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      nfsd regression since delayed fput()

Gu Zheng (1):
      seq_file: always update file->f_pos in seq_lseek()

Diffstat:
 fs/file_table.c |    2 +-
 fs/seq_file.c   |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

