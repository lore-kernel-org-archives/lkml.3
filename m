Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaE2TVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaE2TVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:21:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUWo9eD=0KqVapZ_2vWZfWrrSWauaXMRNvkmdy+4cXgAig@mail.gmail.com>
References: <CA+icZUWo9eD=0KqVapZ_2vWZfWrrSWauaXMRNvkmdy+4cXgAig@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com> <29026.1401383705@warthog.procyon.org.uk> <CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com> <29191.1401384252@warthog.procyon.org.uk> <CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com> <29410.1401385296@warthog.procyon.org.uk> <CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com> <31766.1401387746@warthog.procyon.org.uk> <CA+icZUWUjkp4kpsXZg+UeW5UbWU0D_aDKzh2S9_JYeLhNaWgFg@mail.gmail.com>
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
Date: Thu, 29 May 2014 20:20:20 +0100
Message-ID: <32659.1401391220@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> Hmm, why is the generated binary callled "open-file" and in the
> scripts I see "open_file"?

grep is your friend:-)  Look in tool_box.inc

David
