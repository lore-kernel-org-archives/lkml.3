Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab3GRQac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:30:32 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38995 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab3GRQab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:30:31 -0400
Date: Thu, 18 Jul 2013 12:30:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: T Makphaibulchoke <tmac@hp.com>
Cc: viro@zeniv.linux.org.uk, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, tmakph@gmail.com, aswin@hp.com
Subject: Re: [PATCH 0/2] ext4: increase mbcache scalability
Message-ID: <20130718163024.GA12727@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	T Makphaibulchoke <tmac@hp.com>, viro@zeniv.linux.org.uk,
	adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tmakph@gmail.com, aswin@hp.com
References: <1374108910-50444-1-git-send-email-tmac@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374108910-50444-1-git-send-email-tmac@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 06:55:10PM -0600, T Makphaibulchoke wrote:
> This patch intends to improve the scalability of an ext4 filesystem by
> introducing higher degree of parallelism to the usages of its mb_cache and
> mb_cache_entries.
>
> ...
>
>  fs/ext4/ext4.h          |   1 +
>  fs/ext4/super.c         |   8 ++
>  fs/ext4/xattr.c         |  41 +++++---
>  fs/ext4/xattr.h         |   3 +
>  fs/mbcache.c            | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
>  include/linux/mbcache.h |   5 +
>  6 files changed, 385 insertions(+), 105 deletions(-)
> 

I see the diff stats, but there was no patch attached to your message.
Could you please resend the patch to the linux-ext4 list?

Thanks,

						- Ted
