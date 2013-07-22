Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3GVJjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:39:10 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46259 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3GVJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:39:08 -0400
Date: Mon, 22 Jul 2013 11:39:11 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [GIT PULL] fuse bugfixes for 3.11
Message-ID: <20130722093911.GB18358@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for fuse:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

These are bugfixes and a cleanup to the "readdirplus" feature.

Thanks,
Miklos

---
Miklos Szeredi (4):
      fuse: readdirplus: sanity checks
      fuse: readdirplus: fix instantiate
      fuse: readdirplus: change attributes once
      fuse: readdirplus: cleanup

Niels de Vos (1):
      fuse: readdirplus: fix dentry leak

---
 fs/fuse/dir.c | 51 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 15 deletions(-)
