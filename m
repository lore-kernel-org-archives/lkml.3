Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3GFVho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 17:37:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64399 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751984Ab3GFVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 17:37:42 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression in 3.10] Garbage displayed after resume on Acer Aspire S5
Date: Sat, 06 Jul 2013 23:47:23 +0200
Message-ID: <5405301.QyFoc5XpoA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1984848.xM0OMxBOCk@vostro.rjw.lan>
References: <1511667.B4N0cEgdH9@vostro.rjw.lan> <CAKMK7uG-=XYCi31=ayvbd-jy-tQh=e1r8w+wdpJriOdY8WHnRg@mail.gmail.com> <1984848.xM0OMxBOCk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 06, 2013 10:26:28 PM Rafael J. Wysocki wrote:
> On Saturday, July 06, 2013 04:16:36 PM Daniel Vetter wrote:
> > On Sat, Jul 6, 2013 at 3:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Hi,
> > >
> > > I've just started to play with a new Acer Aspire S5 test box and noticed that
> > > garbage is displayed after resume from suspend to RAM with the 3.10 kernel
> > > (under KDE 4.10.3 on openSUSE 12.3).  The display corruption goes away after
> > > killing X and restarting it.
> > >
> > > The CPU is a Core i5-3317U (Ivy Bridge), i915 graphics.
> > >
> > > That doesn't happen with 3.9 (same config otherwise).  It also doesn't happen
> > > with my older Sandy Bridge-based box (with 3.10), so I suspect Ivy Bridge
> > > specifics.
> > >
> > > Is this known?  Do you want me to bisect?
> > 
> > Screenshot of the garbage would be a good start I'd say.
> 
> Well, it's just garbage.  Attached anyway.

To be precise, the screen right after resume doesn't look like this
(as I said in https://bugzilla.kernel.org/show_bug.cgi?id=60530 created
to track this issue - more screens attached in there).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
