Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaFCKVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:21:06 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61480 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaFCKVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:21:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<11446.1401420931@jrobl>
	<7184.1401439773@warthog.procyon.org.uk>
	<CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
	<15839.1401786056@warthog.procyon.org.uk>
	<CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
	<CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
	<CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com>
Date: Tue, 3 Jun 2014 12:21:00 +0200
Message-ID: <CA+icZUUTqHbJ+x+HueD0z_MGJbfiS-H3nnW37BWbe9auurD8+A@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>,
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

On Tue, Jun 3, 2014 at 11:42 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jun 3, 2014 at 11:26 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Jun 3, 2014 at 11:18 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> [...]
>>>>> [ NOTE-2: The call-trace I have seen once (TERMSLASH=0). ]
>>>>
>>>> Do you know for which operation?
>
> This still looks like the same annotation problem in
> generic_file_splice_write() I already sent a patch for.
>
> Fix now pushed to overlayfs.v22/overlayfs.current.
>

Will you send this patch to Al separately or will it go through your tree?

[ Do you happen to know if LTP has some tests especially to test pipes? ]

- Sedat -
