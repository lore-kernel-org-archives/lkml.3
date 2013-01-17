Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3AQEPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 23:15:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:45443 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393Ab3AQEPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 23:15:31 -0500
Date: Wed, 16 Jan 2013 20:16:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, sedat.dilek@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.8-rc2 lockdep complains about console_lock vs.
 fb_notifier_list.rwsem
Message-ID: <20130117041633.GA21551@kroah.com>
References: <CA+icZUUxgRsGkYAmZ=JxTwPvdhTzpGLcxm6+VSq9jnfYPVXj4Q@mail.gmail.com>
 <s5hpq16zfox.wl%tiwai@suse.de>
 <CA+icZUWFKzccbHrU0pxK-T2TdwyDsTTNxP_22zmGTPbcAmhMaQ@mail.gmail.com>
 <s5hpq1531yn.wl%tiwai@suse.de>
 <20130117024246.GF20928@kroah.com>
 <20130116195416.c2d9a107.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116195416.c2d9a107.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 07:54:16PM -0800, Andrew Morton wrote:
> On Wed, 16 Jan 2013 18:42:46 -0800 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > > FWIW, Andrew took my patch in mm:
> > >   http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
> > >   http://ozlabs.org/~akpm/mmots/broken-out/fb-yet-another-band-aid-for-fixing-lockdep-mess.patch
> > 
> > 
> > Ok, so, which one should I take for 3.8?  And ideally the fb maintainer
> > should do this, not I, right?
> 
> Please see http://www.spinics.net/lists/linux-fbdev/msg08954.html
> 
> Tomi might be able to review the above for us.  I think we need both. 
> If nothing else happens I intend to send both Linuswards for 3.8 in a
> week or two.

Ok, that sounds fine with me, thanks for doing that.

greg k-h
