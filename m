Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3HZWCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:02:40 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56599 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3HZWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:02:38 -0400
Date: Mon, 26 Aug 2013 15:02:49 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Bcache fixes for stable
Message-ID: <20130826220249.GF2798@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes that went into 3.11 should've been marked for stable, but I
screwed up and forgot to mark them.

One of them fixes bugs that appear to being hit in the wild, so please
pull these:

The following changes since commit 0a4b6d4ff200a553951f77f765971cb3e4c91ec0:

  Linux 3.10.9 (2013-08-20 15:40:47 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.10

for you to fetch changes up to a213846fafcdf52153dfebf8b1671498a72b6285:

  bcache: FUA fixes (2013-08-26 14:56:52 -0700)

----------------------------------------------------------------
Kent Overstreet (1):
      bcache: FUA fixes

Kumar Amit Mehta (1):
      md: bcache: io.c: fix a potential NULL pointer dereference

 drivers/md/bcache/btree.c   | 23 +++++++++++++++++++++--
 drivers/md/bcache/io.c      |  2 ++
 drivers/md/bcache/journal.c |  2 +-
 drivers/md/bcache/request.c | 13 ++++++++++++-
 4 files changed, 36 insertions(+), 4 deletions(-)
