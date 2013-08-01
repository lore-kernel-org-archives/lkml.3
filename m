Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3HACrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:47:32 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:40167 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3HACrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:47:31 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130731142430.GA4545@redhat.com>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
	<20130730221435.GA22240@redhat.com>
	<20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
	<20130730231533.GA26824@redhat.com>
	<20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
	<20130731000444.GC1281@redhat.com>
	<20130731094012.GU24642@n2100.arm.linux.org.uk>
	<20130731142430.GA4545@redhat.com>
Date: Wed, 31 Jul 2013 19:47:30 -0700
Message-ID: <CAOesGMiBa7fT+HZquNrwV=3P=Z-F9c8L7YQr7=D2BO_6pJXQ0w@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit mitigations
From: Olof Johansson <olof@lixom.net>
To: Dave Jones <davej@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 7:24 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Jul 31, 2013 at 10:40:12AM +0100, Russell King - ARM Linux wrote:
>  > On Tue, Jul 30, 2013 at 08:04:44PM -0400, Dave Jones wrote:
>  > > To use ARM as an example, the bugs I've seen have mostly been in arch specific
>  > > code that does things like page-table manipulation.  The chromebook bugs I
>  > > was hitting for eg were various kinds of PTE corruption warnings.
>  >
>  > Hmm, really?  Did you reported these bugs?  I'm not aware of mainline
>  > having any changes related to bug reports on PTEs on ARM.
>
> I wasn't sure if it was a googleism, or happens on mainline, so no.

We'd definitely be interested in hearing about what you've found. The
3.4 kernel has a lot of out-of-tree code for exynos, we've reduced it
quite a bit on the upcoming 3.8 one but it needs a bit more baking.

As of 3.10, it's not actually hard to run a mainline kernel on the
chromebook, but you have limited functionality (no wifi, no USB3, no
accellerated graphics). Easiest is to do it by booting from SD card.
See instructions at
http://www.chromium.org/chromium-os/u-boot-porting-guide/using-nv-u-boot-on-the-samsung-arm-chromebook.


How long would a useful run of trinity take? I've got an
autobuilder/autobooter setup here with a cross-section of current ARM
hardware (7 platforms and counting) that I mostly do boot testing on,
and I should add a smallish suite of testcases to the same. Trinity
would be a good candidate for that.


-Olof
