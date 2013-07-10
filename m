Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3GJD7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:59:42 -0400
Received: from ozlabs.org ([203.10.76.45]:41364 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab3GJD7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:59:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jim Hull <jim.hull@hp.com>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Rob Landley <rob@landley.net>
Subject: [PULL] modules-next
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Jul 2013 13:25:39 +0930
Message-ID: <878v1fcblw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 06df44ee41442d83be061c5fd1b1de4f5fc6fbbf:

  modpost.c: Add .text.unlikely to TEXT_SECTIONS (2013-05-20 12:08:45 +0930)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to 9eb76d7797b892a1dad4f2efb6f786681306dd13:

  module: cleanup call chain. (2013-07-03 10:15:10 +0930)

----------------------------------------------------------------
Nothing interesting.  Except the most embarrassing bugfix ever.  But let's
ignore that.

Cheers,
Rusty.

----------------------------------------------------------------
Jean Delvare (2):
      There is no /sys/parameters
      ABI: Clarify when /sys/module/MODULENAME is created

Mathias Krause (1):
      module: don't modify argument of module_kallsyms_lookup_name()

Rusty Russell (3):
      modules: don't fail to load on unknown parameters.
      module: do percpu allocation after uniqueness check.  No, really!
      module: cleanup call chain.

 Documentation/ABI/stable/sysfs-module | 10 +++--
 include/linux/moduleparam.h           |  2 +-
 kernel/module.c                       | 77 +++++++++++++++++++----------------
 kernel/params.c                       |  2 +-
 4 files changed, 52 insertions(+), 39 deletions(-)
