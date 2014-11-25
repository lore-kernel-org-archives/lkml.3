Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbaKYO6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:58:01 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50120 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYO57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:57:59 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CA+icZUW4bennT=duj9hXq4+U5QLF7GivARA595C2KnRNzAdKAw@mail.gmail.com>
References: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
	<CA+icZUW4bennT=duj9hXq4+U5QLF7GivARA595C2KnRNzAdKAw@mail.gmail.com>
Date: Tue, 25 Nov 2014 15:57:58 +0100
Message-ID: <CAJfpegvE76UbMPaoHQ8tc2tERjP_N2xiaJRwDp3yBgH2uUocdw@mail.gmail.com>
Subject: Re: [PULL for 3.18] overlay filesystem v24
From: Miklos Szeredi <miklos@szeredi.hu>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 1:56 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:

> Is the documentation up2date?

Should be.  If you find any issues, please let me know (patch is also welcome).

> Some files below fs/overlayfs/ have copyright pointing to year 2011 by
> Novell - needs an update?

Not even sure who's my employer at the moment ;)

> Thought about a co-maintainer?

No.

> Docs could have a pointer to the testsuite by David Howells [1]?

Sure, that's a good idea.  Patch queued.

Thanks,
Miklos
