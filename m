Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab3AQDtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:49:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab3AQDtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:49:47 -0500
Date: Wed, 16 Jan 2013 19:54:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, sedat.dilek@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.8-rc2 lockdep complains about console_lock vs.
 fb_notifier_list.rwsem
Message-Id: <20130116195416.c2d9a107.akpm@linux-foundation.org>
In-Reply-To: <20130117024246.GF20928@kroah.com>
References: <CA+icZUUxgRsGkYAmZ=JxTwPvdhTzpGLcxm6+VSq9jnfYPVXj4Q@mail.gmail.com>
	<s5hpq16zfox.wl%tiwai@suse.de>
	<CA+icZUWFKzccbHrU0pxK-T2TdwyDsTTNxP_22zmGTPbcAmhMaQ@mail.gmail.com>
	<s5hpq1531yn.wl%tiwai@suse.de>
	<20130117024246.GF20928@kroah.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 18:42:46 -0800 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > FWIW, Andrew took my patch in mm:
> >   http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
> >   http://ozlabs.org/~akpm/mmots/broken-out/fb-yet-another-band-aid-for-fixing-lockdep-mess.patch
> 
> 
> Ok, so, which one should I take for 3.8?  And ideally the fb maintainer
> should do this, not I, right?

Please see http://www.spinics.net/lists/linux-fbdev/msg08954.html

Tomi might be able to review the above for us.  I think we need both. 
If nothing else happens I intend to send both Linuswards for 3.8 in a
week or two.
