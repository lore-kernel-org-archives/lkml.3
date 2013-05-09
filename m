Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3EIT07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:26:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34275 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3EIT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:26:57 -0400
Date: Thu, 9 May 2013 20:26:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs.git stuff
Message-ID: <20130509192655.GG25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Regression fix from Geert + yet another open-coded kernel_read().
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Shortlog:
Al Viro (1):
      ecryptfs: don't open-code kernel_read()

Geert Uytterhoeven (1):
      xtensa simdisk: Fix proc_create_data() conversion fallout

Diffstat:
 arch/xtensa/platforms/iss/simdisk.c |    4 ++--
 fs/ecryptfs/read_write.c            |    9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)
