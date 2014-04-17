Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaDQUJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:09:25 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59981 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDQUJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:09:15 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <534FC342.8010008@gmail.com>
References: <20140416145746.66b7441c@tlielax.poochiereds.net>
 <CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>
 <534F0745.70705@samba.org> <20140417075254.28e470ed@tlielax.poochiereds.net> <534FC342.8010008@gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 17 Apr 2014 22:08:54 +0200
Message-ID: <CAKgNAki6x96GT_Ck_1S8v6GhXGZ1NM4o_3yNiybXOSq20bUWjQ@mail.gmail.com>
Subject: Re: should we change the name/macros of file-private locks?
To: Jeff Layton <jlayton@redhat.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        lkml <linux-kernel@vger.kernel.org>, Jeremy Allison <jra@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In the docs we could take pains to point out that these are
>> file-_description_ locks and not file-_descriptor_ locks, and outline
>> why that is so (which is something I'm trying to make crystal clear in
>> the docs anyway).
>>
>> Does anyone object to that?
>
> Well, I'd be silly to object, but maybe we should still allow a day
> for further comment?

Jeff,

One further point. I know the intent is to get this scheme into POSIX.
Have any conversations happened about this so far on the POSIX/Austin
lists? If yes, it might be worth also linking those folks into the
naming discussion..

Cheers,

Michael
