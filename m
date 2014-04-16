Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaDPUQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:16:39 -0400
Received: from fn.samba.org ([216.83.154.106]:44446 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaDPUQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:16:36 -0400
Date: Wed, 16 Apr 2014 13:16:33 -0700
From: Jeremy Allison <jra@samba.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, libc-alpha <libc-alpha@sourceware.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        Jeremy Allison <jra@google.com>
Subject: Re: should we change the name/macros of file-private locks?
Message-ID: <20140416201633.GQ22791@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20140416145746.66b7441c@tlielax.poochiereds.net>
 <CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:00:46PM +0200, Michael Kerrisk (man-pages) wrote:
> [CC += Jeremy Allison]
> 
> On Wed, Apr 16, 2014 at 8:57 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > Sorry to spam so many lists, but I think this needs widespread
> > distribution and consensus.
> >
> > File-private locks have been merged into Linux for v3.15, and *now*
> > people are commenting that the name and macro definitions for the new
> > file-private locks suck.
> >
> > ...and I can't even disagree. They do suck.
> >
> > We're going to have to live with these for a long time, so it's
> > important that we be happy with the names before we're stuck with them.
> 
> So, to add my perspective: The existing byte-range locking system has
> persisted (despite egregious faults) for well over two decades. One
> supposes that Jeff's new improved version might be around
> at least as long. With that in mind, and before setting in stone (and
> pushing into POSIX) a model of thinking that thousands of programmers
> will live with for a long time, it's worth thinking about names.
> 
> > Michael Kerrisk suggested several names but I think the only one that
> > doesn't have other issues is "file-associated locks", which can be
> > distinguished against "process-associated" locks (aka classic POSIX
> > locks).
> 
> The names I have suggested are:
> 
>     file-associated locks
> 
> or
> 
>    file-handle locks
> 
> or (using POSIX terminology)
> 
>     file-description locks

Thanks for the CC: Michael, but to be honest
I don't really care what the name is, I just
want the functionality. I can change our build
system to cope with detecting it under any name
you guys choose :-).

Cheers,

	Jeremy.
