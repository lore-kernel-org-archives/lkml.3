Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaC1IRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:17:18 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:35764 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaC1IRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:17:14 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2014 04:17:14 EDT
Date: Fri, 28 Mar 2014 09:08:27 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, dtor@mail.ru,
        linux-input@vger.kernel.org, jkosina@suse.cz,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 8 months to review a patch (was Re: [PATCH] Route kbd LEDs
 through the generic LEDs layer)
Message-ID: <20140328080827.GI23627@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, dtor@mail.ru,
	linux-input@vger.kernel.org, jkosina@suse.cz,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
	Richard Purdie <rpurdie@rpsys.net>,
	LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130713093552.GU8252@type>
 <20130715091230.GA8786@amd.pavel.ucw.cz>
 <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
 <20140316101946.GJ6436@type.youpi.perso.aquilenet.fr>
 <CAHYPw2EAgjdcNATy0d6DhbT9qHAHJLda7gsLrnSJ7F4Cj=a-JQ@mail.gmail.com>
 <20140328070136.GA15953@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140328070136.GA15953@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Fri 28 Mar 2014 08:01:36 +0100, a écrit :
> On Thu 2014-03-27 02:08:17, Pali Rohár wrote:
> > 2014-03-16 11:19 GMT+01:00 Samuel Thibault <samuel.thibault@ens-lyon.org>:
> > > Pali Rohár, le Sun 16 Mar 2014 11:16:25 +0100, a écrit :
> > >> Hello, what happened with this patch? Is there any problem with accepting it?
> > >
> > > Dmitry finding time to review it, I guess.
> 
> > Dmitry, can you look and review this patch?
> 
> Dmitry, what happened to you, are you there? This patch is like 8
> months old,

Well, the patch was written in Feb 2010 actually, it got some reviews
overs years, the version submitted in July 2013 is the same as the one
submitted in Dec 2013.

Samuel
