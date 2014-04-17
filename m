Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbaDQAcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:32:14 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:50526
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756802AbaDQAcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:32:12 -0400
From: Jim Lieb <jlieb@panasas.com>
To: <nfs-ganesha-devel@lists.sourceforge.net>, Jeremy Allison <jra@samba.org>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        Jeff Layton <jlayton@redhat.com>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        "Carlos O'Donell" <carlos@redhat.com>,
        <samba-technical@lists.samba.org>, lkml <linux-kernel@vger.kernel.org>,
        Jeremy Allison <jra@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Re: [Nfs-ganesha-devel] should we change the name/macros of file-private locks?
Date: Wed, 16 Apr 2014 17:31:11 -0700
Message-ID: <2369283.4ufWfMqZox@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.5 (Linux/3.13.9-100.fc19.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140416201633.GQ22791@samba2>
References: <20140416145746.66b7441c@tlielax.poochiereds.net> <CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com> <20140416201633.GQ22791@samba2>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 13:16:33 Jeremy Allison wrote:
> On Wed, Apr 16, 2014 at 10:00:46PM +0200, Michael Kerrisk (man-pages) wrote:
> > [CC += Jeremy Allison]
> > 
> > On Wed, Apr 16, 2014 at 8:57 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > > Sorry to spam so many lists, but I think this needs widespread
> > > distribution and consensus.
> > > 
> > > File-private locks have been merged into Linux for v3.15, and *now*
> > > people are commenting that the name and macro definitions for the new
> > > file-private locks suck.
> > > 
> > > ...and I can't even disagree. They do suck.
> > > 
> > > We're going to have to live with these for a long time, so it's
> > > important that we be happy with the names before we're stuck with them.
> > 
> > So, to add my perspective: The existing byte-range locking system has
> > persisted (despite egregious faults) for well over two decades. One
> > supposes that Jeff's new improved version might be around
> > at least as long. With that in mind, and before setting in stone (and
> > pushing into POSIX) a model of thinking that thousands of programmers
> > will live with for a long time, it's worth thinking about names.
> > 
> > > Michael Kerrisk suggested several names but I think the only one that
> > > doesn't have other issues is "file-associated locks", which can be
> > > distinguished against "process-associated" locks (aka classic POSIX
> > > locks).
> > 
> > The names I have suggested are:
> >     file-associated locks
> > 
> > or
> > 
> >    file-handle locks
> > 
> > or (using POSIX terminology)
> > 
> >     file-description locks
> 
> Thanks for the CC: Michael, but to be honest
> I don't really care what the name is, I just
> want the functionality. I can change our build
> system to cope with detecting it under any name
> you guys choose :-).
> 
> Cheers,
> 
> 	Jeremy.

I and the rest of the nfs-ganesha community are with Jeremy and samba wrt 
names.  We just want locks that work, i.e. Useful Locks ;)

Jim
> 
> ----------------------------------------------------------------------------
> -- Learn Graph Databases - Download FREE O'Reilly Book
> "Graph Databases" is the definitive new guide to graph databases and their
> applications. Written by three acclaimed leaders in the field,
> this first edition is now available. Download your free book today!
> http://p.sf.net/sfu/NeoTech
> _______________________________________________
> Nfs-ganesha-devel mailing list
> Nfs-ganesha-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/nfs-ganesha-devel

-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
