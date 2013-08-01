Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3HADAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab3HADAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:00:19 -0400
Date: Wed, 31 Jul 2013 22:59:11 -0400
From: Dave Jones <davej@redhat.com>
To: Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130801025911.GA20166@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Olof Johansson <olof@lixom.net>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	"ksummit-2013-discuss@lists.linuxfoundation.org" <ksummit-2013-discuss@lists.linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130730221435.GA22240@redhat.com>
 <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
 <20130730231533.GA26824@redhat.com>
 <20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
 <20130731000444.GC1281@redhat.com>
 <20130731094012.GU24642@n2100.arm.linux.org.uk>
 <20130731142430.GA4545@redhat.com>
 <CAOesGMiBa7fT+HZquNrwV=3P=Z-F9c8L7YQr7=D2BO_6pJXQ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiBa7fT+HZquNrwV=3P=Z-F9c8L7YQr7=D2BO_6pJXQ0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 07:47:30PM -0700, Olof Johansson wrote:

 > >  > Hmm, really?  Did you reported these bugs?  I'm not aware of mainline
 > >  > having any changes related to bug reports on PTEs on ARM.
 > >
 > > I wasn't sure if it was a googleism, or happens on mainline, so no.
 > 
 > As of 3.10, it's not actually hard to run a mainline kernel on the
 > chromebook, but you have limited functionality (no wifi, no USB3, no
 > accellerated graphics). Easiest is to do it by booting from SD card.
 > See instructions at
 > http://www.chromium.org/chromium-os/u-boot-porting-guide/using-nv-u-boot-on-the-samsung-arm-chromebook.
 
Yeah, that's how I got Fedora running on it (I think the people who did the
Fedora spin for the chromebook chose the google kernel for exactly
the reasons you mention above).  It felt a little sluggish for a native
kernel build though, and I'm not setup for cross-building so I stuck with
the 3.4 build.
 
 > How long would a useful run of trinity take?

It blew up in a minute or so of runtime when I tried last week.

 > I've got an autobuilder/autobooter setup here with a cross-section of current ARM
 > hardware (7 platforms and counting) that I mostly do boot testing on,
 > and I should add a smallish suite of testcases to the same. Trinity
 > would be a good candidate for that.

Feel free to mail me off-list if I can do anything to help out, though
hopefully things should build & run 'out of the box'.  You shouldn't
need any special command line args (though you might get inspiration
for ideas from the scripts/test-* harnesses)

	Dave

