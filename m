Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbbALTwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:52:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbALTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:52:29 -0500
Date: Mon, 12 Jan 2015 11:52:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH 00/25] line6usb cleanup
Message-ID: <20150112195227.GA5452@kroah.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
 <s5h8uh94nce.wl-tiwai@suse.de>
 <CAEUsAPaDdXO_0z0sWp_M_sYV69N44+Ea7eqm1VvPA2mONUerag@mail.gmail.com>
 <s5hh9vwj6tm.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hh9vwj6tm.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:35:01PM +0100, Takashi Iwai wrote:
> At Sun, 11 Jan 2015 15:04:55 -0600,
> Chris Rorvick wrote:
> > 
> > > At Fri,  9 Jan 2015 23:35:46 -0600,
> > > Chris Rorvick wrote:
> > >>
> > >> I have a TonePort UX2 that I've used for testing, meaning that some of
> > >> this is really only compile-tested.
> > >
> > > If anyone is responsible for testing with real hardware, I'll happily
> > > review.
> > 
> > To be clear, the TonePort UX2 is real hardware.  But this driver
> > basically supports four classes of Line 6 devices and I'm only covering
> > one of them.
> > 
> > So this series is a first step in trying to address this.  Having this
> > as a single driver probably made sense when it was a separate project,
> > but now that it is in-tree it seems like the POD, PODHD, TonePort, and
> > Variax pieces should each be separate drivers that each depend on a core
> > Line 6 driver.  I think the cleanup in this series will make that
> > easier.  None of this is my area of expertise, though, so advice and
> > feedback is very welcome.
> > 
> > > are there any active developers for this driver?
> > 
> > I intended to do further work.  I know there is quite a bit of mundane
> > checkpatch cleanup that would need to get done before this could get
> > promoted, and I believe I read that it's using sysfs for stuff that
> > would normally be done via an ALSA interface, and the sysfs interface
> > has not been documented nor has it been justified.  All stuff I thought
> > I might look into.
> > 
> > But I'm just doing this for fun so I can't promise anything.  :-)
> 
> OK, so the situation looks fairly good, we have a few active
> developers and/or testers.  And the current code doesn't look so
> terrible despite of it being in staging directory.  That said, I think
> we can promote this stuff into sound/usb/line6 directory, then apply
> Chris' cleanup patches, and work on it further.
> 
> Does it sound OK for you guys?  Greg?
> 
> Once when I get approval, I'll start a new clean branch on sound.git
> tree so that you guys can work on it further for 3.20 kernel.

That sounds fine with me.  I have 4 other patches in my "to-apply" queue
other than these 25 for this driver that I'll forward on to you for
inclusion in your tree.

thanks,

greg k-h
