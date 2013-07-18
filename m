Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3GRQdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:33:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39002 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660Ab3GRQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:33:04 -0400
Date: Thu, 18 Jul 2013 12:33:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: T Makphaibulchoke <tmac@hp.com>, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        tmakph@gmail.com, aswin@hp.com
Subject: Re: [PATCH 0/2] ext4: increase mbcache scalability
Message-ID: <20130718163301.GB12727@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	T Makphaibulchoke <tmac@hp.com>, viro@zeniv.linux.org.uk,
	adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tmakph@gmail.com, aswin@hp.com
References: <1374108910-50444-1-git-send-email-tmac@hp.com>
 <20130718163024.GA12727@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718163024.GA12727@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:30:24PM -0400, Theodore Ts'o wrote:
> On Wed, Jul 17, 2013 at 06:55:10PM -0600, T Makphaibulchoke wrote:
> > This patch intends to improve the scalability of an ext4 filesystem by
> > introducing higher degree of parallelism to the usages of its mb_cache and
> > mb_cache_entries.
> >
> > ...
> >
> >  fs/ext4/ext4.h          |   1 +
> >  fs/ext4/super.c         |   8 ++
> >  fs/ext4/xattr.c         |  41 +++++---
> >  fs/ext4/xattr.h         |   3 +
> >  fs/mbcache.c            | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
> >  include/linux/mbcache.h |   5 +
> >  6 files changed, 385 insertions(+), 105 deletions(-)
> > 
> 
> I see the diff stats, but there was no patch attached to your message.
> Could you please resend the patch to the linux-ext4 list?

Never mind, I see them now.  I didn't notice this was a 0/2 message,
and since you are apparently using an old versio of git which doesn't
enable --thread by default (or you have a git config setting which
disables the use of mail threading), I didn't see the patches chained
to the message.

Sorry for being confused,

						- Ted
