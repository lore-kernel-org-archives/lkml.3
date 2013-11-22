Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3KVAz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:55:29 -0500
Received: from kanga.kvack.org ([205.233.56.17]:42658 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3KVAzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:55:23 -0500
Date: Thu, 21 Nov 2013 19:55:22 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] aio fixes for 3.13
Message-ID: <20131122005522.GL14098@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit be408cd3e1fef73e9408b196a79b9934697fe3b1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-11-04 06:40:55 -0800)

are available in the git repository at:


  git://git.kvack.org/~bcrl/aio-next.git master

for you to fetch changes up to ddb8c45ba15149ebd41d7586261c05f7ca37f9a1:

  aio: nullify aio->ring_pages after freeing it (2013-11-19 17:40:48 -0500)

----------------------------------------------------------------
Benjamin LaHaise (1):
      Merge branch 'aio-fix' of http://evilpiepirate.org/git/linux-bcache

Kent Overstreet (1):
      aio: Fix a trinity splat

Sasha Levin (2):
      aio: prevent double free in ioctx_alloc
      aio: nullify aio->ring_pages after freeing it

 fs/aio.c | 134 ++++++++++++++++++++++++---------------------------------------
 1 file changed, 51 insertions(+), 83 deletions(-)
-- 
"Thought is the essence of where you are now."
