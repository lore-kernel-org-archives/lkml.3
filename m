Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3LFPql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:46:41 -0500
Received: from kanga.kvack.org ([205.233.56.17]:37246 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab3LFPqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:46:40 -0500
Date: Fri, 6 Dec 2013 10:46:39 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT pull] aio fix from Gu Zheng for 3.13
Message-ID: <20131206154639.GF13581@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following change from Gu Zheng that fixes a GPF that Dave 
Jones uncovered with trinity.

		-ben

The following changes since commit ddb8c45ba15149ebd41d7586261c05f7ca37f9a1:

  aio: nullify aio->ring_pages after freeing it (2013-11-19 17:40:48 -0500)

are available in the git repository at:

  git://git.kvack.org/~bcrl/aio-next.git master

for you to fetch changes up to d1b9432712a25eeb06114fb4b587133525a47de5:

  aio: clean up aio ring in the fail path (2013-12-06 10:22:55 -0500)

----------------------------------------------------------------
Gu Zheng (1):
      aio: clean up aio ring in the fail path

 fs/aio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
-- 
"Thought is the essence of where you are now."
