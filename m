Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3JRTvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:51:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3JRTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:51:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/7] 3.0.101-stable review
Date: Fri, 18 Oct 2013 12:52:47 -0700
Message-Id: <20131018195036.020644622@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:
  This is the LAST 3.0.x stable kernel release that I will be doing.
  After this release, 3.0.x is End-Of-Life, please move to the 3.10.x,
  or if you must, 3.4.x series.  For more information about longterm
  stable releases and how long they will be maintained, please see
  https://www.kernel.org/category/releases.html

This is the start of the stable review cycle for the 3.0.101 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 20 19:50:26 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.101-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.101-rc1

Eric Dumazet <eric.dumazet@gmail.com>
    ipv6: tcp: fix panic in SYN processing

wojciech kapuscinski <wojtask9@wp.pl>
    drm/radeon: fix hw contexts for SUMO2 asics

Dan Carpenter <dan.carpenter@oracle.com>
    watchdog: ts72xx_wdt: locking bug in ioctl

Helge Deller <deller@gmx.de>
    parisc: fix interruption handler to respect pagefault_disable()

Dave Jones <davej@redhat.com>
    ext4: fix memory leak in xattr

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: allow O_PATH file descriptors for fstatfs()

Theodore Ts'o <tytso@mit.edu>
    random: run random_int_secret_init() run after all late_initcalls


-------------

Diffstat:

 Makefile                           | 4 ++--
 arch/parisc/kernel/traps.c         | 6 +++---
 drivers/char/random.c              | 3 +--
 drivers/gpu/drm/radeon/evergreen.c | 2 +-
 drivers/watchdog/ts72xx_wdt.c      | 3 ++-
 fs/ext4/xattr.c                    | 2 ++
 fs/statfs.c                        | 2 +-
 include/linux/random.h             | 1 +
 init/main.c                        | 2 ++
 net/ipv6/inet6_connection_sock.c   | 2 +-
 10 files changed, 16 insertions(+), 11 deletions(-)


