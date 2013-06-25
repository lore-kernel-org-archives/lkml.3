Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3FYKkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:40:10 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50809 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3FYKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:40:07 -0400
Date: Tue, 25 Jun 2013 12:39:58 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <mpatlasov@parallels.com>
Subject: [GIT PULL] fuse bugfix for 3.10
Message-ID: <20130625103958.GA32047@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bugfix for fuse:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus


It fixes a race between fallocate() and truncate().

Thanks,
Miklos

---
Maxim Patlasov (1):
      fuse: hold i_mutex in fuse_file_fallocate()

---
 fs/fuse/file.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
