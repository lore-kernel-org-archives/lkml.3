Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3HZVpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:45:18 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34343 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3HZVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:45:16 -0400
Date: Mon, 26 Aug 2013 14:45:26 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Bcache fix for 3.11
Message-ID: <20130826214526.GB2798@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last writeback fix had a brown paper bag bug in it. The fix for that is
a one liner though:

The following changes since commit 9df79a37eeb7ee89dc56aeed3051be676369359a:

  bcache: Fix a flush/fua performance bug (2013-08-19 15:30:45 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to 174c1412939888ffedc4da02b375bc579af2a93c:

  bcache: Fix a dumb CPU spinning bug in writeback (2013-08-23 16:30:22 -0700)

----------------------------------------------------------------
Kent Overstreet (1):
      bcache: Fix a dumb CPU spinning bug in writeback

 drivers/md/bcache/writeback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
