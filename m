Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3AVJpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:45:51 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:35921 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3AVJpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:45:47 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
Date: Tue, 22 Jan 2013 10:45:46 +0100
Message-ID: <CAJfpegsca9Dv0HdubPnQBe0njCewnMuAfRfBzhP7GsHuMRyWQw@mail.gmail.com>
Subject: [GIT PULL] fuse bugfixes for 3.8
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for fuse:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This contain a bugfix for CUSE and miscellaneous small fixes.

Thanks,
Miklos
----

David Herrmann (2):
      cuse: use mutex as registration lock instead of spinlocks
      cuse: do not register multiple devices with identical names

Miklos Szeredi (2):
      cuse: fix uninitialized variable warnings
      fuse: make fuse_file_fallocate() static

Robert P. J. Day (1):
      fuse: Move CUSE Kconfig entry from fs/Kconfig into fs/fuse/Kconfig

Wei Yongjun (1):
      fuse: remove unused variable in fuse_try_move_page()

---
 fs/Kconfig      |   10 ----------
 fs/fuse/Kconfig |   16 ++++++++++++++--
 fs/fuse/cuse.c  |   36 ++++++++++++++++++++++--------------
 fs/fuse/dev.c   |    5 -----
 fs/fuse/file.c  |    5 ++---
 5 files changed, 38 insertions(+), 34 deletions(-)
