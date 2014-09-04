Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaIDU5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:57:20 -0400
Received: from kanga.kvack.org ([205.233.56.17]:59139 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbaIDU5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:57:19 -0400
Date: Thu, 4 Sep 2014 16:57:18 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] aio: 2 small fixes for 3.17
Message-ID: <20140904205718.GF13422@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7be141d0554921751db103b54e9f794956aa4f65:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-08-24 16:17:41 -0700)

are available in the git repository at:


  git://git.kvack.org/~bcrl/aio-fixes.git master

for you to fetch changes up to 6098b45b32e6baeacc04790773ced9340601d511:

  aio: block exit_aio() until all context requests are completed (2014-09-04 16:54:47 -0400)

----------------------------------------------------------------
Gu Zheng (1):
      aio: block exit_aio() until all context requests are completed

Jeff Moyer (1):
      aio: add missing smp_rmb() in read_events_ring

 fs/aio.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)
-- 
"Thought is the essence of where you are now."
