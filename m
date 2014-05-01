Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859AbaEAEoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:44:44 -0400
Received: from ozlabs.org ([103.22.144.67]:33408 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaEAEon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:44:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Elliott@ozlabs.org, Robert (Server Storage) <Elliott@hp.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valerio Vanni <valerio.vanni@inwind.it>
Subject: [PULL] two module fixes
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 01 May 2014 14:13:08 +0930
Message-ID: <87lhum2joj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4d0fa8a0f01272d4de33704f20303dcecdb55df1:

  Merge tag 'gpio-v3.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2014-04-22 09:28:02 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to 79465d2fd48e68940c2bdecddbdecd45bbba06fe:

  module: remove warning about waiting module removal. (2014-04-28 11:06:59 +0930)

----------------------------------------------------------------
Fixed one missing place for the new taint flag, and remove a warning
giving only false positives (now we finally figured out why).

Cheers,
Rusty.

----------------------------------------------------------------
Mathieu Desnoyers (1):
      Fix: tracing: use 'E' instead of 'X' for unsigned module tain flag

Rusty Russell (1):
      module: remove warning about waiting module removal.

 include/trace/events/module.h | 2 +-
 kernel/module.c               | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)
