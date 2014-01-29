Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaA2VPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:15:14 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39490 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaA2VPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:15:12 -0500
Date: Wed, 29 Jan 2014 13:15:09 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] bcache fixes for 3.14
Message-ID: <20140129211509.GA2362@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, couple small bcache fixes for you:

The following changes since commit 9dd6358a21daf4fc6a5b2b779267a62f0d1d3181:

  bcache: Fix auxiliary search trees for key size > cacheline size (2014-01-08 13:05:15 -0800)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.14

for you to fetch changes up to e3b4825b85eab879b618af6ea18529ca7ab9a64f:

  bcache: bugfix - gc thread now gets woken when cache is full (2014-01-29 13:06:42 -0800)

----------------------------------------------------------------
Darrick J. Wong (1):
      bcache: fix BUG_ON due to integer overflow with GC_SECTORS_USED

Kent Overstreet (1):
      bcache: Minor fixes from kbuild robot

Nicholas Swenson (1):
      bcache: bugfix - gc thread now gets woken when cache is full

 drivers/md/bcache/bcache.h  | 4 +++-
 drivers/md/bcache/bset.c    | 7 +++++--
 drivers/md/bcache/btree.c   | 4 ++--
 drivers/md/bcache/extents.c | 2 +-
 drivers/md/bcache/request.c | 6 +++---
 drivers/md/bcache/sysfs.c   | 2 +-
 6 files changed, 15 insertions(+), 10 deletions(-)
