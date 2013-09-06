Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3IFU0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:26:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3IFU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:26:03 -0400
Date: Fri, 6 Sep 2013 16:25:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/for-jens-3.12 for Jens Axboe
Message-ID: <20130906202551.GA20743@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

I sent you a git pull a couple of weeks ago but I am not sure if
you pulled it. It does not look like it, so here it is again along
with an extra bug-fix.

Please git pull:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.12

which will give you bug-fixes to Xen blkfront and backend driver:

 drivers/block/xen-blkback/blkback.c |    3 +-
 drivers/block/xen-blkfront.c        |   44 ++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 9 deletions(-)

Roger Pau Monne (2):
      xen-blkfront: revoke foreign access for grants not mapped by the backend
      xen-blkfront: improve aproximation of required grants per request

Vegard Nossum (1):
      xen/blkback: fix reference counting

Please pull!
