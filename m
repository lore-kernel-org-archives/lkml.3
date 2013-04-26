Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3DZTqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:46:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3DZTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:46:29 -0400
Date: Fri, 26 Apr 2013 12:46:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Chanho Min" <chanho.min@lge.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Bob Pearson'" <rpearson@systemfabricworks.com>,
        "'Richard Weinberger'" <richard@nod.at>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "'Yann Collet'" <yann.collet.73@gmail.com>,
        =?UTF-8?Q?=EC=9D=B4=EA=B2=BD=EC=8B=9D?= <kyungsik.lee@lge.com>,
        "'Linux/m68k'" <linux-m68k@vger.kernel.org>,
        "'sparclinux'" <sparclinux@vger.kernel.org>,
        "'Linux-Next'" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
Message-Id: <20130426124625.60bee0e2bcd255c62528e621@linux-foundation.org>
In-Reply-To: <20130426155105.337d821415d8bfa845bf23f5@canb.auug.org.au>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<5175014e.487a420a.4c58.ffffe0b9SMTPIN_ADDED_BROKEN@mx.google.com>
	<OF6B440C9E.4A0516C8-ON49257B59.001BA689-49257B59.001BA68A@lge.com>
	<20130426155105.337d821415d8bfa845bf23f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 15:51:05 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi,
> 
> On Fri, 26 Apr 2013 14:02:01 +0900 "Chanho Min" <chanho.min@lge.com> wrote:
> >
> > 
> > @@ -0,0 +1,23 @@
> > +#include <linux/kernel.h>
> > +
> > +int __attribute__((weak)) __clzsi2(int val)
> 
> We have __weak in <linux/compiler.h>

And lib/clz.c needs a few more includes, for EXPORT_SYMBOL,
BITS_PER_LONG maybe.

Plus a changelog and a signed-off-by, please.

