Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbaGIOOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:14:33 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:55308 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbaGIOOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:14:30 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <25574.1404813385@warthog.procyon.org.uk>
References: <11446.1401420931@jrobl>
	<7184.1401439773@warthog.procyon.org.uk>
	<CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
	<15839.1401786056@warthog.procyon.org.uk>
	<CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
	<CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
	<10013.1401791634@warthog.procyon.org.uk>
	<20140603132153.GA26512@tucsk.piliscsaba.szeredi.hu>
	<19281.1401809418@warthog.procyon.org.uk>
	<17091.1403628374@warthog.procyon.org.uk>
	<20140708092848.GA26119@tucsk.piliscsaba.szeredi.hu>
	<25574.1404813385@warthog.procyon.org.uk>
Date: Wed, 9 Jul 2014 16:14:29 +0200
Message-ID: <CAJfpegtJ24ktUonDgb_1nC52yKyGEuvzusSm9xWns7nJyOwhgQ@mail.gmail.com>
Subject: Re: Overlayfs rename bug
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

On Tue, Jul 8, 2014 at 11:56 AM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Following patch fixes it and tests now run fine.
>
> Yep, that seems to fix it.  You can have my Tested-by back;-)  Are you going
> to release another branch in your git repo?

Updated series pushed to overlayfs.v23 and overlayfs.current.

Thanks,
Miklos
