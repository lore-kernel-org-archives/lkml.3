Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaE3E3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:29:50 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:40298 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaE3E3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:29:45 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUqiOudA62bK1kb6nd2GmLei3D06+-GFYXEabXGu4afhg@mail.gmail.com>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
	<CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com>
	<29191.1401384252@warthog.procyon.org.uk>
	<CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com>
	<29410.1401385296@warthog.procyon.org.uk>
	<CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com>
	<31766.1401387746@warthog.procyon.org.uk>
	<CA+icZUWUjkp4kpsXZg+UeW5UbWU0D_aDKzh2S9_JYeLhNaWgFg@mail.gmail.com>
	<19229.1401392143@warthog.procyon.org.uk>
	<CA+icZUWoO0YpwLT9GEagDzq6C-qUPboh7CsXnJAu=Ya2hb0B4w@mail.gmail.com>
	<20482.1401397155@warthog.procyon.org.uk>
	<CA+icZUUqiOudA62bK1kb6nd2GmLei3D06+-GFYXEabXGu4afhg@mail.gmail.com>
Date: Fri, 30 May 2014 06:29:43 +0200
Message-ID: <CA+icZUVukVE872+SyvXff5JHuD2jwbVnEGN7MDLb6YQ3rEOFhQ@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 6:15 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, May 29, 2014 at 10:59 PM, David Howells <dhowells@redhat.com> wrote:
>> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>>> "Fixable" in your testsuite?
>>
>> Done and pushed.
>>
>
> Thanks.
>
> I still see lots of...
>
> umount: /mnt: not mounted
>
> ...and impermissible.test fails here...
>
[...]
> TEST104: Impermissible utimes
>  - fs_op_as_bin utimes /mnt/a/rootfile104 -E EACCES
> /mnt/a/rootfile104: Test file not on upper filesystem (line 130)
>

rootfile104 is really not on /upper/ ...

# find /mnt/ /upper/ /lower/ -name rootfile104
/mnt/a/rootfile104
/lower/a/rootfile104

- Sedat -
