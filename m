Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3DXI3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:29:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38493 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3DXI3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:29:40 -0400
Date: Wed, 24 Apr 2013 10:29:38 +0200
From: Pavel Machek <pavel@denx.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>, LKML <linux-kernel@vger.kernel.org>,
        Kenneth Chong Yin Tan <cytan@altera.com>
Subject: Re: Linux kernel support -O0 optimization flag?
Message-ID: <20130424082934.GA9365@amd.pavel.ucw.cz>
References: <1366012739.21182.4.camel@leyfoon-vm>
 <CAFLxGvw7Cj_wz_A9B+fBR6jYxi+73Ofh-PjUT=FC+iF0AkDQsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvw7Cj_wz_A9B+fBR6jYxi+73Ofh-PjUT=FC+iF0AkDQsQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-04-15 13:16:36, richard -rw- weinberger wrote:
> On Mon, Apr 15, 2013 at 9:58 AM, Ley Foon Tan <lftan@altera.com> wrote:
> >
> >
> > Change KBUILD_CFLAGS to -O0 in Makefile and got the compilation error as
> > below.
> > Is the Linux kernel support -O0 optimization flag?
> 
> No. If I'm not mistaken we need this to make sure that the compiler
> inlines some functions.
> 
> In your case the compiler failed to compute the BUILD_BUG() macro correctly.
> It depends also on optimization.

Actually... You probably could replace BUILD_BUG() with nop. Bugs are
not expected to happen, right? you'll probably hit something else...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
