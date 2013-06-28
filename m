Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3F1XB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3F1XB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:01:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, takeuchi.akr@jp.panasonic.com,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MN10300 Fixes
Date: Sat, 29 Jun 2013 00:01:48 +0100
Message-ID: <20468.1372460508@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull these MN10300 fixes please?  The first fixes a problem with
passing arrays rather than pointers to get_user() where __typeof__ then wants
to declare and initialise an array variable which gcc doesn't like.  The
second fixes a problem whereby putting mem=xxx into the kernel command line
causes init=xxx to get an incorrect value.

Thanks,
David
---
The following changes since commit 98b6ed0f2bf4abfb759206aa70690636372bdee7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-26 19:24:37 -1000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-mn10300.git tags/for-linus-20130628

for you to fetch changes up to e3f12a53042e26202993baa3ad4ff8768173653d:

  mn10300: Use early_param() to parse "mem=" parameter (2013-06-28 16:53:03 +0100)

----------------------------------------------------------------
(from the branch description for for-linus local branch)

MN10300 patches for linus
MN10300 changes 2013-06-28

----------------------------------------------------------------
Akira Takeuchi (2):
      mn10300: Allow to pass array name to get_user()
      mn10300: Use early_param() to parse "mem=" parameter

 arch/mn10300/include/asm/uaccess.h |  2 +-
 arch/mn10300/kernel/setup.c        | 54 +++++++++++++++-----------------------
 2 files changed, 22 insertions(+), 34 deletions(-)
