Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbaDQUeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:34:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33418 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDQUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:34:16 -0400
Date: Thu, 17 Apr 2014 21:34:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tytso@mit.edu
Subject: Re: linus-next stats (Re: Linux 3.15-rc1 out, merge window closed)
Message-ID: <20140417203412.GB18016@ZenIV.linux.org.uk>
References: <CA+55aFykrvKAe29pTUqq8Oc2FKtnFWwU7vxbTQXa7ysZ6xxMXw@mail.gmail.com>
 <20140414180629.198f98cadef124a99439b0b1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414180629.198f98cadef124a99439b0b1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 06:06:29PM +1000, Stephen Rothwell wrote:
> Top ten authors:
> 
>      61 viro@zeniv.linux.org.uk

Guilty as charged.  Hopefully, this cycle it'll be better - I've just opened 
vfs.git#for-next branch (more iov_iter stuff, for now).  There's a couple
of trivial conflicts with ceph and cifs trees (I can send you a prefered
conflict resolution if you want, but it's really as trivial as it gets) and
one non-trivial in ext4 that I've dealt with by merging a piece of ext4
branch up to the relevant point.  As long as ext4.git#dev isn't rebased,
everything should remain fine, when/if it does I'll just redo that merge.
BTW, ext4 side of that thing is *still* not quite right - playing with
rlimit allows one to smuggle an unaligned write past that check...
