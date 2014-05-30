Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaE3Hyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:54:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbaE3Hyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:54:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUUqiOudA62bK1kb6nd2GmLei3D06+-GFYXEabXGu4afhg@mail.gmail.com>
References: <CA+icZUUqiOudA62bK1kb6nd2GmLei3D06+-GFYXEabXGu4afhg@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com> <29026.1401383705@warthog.procyon.org.uk> <CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com> <29191.1401384252@warthog.procyon.org.uk> <CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com> <29410.1401385296@warthog.procyon.org.uk> <CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com> <31766.1401387746@warthog.procyon.org.uk> <CA+icZUWUjkp4kpsXZg+UeW5UbWU0D_aDKzh2S9_JYeLhNaWgFg@mail.gmail.com> <19229.1401392143@warthog.procyon.org.uk> <CA+icZUWoO0YpwLT9GEagDzq6C-qUPboh7CsXnJAu=Ya2hb0B4w@mail.gmail.com> <20482.1401397155@warthog.procyon.org.uk>
To: sedat.dilek@gmail.com
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Subject: Re: Unionmount and overlayfs testsuite
Date: Fri, 30 May 2014 08:54:00 +0100
Message-ID: <6273.1401436440@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> umount: /mnt: not mounted

Don't worry about that.

> TEST104: Impermissible utimes
>  - fs_op_as_bin utimes /mnt/a/rootfile104 -E EACCES
> /mnt/a/rootfile104: Test file not on upper filesystem (line 130)

That might be a failure in overlayfs.

David
