Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaDQXsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaDQXsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:48:07 -0400
Date: Thu, 17 Apr 2014 19:47:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: mtk.manpages@gmail.com
Cc: "Stefan (metze) Metzmacher" <metze@samba.org>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        lkml <linux-kernel@vger.kernel.org>, Jeremy Allison <jra@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Subject: Re: should we change the name/macros of file-private locks?
Message-ID: <20140417194748.312c6db0@tlielax.poochiereds.net>
In-Reply-To: <CAKgNAki6x96GT_Ck_1S8v6GhXGZ1NM4o_3yNiybXOSq20bUWjQ@mail.gmail.com>
References: <20140416145746.66b7441c@tlielax.poochiereds.net>
	<CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>
	<534F0745.70705@samba.org>
	<20140417075254.28e470ed@tlielax.poochiereds.net>
	<534FC342.8010008@gmail.com>
	<CAKgNAki6x96GT_Ck_1S8v6GhXGZ1NM4o_3yNiybXOSq20bUWjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 22:08:54 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> >> In the docs we could take pains to point out that these are
> >> file-_description_ locks and not file-_descriptor_ locks, and outline
> >> why that is so (which is something I'm trying to make crystal clear in
> >> the docs anyway).
> >>
> >> Does anyone object to that?
> >
> > Well, I'd be silly to object, but maybe we should still allow a day
> > for further comment?
> 
> Jeff,
> 
> One further point. I know the intent is to get this scheme into POSIX.
> Have any conversations happened about this so far on the POSIX/Austin
> lists? If yes, it might be worth also linking those folks into the
> naming discussion..
> 
> Cheers,
> 
> Michael

Yes, good idea. The open bug is here:

    http://austingroupbugs.net/view.php?id=768

I'll write something up there and see if they want to chime in on the
discussion.

-- 
Jeff Layton <jlayton@redhat.com>
