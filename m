Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243Ab3HOHH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:07:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47962 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3HOHHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:07:25 -0400
Date: Thu, 15 Aug 2013 00:07:29 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: [GIT PULL] bcache fixes for 3.11
Message-ID: <20130815070729.GC6427@kmo-pixel>
References: <20130814225904.GA6427@kmo-pixel>
 <520C788A.1060208@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520C788A.1060208@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 08:43:22AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 15.08.2013 00:59, schrieb Kent Overstreet:
> > Jens, here's the latest bcache fixes. Some urgent stuff in here:
> > 
> > 
> > The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:
> > 
> >   bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11
> > 
> > for you to fetch changes up to 0434a516e99ee51ac2d0dfa71b2f56c89ac5db05:
> > 
> >   bcache: Fix a flush/fua performance bug (2013-08-14 15:44:51 -0700)
> > 
> > ----------------------------------------------------------------
> > Gabriel de Perthuis (1):
> >       bcache: Strip endline when writing the label through sysfs
> > 
> > Geert Uytterhoeven (1):
> >       bcache: Correct printf()-style format length modifier
> > 
> > Kent Overstreet (4):
> >       bcache: Fix a dumb journal discard bug
> >       bcache: Fix for when no journal entries are found
> >       bcache: Fix a writeback performance regression
> >       bcache: Fix a flush/fua performance bug
> > 
> >  drivers/md/bcache/bcache.h    |  7 +++----
> >  drivers/md/bcache/btree.c     |  2 +-
> >  drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
> >  drivers/md/bcache/sysfs.c     |  9 +++++++--
> >  drivers/md/bcache/util.c      | 11 ++++++++++-
> >  drivers/md/bcache/util.h      | 12 +++++++++---
> >  drivers/md/bcache/writeback.c | 37 ++++++++++++++++++-------------------
> >  7 files changed, 68 insertions(+), 43 deletions(-)
> > --
> 
> As 3.10 is long term stable release. You might need CC the stable list
> for patches which have to go to 3.10 as well.
> 
> At least this one should go to 3.10:
> > Gabriel de Perthuis (1):
> >       bcache: Strip endline when writing the label through sysfs

That patch is fixing a bug in code that was merged for 3.11 - the rest
are marked for stable :)
