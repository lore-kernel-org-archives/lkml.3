Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaFCPxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:53:52 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:52973 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFCPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:53:50 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <19281.1401809418@warthog.procyon.org.uk>
References: <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com>
	<1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<11446.1401420931@jrobl>
	<7184.1401439773@warthog.procyon.org.uk>
	<CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
	<15839.1401786056@warthog.procyon.org.uk>
	<CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
	<CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
	<10013.1401791634@warthog.procyon.org.uk>
	<20140603132153.GA26512@tucsk.piliscsaba.szeredi.hu>
	<19281.1401809418@warthog.procyon.org.uk>
Date: Tue, 3 Jun 2014 17:53:49 +0200
Message-ID: <CAJfpegvSkr4NJJOfPH4MOhYvaLe=yWv_pR9kK4uiRpScyiapig@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 5:30 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> And this one is a missing annotation in overlayfs.  Tested patch pushed to the
>> usual branches.
>
> Looks good so far, though there are a few more bits to try and break -
> rename() for example.
>
> I also want to rewrite my test stuff in something a little more wieldy than
> shell scripts - Perl or Python for example.

Shell script is the one I'm most familiar with, and that maybe true
for other kernel developers too.

Also, it's what xfstests are using and it would make sense to move
towards that.  Although I'm not sure how well it supports
multiple-device filesystems.

>
> Tentative Tested-by from me unless I can break it.

Thanks for testing.

Miklos
