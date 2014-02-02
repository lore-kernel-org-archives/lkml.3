Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBBJOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:14:11 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54004 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBBJOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:14:08 -0500
MIME-Version: 1.0
Date: Sun, 2 Feb 2014 11:14:08 +0200
X-Google-Sender-Auth: Tg7VzeMJn7nOjHn1hku8omMbT9c
Message-ID: <CAOJsxLEF-0=D3pvEUVb2r38vsn01kH_6rHyOioGFEJ_6wDwjrA@mail.gmail.com>
Subject: [GIT PULL] SLAB changes for v3.14-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

It contains random bug fixes that have accumulated in my inbox over
the past few months.

                        Pekka

------------------>
The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

for you to fetch changes up to cb8ee1a3d429f8898972c869dd4792afb04e961a:

  mm: Fix warning on make htmldocs caused by slab.c (2014-01-31 13:52:25 +0200)

----------------------------------------------------------------
Dave Hansen (2):
      mm: sl[uo]b: fix misleading comments
      mm: slub: work around unneeded lockdep warning

Li Zefan (1):
      slub: Fix calculation of cpu slabs

Masanari Iida (1):
      mm: Fix warning on make htmldocs caused by slab.c

Peter Zijlstra (1):
      slub: use lockdep_assert_held

Randy Dunlap (1):
      slab.h: remove duplicate kmalloc declaration and fix kernel-doc warnings

Tetsuo Handa (1):
      slub: Fix possible format string bug.

 include/linux/slab.h | 110 +++++++++++++++++++++++----------------------------
 mm/slab.c            |   2 +-
 mm/slub.c            |  56 +++++++++++++++-----------
 3 files changed, 85 insertions(+), 83 deletions(-)
