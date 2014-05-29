Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaE2SXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaE2SXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:23:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com>
References: <CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com> <29026.1401383705@warthog.procyon.org.uk> <CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com> <29191.1401384252@warthog.procyon.org.uk> <CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com> <29410.1401385296@warthog.procyon.org.uk>
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
Date: Thu, 29 May 2014 19:22:26 +0100
Message-ID: <31766.1401387746@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> >         TEST_OVERLAYFS=1 ./run.sh
> >
> > right?
> >
> 
> Yes (with my mount-patch applied).
> 
> ( ...and... # umount /lower /upper /mnt )

Can you put a couple of echo commands in settings.inc to show which side of
the if-statement it goes and also put:

	echo TEST_OVERLAYFS is $TEST_OVERLAYFS

in run.sh and mount_union.sh?

David
