Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaCZQia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:38:30 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38297 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaCZQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:38:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
	<CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
	<20140323164526.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
	<CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
	<CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
Date: Wed, 26 Mar 2014 17:36:20 +0100
Message-ID: <CA+icZUWD7NekSyNa2Keg=+teDCGg-Ttc5Xb4wfKA-56FMwGSeg@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 1:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Just to clarify: the current vfs tree from Al works for you, no new issues?
>
> I was delaying the release first a day, and now I think I'll just do
> an rc8 after all (and do the final 3.14 next weekend), but I'd like to
> be sure what the status of Al's tree is.
>
> Al, can you send a new pull request with fixed information (assuming I
> understood correctly and everything in vfs-land works for Sedat).
>

Looking at [1] you did not pull-in the new changes.
Are you waiting for a new pull-request?

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3e79d97828841305e3369ad1e07cfed5bf5989ef

>> P.S.: [Off-topic] With vanilla -66 kernel I have some OOPS in the
>> oom[1..5] tests of LTP. Whom to adress? mm-folks?
>
> Yes, please send to -mm (and cc lkml and me).
>
>             Linus
