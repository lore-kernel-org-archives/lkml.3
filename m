Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3KBBPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 21:15:46 -0400
Received: from ozlabs.org ([203.10.76.45]:37708 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3KBBPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 21:15:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Michal Marek <mmarek@suse.cz>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [PULL] symbol fix for ARM kallsyms
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 02 Nov 2013 09:16:40 +1030
Message-ID: <87txfvagfj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 12aee278b50c4a94a93fa0b4d201ae35d792c696:

  Merge branch 'akpm' (fixes from Andrew Morton) (2013-10-30 14:27:10 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to f6537f2f0eba4eba3354e48dbe3047db6d8b6254:

  scripts/kallsyms: filter symbols not in kernel address space (2013-11-02 09:13:02 +1030)

----------------------------------------------------------------
Last minute perf unbreakage for ARM modules; spent a day in linux-next.

----------------------------------------------------------------
Ming Lei (1):
      scripts/kallsyms: filter symbols not in kernel address space

 scripts/kallsyms.c      | 12 +++++++++++-
 scripts/link-vmlinux.sh |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)
