Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab3GPRFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:05:17 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:55090 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3GPRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:15 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 0/7] Minor Alpha updates for 3.11
Date: Tue, 16 Jul 2013 10:04:33 -0700
Message-Id: <1373994280-12047-1-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a set of minor updates for arch/alpha that should not
be controversial.


r~


The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-07-14 21:47:51 -0700)

are available in the git repository at:


  git://github.com/rth7680/linux.git axp-next

for you to fetch changes up to fd60fe7052eceab1b1e7c8691263ec2b2634ace0:

  alpha: Fix type compatibility warning for marvel_map_irq (2013-07-16 09:55:06 -0700)

----------------------------------------------------------------
Richard Henderson (7):
      alpha: Add kcmp and finit_module syscalls
      alpha: Eliminate compiler warning from memset macro
      alpha: Modernize lib/mpi/longlong.h
      alpha: Improve atomic_add_unless
      alpha: Implement atomic64_dec_if_positive
      alpha: Generate dwarf2 unwind info for various kernel entry points.
      alpha: Fix type compatibility warning for marvel_map_irq

 arch/alpha/Kconfig                   |   1 +
 arch/alpha/include/asm/atomic.h      |  88 ++++++--
 arch/alpha/include/asm/string.h      |  18 +-
 arch/alpha/include/asm/unistd.h      |   3 +-
 arch/alpha/include/uapi/asm/unistd.h |   2 +
 arch/alpha/kernel/entry.S            | 399 +++++++++++++++++++++++++----------
 arch/alpha/kernel/sys_marvel.c       |   3 +-
 arch/alpha/kernel/systbls.S          |   2 +
 lib/mpi/longlong.h                   |  17 +-
 9 files changed, 380 insertions(+), 153 deletions(-)
