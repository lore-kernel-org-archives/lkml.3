Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab3G3X6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:58:43 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:59709 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3G3X6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:58:42 -0400
Date: Wed, 31 Jul 2013 02:58:34 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130730221435.GA22240@redhat.com>
 <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
 <20130730231533.GA26824@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730231533.GA26824@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 30, 2013 at 07:15:33PM -0400, Dave Jones wrote:
> On Wed, Jul 31, 2013 at 02:11:20AM +0300, Aaro Koskinen wrote:
>  > On Tue, Jul 30, 2013 at 06:14:35PM -0400, Dave Jones wrote:
>  > > On Tue, Jul 30, 2013 at 12:05:40PM -0700, Kees Cook wrote:
>  > >  > - fuzzing (is anyone running trinity or similar on the ARM tree?)
>  > >  
>  > > Someone was kind enough to send me an arm chromebook, so I tried this just
>  > > last week (albeit, on the 3.4 kernel it shipped with). The results make
>  > > me think the answer is a resounding 'no'.
>  > 
>  > Shouldn't you run trinity only under QEMU or similar virtual
>  > environment? Don't know about chromebook, but on some of my ARM boards
>  > a misbehaving kernel could at least in theory brick the board...
>  
> I like to live dangerously.  Don't imitate everything you see on TV,
> or read about on lkml.

Sadly I have no TV. :)

Anyway, I think it would be interesting to learn about arch-specific
bugs discovered with trinity. Quickly thinking, the results should be
mostly same regardless of the architecture since the code being tested
is generic especially when running as a regular user. But of course
there are 32/64-bit and big-endian/little-endian and such differences,
and maybe some permission bugs (likely in vendor kernels).

A.
