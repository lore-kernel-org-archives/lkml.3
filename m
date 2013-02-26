Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3BZDpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:45:52 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52285 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3BZDps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:45:48 -0500
Date: Mon, 25 Feb 2013 19:45:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: resume fails to light display on Macbook Pro Retina on 3.8-rc1
Message-ID: <20130226034545.GA1089@kroah.com>
References: <CAPM=9txjG5rohsNbme=myrX+-Z5eucpEXYQMWqPQqN=5dNze8g@mail.gmail.com>
 <CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
 <20130225223243.GA18744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225223243.GA18744@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 02:32:43PM -0800, Greg KH wrote:
> On Mon, Feb 25, 2013 at 04:06:02PM +1000, Dave Airlie wrote:
> > On Mon, Feb 25, 2013 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > Hi Ben,
> > >
> > > My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
> > > down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
> > > move link training helpers into core as display methods)
> > >
> > > Anything I can try to help solve this?
> > >
> > > Note, I'm using the Intel driver as the main controller for this laptop,
> > > well, I think I am, my xorg log is attached.
> > 
> > No you are using the nvidia, the efi always boots nvidia enabled now.
> 
> Really?  When did that change?  I thought I wanted to be using the Intel
> chip to save battery life.
> 
> > btw I just tested my drm-next tree on mine and it resumed the display
> > fine, something oopsed a few seconds later that I haven't tracked down
> > 
> > git://git.freedesktop.org/~airlied/linux drm-next
> > 
> > I'll be sending it to Linus this evening or tomorrow morning, once I
> > fix my tree.
> 
> Ok, I'll test again when it hits Linus's tree, and if that works, it
> would be good to try to work out what patch fixes it to get them into
> the 3.8-stable series so that others don't run into the same problem.

I've tested Linus's tree now (I'm guessing it has all of your changes in
it), and it works!

I see a bunch of patches marked for the stable branch, so I'll try those
out and see if they fix the problem.  If not, I'll let you and Ben know.

thanks,

greg k-h
