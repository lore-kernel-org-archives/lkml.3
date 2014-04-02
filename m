Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaDBPbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbaDBPbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:31:32 -0400
Date: Wed, 2 Apr 2014 10:31:28 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.15
Message-ID: <20140402153128.GA24920@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.15

This set includes a couple trivial cleanups and changes recovery
log messages from DEBUG to INFO.
Thanks,
Dave

Dan Carpenter (1):
      dlm: silence a harmless use after free warning

David Teigland (1):
      dlm: use INFO for recovery messages

Rashika Kheria (1):
      fs: Include appropriate header file in dlm/ast.c

 fs/dlm/ast.c          |  3 ++-
 fs/dlm/dir.c          |  4 ++--
 fs/dlm/dlm_internal.h |  2 ++
 fs/dlm/lock.c         |  7 ++++---
 fs/dlm/lockspace.c    |  8 ++++----
 fs/dlm/member.c       | 27 ++++++++++++---------------
 fs/dlm/recover.c      | 10 +++++-----
 fs/dlm/recoverd.c     | 34 +++++++++++++++++-----------------
 8 files changed, 48 insertions(+), 47 deletions(-)

