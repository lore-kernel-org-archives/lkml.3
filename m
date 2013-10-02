Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3JBPf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:35:27 -0400
Received: from kanga.kvack.org ([205.233.56.17]:56192 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab3JBPfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:35:24 -0400
Date: Wed, 2 Oct 2013 11:35:24 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] aio fix for 3.12
Message-ID: <20131002153524.GF4353@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b97280675f45c1650ee4e388bd711ecbb18c4b4:

  Merge tag 'stable/for-linus-3.12-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip (2013-09-25 15:50:53 -0700)

are available in the git repository at:


  git://git.kvack.org/~bcrl/aio-next.git master

for you to fetch changes up to 5e9ae2e5da0beb93f8557fc92a8f4fbc05ea448f:

  aio: fix use-after-free in aio_migratepage (2013-09-26 20:34:51 -0400)

----------------------------------------------------------------
Benjamin LaHaise (1):
      aio: fix use-after-free in aio_migratepage

 fs/aio.c | 52 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 15 deletions(-)
-- 
"Thought is the essence of where you are now."
