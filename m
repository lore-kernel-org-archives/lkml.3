Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517Ab3BTC5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:57:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50852 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935502Ab3BTC5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:57:08 -0500
Date: Tue, 19 Feb 2013 21:57:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-jens-3.9
Message-ID: <20130220025703.GA26463@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.9

which has bug-fixes that did not make it in v3.8. They all are marked as
material for the stable tree as well. There are two bug-fixes for
the code that has been in there for some time (that is the Jan's fix
and one of mine). And there are two bug-fixes for the persistent grant
feature that debuted in v3.8 for xen blk[back|front]end.

Please pull!

 drivers/block/xen-blkback/blkback.c |  7 +++---
 drivers/block/xen-blkback/xenbus.c  | 49 ++++++++++++++++++-------------------
 drivers/block/xen-blkfront.c        | 13 +++++++---
 include/linux/llist.h               | 25 -------------------
 4 files changed, 38 insertions(+), 56 deletions(-)

Jan Beulich (1):
      xen-blkback: do not leak mode property

Konrad Rzeszutek Wilk (2):
      xen/blkback: Don't trust the handle from the frontend.
      xen-blkfront: drop the use of llist_for_each_entry_safe

Roger Pau Monne (1):
      xen-blkback: use balloon pages for persistent grants
