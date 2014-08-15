Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaHOTY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:24:29 -0400
Received: from ozlabs.org ([103.22.144.67]:44440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaHOTY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:24:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PULL] Module fixes
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 16 Aug 2014 04:51:18 +0930
Message-ID: <87bnrl8spd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9d26423e56ce1ab4d786f92aebecf859d419293:

  Merge tag 'pm+acpi-3.17-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-08-14 18:13:46 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to ff7e0055bb5ddbbb320cdd8dfd3e18672bddd2ad:

  module: Clean up ro/nx after early module load failures (2014-08-16 04:47:00 +0930)

----------------------------------------------------------------
Nasty potential bug if someone uses a known module param with an invalid
value (we don't fail unknown module params any more, just warn).

Cheers,
Rusty.

----------------------------------------------------------------
Andy Lutomirski (1):
      module: Clean up ro/nx after early module load failures

 kernel/module.c | 5 +++++
 1 file changed, 5 insertions(+)

