Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaC3XVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:21:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaC3XVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:21:12 -0400
Date: Mon, 31 Mar 2014 00:21:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs fixes
Message-ID: <20140330232110.GN18016@ZenIV.linux.org.uk>
References: <CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
 <20140323164526.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
 <CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
 <CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
 <CA+icZUWD7NekSyNa2Keg=+teDCGg-Ttc5Xb4wfKA-56FMwGSeg@mail.gmail.com>
 <CA+55aFwKqDzNCd1wQYZqKXb3DDj2bHYjHCYjDAkWJwPhuvR17A@mail.gmail.com>
 <20140330203307.GL18016@ZenIV.linux.org.uk>
 <20140330205537.GM18016@ZenIV.linux.org.uk>
 <CA+55aFw5WjjHPP0SZo8fZefG5_S4F=-V_oa0HV4sm+G167-4iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5WjjHPP0SZo8fZefG5_S4F=-V_oa0HV4sm+G167-4iA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 03:39:33PM -0700, Linus Torvalds wrote:
> On Sun, Mar 30, 2014 at 1:55 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Commit ID of that branch should be 7fc5aaa083922420e2dec5d985420cb5f959b1ce;
> > diffs are the same as what sat there since last Sunday, commit messages
> > got updated a bit.
> 
> Ugh. You have apparently rebased the parts that I already pulled too,
> which is annoying and causes duplicate commits.

Sorry, I'd only noticed your pull after sending that...  Missing commits
on top of linux.git#master are in vfs.git#for-linus-2, so if you prefer
to grab them from there, it's
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus-2

Shortlog:
Al Viro (4):
      resizable namespace.c hashes
      keep shadowed vfsmounts together
      don't bother with propagate_mnt() unless the target is shared
      switch mnt_hash to hlist

Diffstat:
 fs/mount.h     |    4 +--
 fs/namespace.c |  177 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
 fs/pnode.c     |   26 +++++++++------
 fs/pnode.h     |    4 +--
 4 files changed, 134 insertions(+), 77 deletions(-)

