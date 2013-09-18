Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3IRM2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:28:16 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:61818 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3IRM2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:28:15 -0400
Date: Wed, 18 Sep 2013 14:28:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fuse bugfixes for 3.12
Message-ID: <20130918122844.GD31733@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Could you please pull the following fixes for fuse:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

These are data consistency fixes for fallocate.

Thanks,
Miklos

---
Maxim Patlasov (2):
      fuse: wait for writeback in fuse_file_fallocate()
      fuse: fix fallocate vs. ftruncate race

---
 fs/fuse/file.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)
