Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaKXOpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:45:38 -0500
Received: from kanga.kvack.org ([205.233.56.17]:53785 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbaKXOph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:45:37 -0500
Date: Mon, 24 Nov 2014 09:45:34 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-aio@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: [GIT PULL] aio: dirty page accounting fix
Message-ID: <20141124144534.GA19869@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning Linus and all,

The following changes since commit 6098b45b32e6baeacc04790773ced9340601d511:

  aio: block exit_aio() until all context requests are completed (2014-09-04 16:54:47 -0400)

are available in the git repository at:

  git://git.kvack.org/~bcrl/aio-fixes.git master

for you to fetch changes up to 835f252c6debd204fcd607c79975089b1ecd3472:

  aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer (2014-11-06 14:27:19 -0500)

----------------------------------------------------------------
Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer

 fs/aio.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)
-- 
"Thought is the essence of where you are now."
